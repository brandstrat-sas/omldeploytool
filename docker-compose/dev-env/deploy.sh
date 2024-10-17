#!/bin/bash

set -e

# Colores para mensajes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Función para mostrar mensajes de error
function error_exit {
  echo -e "${RED}[ERROR] $1${NC}"
  exit 1
}

# Función para clonar un repositorio
function clone_repo {
  local repo_name=$1
  local repo_path=$2

  if [ ! -d "$repo_path" ]; then
    if [ "$gitlab_clone" == "ssh" ]; then
      git clone git@gitlab.com:omnileads/"$repo_name".git "$repo_path" || error_exit "Failed to clone $repo_name"
    else
      git clone https://gitlab.com/omnileads/"$repo_name".git "$repo_path" || error_exit "Failed to clone $repo_name"
    fi
    echo -e "${GREEN}[INFO] Cloned $repo_name${NC}"
  else
    echo -e "${YELLOW}[INFO] $repo_name already exists. Skipping clone.${NC}"
  fi
}

# Función para preparar el directorio omnileads-repos
function prepare_dir {
  local dir_name="omnileads-repos"

  if [ -d "$dir_name" ]; then
    rm -rf "$dir_name" || error_exit "Failed to remove existing $dir_name"
  fi
  mkdir "$dir_name" || error_exit "Failed to create $dir_name"
  cd "$dir_name" || error_exit "Failed to enter $dir_name"
}

# Función principal de despliegue
function deploy {
  prepare_dir

  echo "***[OML devenv] Cloning the repositories of modules"

  # Lista de repositorios principales
  local main_repos=("acd" "kamailio" "nginx" "pgsql" "rtpengine" "fastagi" "ami" "redis" "_interactions_processor" "_sentiment_analysis")
  for repo in "${main_repos[@]}"; do
    clone_repo "oml$repo" "oml$repo"
  done

  # Clonar repositorios adicionales
  local additional_repos=(
    "omnileads-websockets:omlwebsockets"
    "ominicontacto:omlapp"
    "acd_retrieve_conf"
    "omlqa"
    "omnidialer"
  )
  for repo_info in "${additional_repos[@]}"; do
    local repo_name="${repo_info%%:*}"
    local repo_path="${repo_info##*:}"
    clone_repo "$repo_name" "$repo_path"
  done

  # Clonar addons si es SSH
  if [ "$gitlab_clone" == "ssh" ]; then
    local addons=("premium_reports_app" "wallboard_app" "survey_app" "webphone_client_app")
    for addon in "${addons[@]}"; do
      clone_repo "$addon" "$addon"
    done
  fi

  echo -e "${GREEN}[INFO] All repositories were cloned in $(pwd)${NC}"
  sleep 2

  # Cambiar a ramas específicas en algunos repositorios
  local branch_repos_kamailio=("kamailio" "rtpengine")
  for repo in "${branch_repos_kamailio[@]}"; do
    cd "oml$repo" && git checkout oml-658-dev-kamailio-img-2024 && cd ..
  done

  local branch_repos_omlacd=("omlacd" "omnidialer" "omlapp")
  for repo in "${branch_repos_omlacd[@]}"; do
    cd "$repo" && git checkout oml-2679-dev-discador-oml && cd ..
  done
}

cd ..
cp ../env .env
docker-compose build
docker-compose up -d

# Manejo de parámetros de entrada
function parse_arguments {
  for arg in "$@"; do
    case $arg in
      --gitlab_clone=ssh|--gitlab_clone=https)
        gitlab_clone="${arg#*=}"
        shift
        ;;
      --help|-h)
        echo "
Usage: $0 --gitlab_clone=<ssh|https>

Options:
  --gitlab_clone   Specify cloning method (ssh or https)
  --help           Show this help message
"
        exit 0
        ;;
      *)
        echo -e "${YELLOW}[INFO] Default parameters: --gitlab_clone=https${NC}"
        gitlab_clone="https"
        ;;
    esac
  done

  # Validar si se estableció `gitlab_clone`
  if [[ -z "$gitlab_clone" ]]; then
    error_exit "Missing --gitlab_clone parameter. Use --help for usage."
  fi
}

# Script principal
function main {
  parse_arguments "$@"
  deploy
}

main "$@"


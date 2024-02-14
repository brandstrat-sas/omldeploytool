#!/bin/bash

ENDSTATE=$1

log_transition() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1, exec oml_cluster_transition.sh" >> /var/log/keepalive_transition.log
}

case $ENDSTATE in
    "BACKUP") # Acción para la transición al estado BACKUP
            log_transition "transition to BACKUP"
            systemctl stop nginx
            systemctl stop ami
            systemctl stop omnileads
            systemctl stop omlcron
            systemctl stop asterisk            
            ;;
    "FAULT")  # Acción para la transición al estado FAULT
            log_transition "transition to FAULT"
        #     systemctl stop asterisk
        #     systemctl stop omnileads
        #     systemctl stop nginx
            ;;
    "MASTER") # Acción para la transición al estado MASTER
            log_transition "transition to MASTER"
            systemctl restart asterisk
            sleep 5
            systemctl restart ami
            sleep 2
            systemctl restart omnileads            
            sleep 5
            systemctl restart nginx
            sleep 1
            systemctl restart omlcron
            ;;

    *)      log_transition "Unknown state ${ENDSTATE}"
            exit 1
            ;;
esac

exit 0
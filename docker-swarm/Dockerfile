FROM ubuntu:latest

RUN  apt update -y \
  && groupadd ansible -g 1000 \
  && adduser ansible --uid 1000 --gid 1000 --shell /bin/bash --home /home/ansible \
  && apt install bash sshpass python3-pip -y \
  && pip3 install 'ansible==2.10' \
  && apt autoremove -y \

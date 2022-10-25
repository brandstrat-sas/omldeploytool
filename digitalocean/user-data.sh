#!/bin/bash

linux_distribution=$(cat /etc/issue | grep Debian |awk '{print $1}')

case $linux_distribution in
  Debian)
    apt update
    ;;
  *)
    yum -y install python3 python3-pip epel-release ansible awscli git libselinux-python3
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    systemctl disable firewalld > /dev/null 2>&1
    systemctl stop firewalld > /dev/null 2>&1
    ;;
esac

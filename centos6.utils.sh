#!/bin/bash

. <(curl -LRs initsh.github.io/check.root.sh)

yum -y install yum-utils
yum -y install expect
yum -y install net-tools
yum -y install bind-utils
yum -y install traceroute
yum -y install nmap
yum -y install nc
yum -y install tcpdump
yum -y install mailx
yum -y install lsof
yum -y install parted
yum -y install openssh-clients
yum -y install telnet
yum -y install wget
yum -y install zip
yum -y install unzip
yum -y install vim-enhanced

#EOF

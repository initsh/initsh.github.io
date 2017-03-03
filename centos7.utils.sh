#!/bin/bash

. <(curl -LRs initsh.github.io/check.centos7.sh)
. <(curl -LRs initsh.github.io/check.root.sh)

yum -y install yum-utils expect net-tools bind-utils traceroute nmap nc tcpdump mailx lsof parted openssh-clients telnet wget zip unzip vim-enhanced

#EOF

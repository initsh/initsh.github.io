#!/bin/bash
bash <(curl -Ls initsh.github.io/centos6.selinux.sh)
bash <(curl -Ls initsh.github.io/centos7.firewalld.sh)
bash <(curl -Ls initsh.github.io/centos7.utils.sh)
bash <(curl -Ls initsh.github.io/centos7.httpd.vhost.sh) www.example.com
systemctl start httpd

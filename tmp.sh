#!/bin/bash
bash <(curl -Ls initsh.github.io/centos6.selinux.sh)
bash <(curl -Ls initsh.github.io/centos7.firewalld.sh)
#bash <(curl -Ls initsh.github.io/centos7.utils.sh)
bash <(curl -Ls initsh.github.io/centos7.httpd.vhost.sh) a1.example.com
bash <(curl -Ls initsh.github.io/centos7.httpd.vhost.sh) a2.example.com
systemctl start httpd

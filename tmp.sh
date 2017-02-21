#!/bin/bash
bash <(curl -Ls initsh.github.io/centos7.httpd.vhost.sh) www.example.com
systemctl start httpd

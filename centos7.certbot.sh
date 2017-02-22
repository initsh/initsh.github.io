#!/bin/bash

# check env.
[ "$(curl -LRs initsh.github.io -o /dev/null -w '%{http_code}')" -eq 200 ] || { echo "[ERROR]: $(basename $0): Can't reach initsh.github.io"; exit 1; }
. <(curl -LRs initsh.github.io/check.centos7.sh)
. <(curl -LRs initsh.github.io/check.root.sh)

# install epel-release
. <(curl -LRs initsh.github.io/centos7.epel.sh)

# install certbot
echo '--InstallCertbot----------------'
if ! rpm -q certbot
then
	yum --enablerepo=* -y install certbot
fi
if ! rpm --quiet -q certbot
then
	yum --enablerepo=extra,optional,epel -y install certbot
fi

# Let's Encrypt!
echo '--LetsEncrypt-------------------'
echo 'EMAIL="mail@www.example.com"'
echo 'WEBROOT="/var/www/www.example.com"'
echo 'FQDN="www.example.com"'
echo 'certbot certonly --agree-tos --webroot --email "${EMAIL}" -w "${WEBROOT}" -d "${FQDN}"'
echo "ls -dl /etc/letsencrypt/live/${FQDN}/*"

#EOF

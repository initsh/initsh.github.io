#!/bin/bash

# check env.
[ "$(curl -Ls initsh.github.io -o /dev/null -w '%{http_code}')" -eq 200 ] || { echo "[ERROR]: $(basename $0): Can't reach initsh.github.io"; exit 1; }
. <(curl -Ls initsh.github.io/check.centos7.sh)
. <(curl -Ls initsh.github.io/check.root.sh)
. <(curl -Ls initsh.github.io/check.args.sh)

# install epel-release
. <(curl -Ls initsh.github.io/centos7.epel.sh)

# install certbot
if ! rpm -q certbot
	yum --enablerepo=* -y install certbot
fi

# Let's Encrypt!
echo 'EMAIL=mail@www.example.com'
echo 'WEBROOT=/var/www/www.example.com'
echo 'FQDN=www.example.com'
echo 'certbot certonly --webroot --email "${EMAIL}" -w "${WEBROOT}" -d "${FQDN}"'

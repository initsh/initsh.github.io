#!/bin/bash

# check env.
[ "$(curl -LRs initsh.github.io -o /dev/null -w '%{http_code}')" -eq 200 ] || { echo "[ERROR]: $(basename $0): Can't reach initsh.github.io"; exit 1; }
. <(curl -LRs initsh.github.io/check.centos7.sh)
. <(curl -LRs initsh.github.io/check.root.sh)

# install jq epel-release
. <(curl -LRs initsh.github.io/centos7.jq.sh)
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
if ! rpm --quiet -q certbot
then
	echo "[ERROR]: Can't install certbot."
	exit 1
fi

# Let's Encrypt!
if [ -n "$(echo "$1" | egrep '[^@]+@[^@\.]+\.[^@\.]+')" ] \
&& [ -n "$(echo "$2" | egrep '[^\.]+\.[^\.]+')" ] \
&& [ -d "$3" ] 
then
	echo '--Parameters--------------------'
	echo '{"v_fqdn": "'"$1"'", "v_webroot_dir": "'"$2"'", "v_email_addr": "'"$3"'"}' | jq .
	echo '--LetsEncrypt-------------------'
	v_email_addr="$1"
	v_fqdn="$2"
	v_webroot_dir="$3"
#	certbot certonly --non-interactive --agree-tos --email "${v_email_addr}" -d "${v_fqdn}" --webroot -w "${v_webroot_dir}"
	certbot certonly --non-interactive --agree-tos --email "${v_email_addr}" -d "${v_fqdn}" --standalone-supported-challenges tls-sni-01
	echo '--Certificate-------------------'
	ls -dl "/etc/letsencrypt/live/${v_fqdn}/"*
else
	echo '--LetsEncrypt-------------------'
	echo 'EMAIL="example@email.addr"'
	echo 'WEBROOT="/var/www/www.example.com"'
	echo 'FQDN="www.example.com"'
	echo 'certbot certonly --non-interactive --agree-tos --email "${v_email_addr} -d "${FQDN}" --webroot -w "${WEBROOT}"'
	echo 'ls -dl "/etc/letsencrypt/live/${FQDN}/"*'
fi

#EOF

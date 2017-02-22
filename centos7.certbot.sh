#!/bin/bash

# check env.
[ "$(curl -LRs initsh.github.io -o /dev/null -w '%{http_code}')" -eq 200 ] || { echo "[ERROR]: $(basename $0): Can't reach initsh.github.io"; exit 1; }
. <(curl -LRs initsh.github.io/check.centos7.sh)
. <(curl -LRs initsh.github.io/check.root.sh)

# install jq epel-release net-tools
--InstallDependence-------------------'
. <(curl -LRs initsh.github.io/centos7.jq.sh)
. <(curl -LRs initsh.github.io/centos7.epel.sh)
if ! rpm --quiet -q net-tools
then
	yum -y install net-tools
fi

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
&& [ -n "$(netstat -lntp | awk '$0=$4' | egrep '443$')" ]
then
	echo '--Parameters--------------------'
	echo '{"v_fqdn": "'"$1"'", "v_webroot_dir": "'"$2"'", "v_email_addr": "'"$3"'"}' | jq .
	echo '--LetsEncrypt-------------------'
	v_email_addr="$1"
	v_fqdn="$2"
	certbot certonly --non-interactive --agree-tos --email "${v_email_addr}" -d "${v_fqdn}" --standalone-supported-challenges tls-sni-01
	echo '--Certificate-------------------'
	ls -dl "/etc/letsencrypt/live/${v_fqdn}/"*
else
	v_web_server="$(netstat -lntp | awk '{print $7,$4}' | egrep '443$' | sed -r -e 's/[0-9]+\/(.+) .+/\1/g')"
	echo '--LetsEncrypt-------------------'
	echo 'EMAIL="example@email.addr"'
	echo 'WEBROOT="/var/www/www.example.com"'
	echo 'FQDN="www.example.com"'
	echo "systemctl stop ${v_web_server}"
	echo 'certbot certonly --non-interactive --agree-tos --email "${v_email_addr} -d "${FQDN}" --standalone-supported-challenges tls-sni-01'
	echo "systemctl start ${v_web_server}"
	echo 'ls -dl "/etc/letsencrypt/live/${FQDN}/"*'
fi

#EOF

#!/bin/bash

# check env.
[ "$(curl -LRs initsh.github.io -o /dev/null -w '%{http_code}')" -eq 200 ] || { echo "[ERROR]: $(basename $0): Can't reach initsh.github.io"; exit 1; }
. <(curl -LRs initsh.github.io/check.centos7.sh)
. <(curl -LRs initsh.github.io/check.root.sh)
. <(curl -LRs initsh.github.io/check.args.sh)

# functions
. <(curl -LRs initsh.github.io/functions.sh)

# check args
if [ -n "$(echo "$1" | egrep '[^@]+@[^@\.]+\.[^@\.]+')" ]
then
	echo '[ERROR]: $1 needs e-mail address.'
	exit 1
fi
if [ -n "$(echo "$2" | egrep '[^\.]+\.[^\.]+')" ]
then
	echo '[ERROR]: $2 needs web server\'s fqdn.'
	exit 1
fi

# install utils epel-release
. <(curl -LRs initsh.github.io/centos7.utils.sh)
. <(curl -LRs initsh.github.io/centos7.epel.sh)

# install certbot
if ! rpm -q certbot | StdoutLog
then
	echo 'yum --enablerepo=* -y install certbot'			| StdoutLog
	yum --enablerepo=* -y install certbot				| StdoutLog
	echo 'yum --enablerepo=extra,optional,epel -y install certbot'	| StdoutLog
	yum --enablerepo=extra,optional,epel -y install certbot		| StdoutLog
	if ! rpm --quiet -q certbot | StdoutLog
	then
		echo "[ERROR]: failed to install certbot." | StdoutLog
		exit 1
	fi
fi


# vars
v_email_addr="$1"
v_fqdn="$2"
echo '{"v_fqdn": "'"$v_email_addr"'", "v_email_addr": "'"$v_fqdn"'"}' | jq . | StdoutLog

# install cert
if [ -z "$(ss -lntp | awk '$0=$4' | egrep '443$')" ]
then
	echo 'certbot certonly --non-interactive --agree-tos --email "${v_email_addr}" -d "${v_fqdn}" --standalone-supported-challenges tls-sni-01' | StdoutLog
	certbot certonly --non-interactive --agree-tos --email "${v_email_addr}" -d "${v_fqdn}" --standalone-supported-challenges tls-sni-01 | StdoutLog
	echo '# ls -ld "/etc/letsencrypt/live/${v_fqdn}/"*' | StdoutLog
	ls -dl "/etc/letsencrypt/live/${v_fqdn}/"* | StdoutLog
else
	v_web_server="$(ss -lntp | awk '{print $6,$4}' | egrep '443$' | sed -r -e 's/users:\(\("([^"]*)".*/\1/g')"
	echo "# systemctl stop ${v_web_server}" >/dev/stderr
	echo "# certbot certonly --non-interactive --agree-tos --email ${v_email_addr} -d ${v_fqdn} --standalone-supported-challenges tls-sni-01" >/dev/stderr
	echo "# systemctl start ${v_web_server}" >/dev/stderr
	echo '# ls -dl "/etc/letsencrypt/live/${FQDN}/"*' >/dev/stderr
fi

#EOF

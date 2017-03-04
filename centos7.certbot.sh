#!/bin/bash

# check env.
[ "$(curl -LRs initsh.github.io -o /dev/null -w '%{http_code}')" -eq 200 ] || { echo "[ERROR]: $(basename $0): Can't reach initsh.github.io"; exit 1; }
. <(curl -LRs initsh.github.io/check.centos7.sh)
. <(curl -LRs initsh.github.io/check.root.sh)
. <(curl -LRs initsh.github.io/check.args.sh)

# functions
. <(curl -LRs initsh.github.io/functions.sh)
echo "[INFO]: Start centos7.certbot.sh" | StdoutLog

# check args
if [ -z "$(echo "$1" | egrep '[^@]+@[^@\.]+\.[^@\.]+')" ]
then
	echo "$(date -Is)"' [ERROR]: $1 needs e-mail address.'
	exit 1
fi
if [ -z "$(echo "$2" | egrep '[^\.]+\.[^\.]+')" ]
then
	echo "$(date -Is)"" [ERROR]: \$2 needs web server's fqdn."
	exit 1
fi

# install utils epel-release
. <(curl -LRs initsh.github.io/centos7.utils.sh)
. <(curl -LRs initsh.github.io/centos7.epel.sh)

# install certbot
if ! rpm -q certbot | StdoutLog
then
	echo '[INFO]: yum --enablerepo=* -y install certbot'			| StdoutLog
	yum --enablerepo=* -y install certbot					| StdoutLog
	echo '[INFO]: yum --enablerepo=extra,optional,epel -y install certbot'	| StdoutLog
	yum --enablerepo=extra,optional,epel -y install certbot			| StdoutLog
	if ! rpm --quiet -q certbot | StdoutLog
	then
		echo "[ERROR]: failed to install certbot." | StdoutLog
		exit 1
	fi
fi


# vars
v_email_addr="$1"
v_fqdn="$2"

# install cert
if [ -z "$(ss -lntp | awk '$0=$4' | egrep '443$')" ]
then

	echo '[INFO]: Generate SSL Keys' | StdoutLog
	echo '{"v_email_addr": "'"$v_email_addr"'", "v_fqdn": "'"$v_fqdn"'"}' | jq . | StdoutLog

	v_expect_num="$(expect -c "
set timeout 10
spawn certbot certonly --agree-tos --email ${v_email_addr} -d ${v_fqdn} --preferred-challenges tls-sni-01
expect \"(press 'c' to cancel): \"
send \"c\n\"
" | awk -F: '/standalone/{print $1}')"

	expect -c "
set timeout 10
spawn certbot certonly --agree-tos --email ${v_email_addr} -d ${v_fqdn} --preferred-challenges tls-sni-01
expect \"(press 'c' to cancel): \"
send \"${v_expect_num}\n\"
expect \"(press 'c' to cancel): \"
send \"c\n\"
interact
" 2>/dev/stdout | StdoutLog

	ls -dl "/etc/letsencrypt/live/${v_fqdn}/"* | StdoutLog
	ls -dl "/etc/letsencrypt/live/${v_fqdn}/"* >/dev/stderr
else
	if [ -z "$(echo "$3" | egrep '^/[^/]*')" ]
	then
		v_web_server="$(ss -lntp | awk '{print $6,$4}' | egrep '443$' | sed -r -e 's/users:\(\("([^"]*)".*/\1/g')"
		echo "$(date -Is) [ERROR]: ""\$2 needs web server's document root..."
		echo "$(date -Is) [ERROR]: ""OR run the following command."
		echo "$(date -Is) [ERROR]: ""# certbot certonly --agree-tos --email ${v_email_addr} -d ${v_fqdn} --preferred-challenges tls-sni-01 --pre-hook \"systemctl stop ${v_web_server}\" --post-hook \"systemctl start ${v_web_server}\"" >/dev/stderr
		exit 1
	fi
	v_fqdn_docroot="$3"
	echo '[INFO]: Generate SSL Keys' | StdoutLog
	echo '{"v_email_addr": "'"$v_email_addr"'", "v_fqdn": "'"$v_fqdn"'", "v_fqdn_docroot": "'"$v_fqdn_docroot"'"}' | jq . | StdoutLog

	expect -c "
set timeout 10
spawn certbot certonly --agree-tos --email ${v_email_addr} --webroot -w ${v_fqdn_docroot} -d ${v_fqdn}
expect \"(press 'c' to cancel): \"
send \"c\n\"
interact
" 2>/dev/stdout | StdoutLog

	ls -dl "/etc/letsencrypt/live/${v_fqdn}/"* | StdoutLog
	ls -dl "/etc/letsencrypt/live/${v_fqdn}/"* >/dev/stderr
fi

# notice
echo "[NOTICE]: Please edit web server's conf for SSL Keys." 1>/dev/stderr

#EOF

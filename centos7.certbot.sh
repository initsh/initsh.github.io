#!/bin/bash

# Edit 20170306
v_script_name="centos7.certbot.sh"

# functions
. <(curl -LRs initsh.github.io/functions.sh) || echo "$(date -Is) [ERROR]: Failed to load https://initsh.github.io/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."
	
	# checks
	. <(curl -LRs initsh.github.io/check.centos7.sh)
	. <(curl -LRs initsh.github.io/check.root.sh)
	. <(curl -LRs initsh.github.io/check.args.sh)
	
	# check args
	if [ -z "$(echo "$1" | egrep '[^@]+@[^@\.]+\.[^@\.]+')" ]
	then
		LogError "\$1 needs e-mail address."
		exit 1
	fi
	if [ -z "$(echo "$2" | egrep '[^\.]+\.[^\.]+')" ]
	then
		LogError "\$2 needs web server's fqdn."
		exit 1
	fi
	
	# install utils epel-release
	. <(curl -LRs initsh.github.io/centos7.utils.sh)
	. <(curl -LRs initsh.github.io/centos7.epel.sh)
	
	# install certbot
	if ! rpm -q certbot
	then
		LogInfo "bash# yum --enablerepo=* -y install certbot"
		yum --enablerepo=* -y install certbot
		LogInfo "bash# yum --enablerepo=extra,optional,epel -y install certbot"
		yum --enablerepo=extra,optional,epel -y install certbot
		if ! rpm -q certbot
		then
			LogError "Failed to install certbot."
			exit 1
		fi
	fi
	
	# variables
	v_email_addr="$1"
	v_fqdn="$2"
	
	# install cert
	if [ -z "$(ss -lntp | awk '$0=$4' | egrep '443$')" ]
	then
		LogInfo "Generate SSL Keys."
		LogInfo "$(echo '{"v_email_addr": "'"${v_email_addr}"'", "v_fqdn": "'"${v_fqdn}"'"}' | jq .)"
		
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
" | tee /dev/stderr
		
	else
		if [ -z "$(echo "$3" | egrep '^/[^/]*')" ]
		then
			v_web_server="$(ss -lntp | awk '{print $6,$4}' | egrep '443$' | sed -r -e 's/users:\(\("([^"]*)".*/\1/g')"
			LogError "\$2 needs web server's document root..."
			LogError "OR run the following command."
			LogError "# certbot certonly --agree-tos --email ${v_email_addr} -d ${v_fqdn} --preferred-challenges tls-sni-01 --pre-hook \"systemctl stop ${v_web_server}\" --post-hook \"systemctl start ${v_web_server}\""
			exit 1
		fi
		
		# variables
		v_fqdn_docroot="$3"
		
		LogInfo "Generate SSL Keys."
		LogInfo "$(echo '{"v_email_addr": "'"${v_email_addr}"'", "v_fqdn": "'"${v_fqdn}"'", "v_fqdn_docroot": "'"${v_fqdn_docroot}"'"}' | jq .)"
		
		expect -c "
set timeout 10
spawn certbot certonly --agree-tos --email ${v_email_addr} --webroot -w ${v_fqdn_docroot} -d ${v_fqdn}
expect \"(press 'c' to cancel): \"
send \"c\n\"
interact
" | tee /dev/stderr
	
	fi
	
	# notice
	LogNotice "SSL Keys..."
	LogNotice "$(ls -dl "/etc/letsencrypt/live/${v_fqdn}/"*)"
	LogNotice "Please edit web server's conf for SSL Keys."
	
	LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF

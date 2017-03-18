#!/bin/bash

# Edit 20170306
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/httpd.vhost.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh") || echo "$(date -Is) [ERROR]: Failed to load https://${v_github_dir}/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."
	
	# checks
	. <(curl -LRs "${v_github_dir}/check/centos7.sh")
	. <(curl -LRs "${v_github_dir}/check/root.sh")
	. <(curl -LRs "${v_github_dir}/check/args.sh")
	
	# install httpd
	if ! rpm --quiet -q openssl
	then
		LogInfo "bash# yum -y install openssl"
		sudo yum -y install openssl
		if ! rpm -q openssl
		then
			LogError "Failed to install openssl."
			exit 1
		fi
	fi
	if ! rpm --quiet -q httpd
	then
		LogInfo "bash# yum -y install httpd"
		sudo yum -y install httpd
		if ! rpm -q httpd
		then
			LogError "Failed to install httpd."
			exit 1
		fi
	fi
	if ! rpm --quiet -q mod_ssl
	then
		LogInfo "bash# yum -y install mod_ssl"
		sudo yum -y install mod_ssl
		if ! rpm -q mod_ssl
		then
			LogError "Failed to install mod_ssl."
			exit 1
		fi
	fi
	
	# varibales
	v_fqdn=$1
	
	# edit conf
	v_httpd_conf="/etc/httpd/conf/httpd.conf"
	LogInfo "Edit ${v_httpd_conf}"
	[ -f ${v_httpd_conf} ] || sudo touch ${v_httpd_conf}
	sudo cp -p "${v_httpd_conf}" "${v_httpd_conf}${v_backup_suffix}"
	# edit edit edit edit
	# if no diff, overwrite file.
	[ "$(sudo diff "${v_httpd_conf}${v_backup_suffix}" "${v_httpd_conf}")" ] || sudo \mv -f "${v_httpd_conf}${v_backup_suffix}" "${v_httpd_conf}"
	LogInfo "$(ls -dl "${v_httpd_conf}"*)"
	
	# mkdir vhost rootdir
	v_vhost_fqdn_docroot="/var/www/${v_fqdn}"
	LogInfo "bash# mkdir ${v_vhost_fqdn_docroot}"
	sudo mkdir -p "${v_vhost_fqdn_docroot}"
	LogInfo "$(ls -dl "${v_vhost_fqdn_docroot}"*)"
	[ -d "${v_vhost_fqdn_docroot}" ] || { LogError "${v_fqdn}: Something wrong about DocumentRoot."; exit 1; }
	
	# gen fqdn crt & key
	v_fqdn_key="/etc/pki/tls/certs/${v_fqdn}.key"
	v_fqdn_csr="/etc/pki/tls/certs/${v_fqdn}.csr"
	v_fqdn_crt="/etc/pki/tls/certs/${v_fqdn}.crt"
	LogInfo "Generate SSL Keys."
	[ -f "${v_fqdn_key}" ] || sudo openssl genrsa 2048 >${v_fqdn_key} 2>/dev/stdout
	[ -f "${v_fqdn_csr}" ] || sudo openssl req -new -key ${v_fqdn_key} -subj "/C=JP/CN=${v_fqdn}" >${v_fqdn_csr} 2>/dev/stdout
	[ -f "${v_fqdn_crt}" ] || sudo openssl x509 -days 3650 -req -signkey ${v_fqdn_key} <${v_fqdn_csr} >${v_fqdn_crt} 2>/dev/stdout
	LogInfo "$(sudo ls -dl "${v_fqdn_key}" "${v_fqdn_csr}" "${v_fqdn_crt}")"
	
	# edit fqdn conf
	v_httpd_conf_d_dir="/etc/httpd/conf.d"
	v_httpd_vhost_fqdn_conf="${v_httpd_conf_d_dir}/httpd-vhost-${v_fqdn}.conf"
	LogInfo "Edit ${v_httpd_vhost_fqdn_conf}"
	[ -d "${v_httpd_conf_d_dir}" ] || { LogError "Something wrong about Directory(${v_httpd_conf_d_dir})."; exit 1; }
	[ -f "${v_httpd_vhost_fqdn_conf}" ] || sudo touch "${v_httpd_vhost_fqdn_conf}"
	sudo \cp -p "${v_httpd_vhost_fqdn_conf}" "${v_httpd_vhost_fqdn_conf}${v_backup_suffix}"
	
	sudo cat <<__EOD__ >"${v_httpd_vhost_fqdn_conf}"
# Edit 20170304
# https://github.com/initsh/initsh.github.io

## http
NameVirtualhost *:80
<VirtualHost *:80>
    ServerName ${v_fqdn}
    DocumentRoot ${v_vhost_fqdn_docroot}

    ErrorLog logs/${v_fqdn}-error_log
    CustomLog logs/${v_fqdn}-access_log combined
</VirtualHost>

## https
NameVirtualhost *:443
<VirtualHost *:443>
    ServerName ${v_fqdn}
    DocumentRoot ${v_vhost_fqdn_docroot}

    SSLEngine on
    # openssl
    SSLCertificateFile ${v_fqdn_crt}
    SSLCertificateKeyFile ${v_fqdn_key}
    # Let's Encrypt
#    SSLCertificateFile /etc/letsencrypt/live/${v_fqdn}/cert.pem
#    SSLCertificateKeyFile /etc/letsencrypt/live/${v_fqdn}/privkey.pem

    ErrorLog logs/${v_fqdn}-error_log
    CustomLog logs/${v_fqdn}-access_log combined
</VirtualHost>
__EOD__
	
	[ "$(sudo diff "${v_httpd_vhost_fqdn_conf}${v_backup_suffix}" "${v_httpd_vhost_fqdn_conf}")" ] || sudo \mv -f "${v_httpd_vhost_fqdn_conf}${v_backup_suffix}" "${v_httpd_vhost_fqdn_conf}"
	LogInfo "$(ls -dl "${v_httpd_vhost_fqdn_conf}"*)"
	
	# check conf error
	v_judge="$(sudo httpd -S >/dev/null 2>/dev/stdout)"
	LogInfo "Check conf."
	if [ "${v_judge}" ]
	then
		LogError "${v_judge}"
	else
		LogInfo "No Error."
	fi
	
	# status httpd
	LogInfo "Status."
	LogInfo "$(systemctl status httpd)"
	
	# notice
	LogNotice "Run the following command for reload conf."
	LogNotice "bash# systemctl restart httpd"
		
	LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF

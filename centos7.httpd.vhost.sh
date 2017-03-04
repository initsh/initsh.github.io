#!/bin/bash

# check env.
[ "$(curl -LRs initsh.github.io -o /dev/null -w '%{http_code}')" -eq 200 ] || { echo "[ERROR]: $(basename $0): Can't reach initsh.github.io"; exit 1; }
. <(curl -LRs initsh.github.io/check.centos7.sh)
. <(curl -LRs initsh.github.io/check.root.sh)
. <(curl -LRs initsh.github.io/check.args.sh)

# functions
. <(curl -LRs initsh.github.io/functions.sh)
echo "[INFO]: Start centos7.httpd.vhost.sh" | StdoutLog

# install httpd
if ! rpm -q openssl | StdoutLog
then
	yum -y install openssl | StdoutLog
fi
if ! rpm -q httpd | StdoutLog
then
	yum -y install httpd | StdoutLog
fi
if ! rpm -q mod_ssl | StdoutLog
then
	yum -y install mod_ssl | StdoutLog
fi

# varibale
v_fqdn=$1
v_date="$(date +%Y%m%d)"
v_time="$(date +%H%M%S)"
v_backup_suffix="_${v_date}_${v_time}.backup"

# edit conf
v_httpd_conf="/etc/httpd/conf/httpd.conf"
echo "[INFO]: Edit ${v_httpd_conf}" | StdoutLog
[ -f ${v_httpd_conf} ] || touch ${v_httpd_conf}
cp -p ${v_httpd_conf} ${v_httpd_conf}${v_backup_suffix}
# edit edit edit edit
# if no diff, overwrite file.
[ "$(diff ${v_httpd_conf} ${v_httpd_conf}${v_backup_suffix})" ] || \mv -f ${v_httpd_conf}${v_backup_suffix} ${v_httpd_conf}
ls -dl "${v_httpd_conf}"* | StdoutLog

# mkdir vhost rootdir
v_vhost_fqdn_docroot="/var/www/${v_fqdn}"
echo "[INFO]: mkdir ${v_vhost_fqdn_docroot}" | StdoutLog
mkdir -p "${v_vhost_fqdn_docroot}" 2>/dev/stdout | StdoutLog
ls -dl "${v_vhost_fqdn_docroot}"* | StdoutLog
[ -d "${v_vhost_fqdn_docroot}" ] || { echo "[ERROR]: $(basename "${v_vhost_fqdn_docroot}"): Something wrong about DocumentRoot." | StdoutLog; exit 1; }

# gen fqdn crt & key
echo "[INFO]: Generate SSL Keys." | StdoutLog
v_fqdn_key=/etc/pki/tls/certs/${v_fqdn}.key
v_fqdn_csr=/etc/pki/tls/certs/${v_fqdn}.csr
v_fqdn_crt=/etc/pki/tls/certs/${v_fqdn}.crt
[ -f "${v_fqdn_key}" ] || openssl genrsa 2048 >${v_fqdn_key} 2>/dev/stdout | StdoutLog
[ -f "${v_fqdn_csr}" ] || openssl req -new -key ${v_fqdn_key} -subj "/C=JP/CN=${v_fqdn}" >${v_fqdn_csr} 2>/dev/stdout | StdoutLog
[ -f "${v_fqdn_crt}" ] || openssl x509 -days 3650 -req -signkey ${v_fqdn_key} <${v_fqdn_csr} >${v_fqdn_crt} 2>/dev/stdout | StdoutLog
ls -dl "${v_fqdn_key}" "${v_fqdn_csr}" "${v_fqdn_crt}" | StdoutLog

# edit fqdn conf
v_httpd_conf_d_dir="/etc/httpd/conf.d"
v_httpd_vhost_fqdn_conf="${v_httpd_conf_d_dir}/httpd-vhost-${v_fqdn}.conf"
echo "[INFO]: Edit ${v_httpd_vhost_fqdn_conf}" | StdoutLog
[ -d "${v_httpd_conf_d_dir}" ] || { echo "[ERROR]: $(basename ${v_httpd_conf_d_dir}): Something wrong about Directory." | StdoutLog; exit 1; }
[ -f "${v_httpd_vhost_fqdn_conf}" ] || touch "${v_httpd_vhost_fqdn_conf}"
cp -p "${v_httpd_vhost_fqdn_conf}" "${v_httpd_vhost_fqdn_conf}${v_backup_suffix}"
cat <<__EOD__ >"${v_httpd_vhost_fqdn_conf}"
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
    SSLCertificateFile ${v_fqdn_crt}
#    SSLCertificateFile /etc/letsencrypt/live/${v_fqdn}/cert.pem
    SSLCertificateKeyFile ${v_fqdn_key}
#    SSLCertificateKeyFile /etc/letsencrypt/live/${v_fqdn}/privkey.pem

    ErrorLog logs/${v_fqdn}-error_log
    CustomLog logs/${v_fqdn}-access_log combined
</VirtualHost>
__EOD__
[ "$(diff "${v_httpd_vhost_fqdn_conf}" "${v_httpd_vhost_fqdn_conf}${v_backup_suffix}")" ] || \mv -f "${v_httpd_vhost_fqdn_conf}${v_backup_suffix}" "${v_httpd_vhost_fqdn_conf}"
ls -dl "${v_httpd_vhost_fqdn_conf}"* | StdoutLog

# check conf error
echo '[INFO]: Check conf.' | StdoutLog
v_judge="$(httpd -S >/dev/null 2>/dev/stdout)"
if [ "${v_judge}" ]
then
	echo "[WARN]: ${v_judge}" | StdoutLog
else
	echo "[INFO]: No Error." | StdoutLog
fi

# status httpd
echo '[INFO]: Status.' | StdoutLog
systemctl status httpd | StdoutLog

# reload httpd
echo '[NOTICE]: Run the following command for reload conf.' 1>/dev/stderr
echo '[NOTICE]: # systemctl restart httpd' 1>/dev/stderr

#EOF

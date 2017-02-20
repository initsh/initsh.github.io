#!/bin/bash

# check env.
[ "$(curl -Ls initsh.github.io -o /dev/null -w '%{http_code}')" -eq 200 ] || { echo "[ERROR]: $(basename $0): Can't reach initsh.github.io"; exit 1; }
. <(curl -Ls initsh.github.io/check_centos7.sh)
. <(curl -Ls initsh.github.io/check_root.sh)
. <(curl -Ls initsh.github.io/check_args.sh)

# install httpd
echo '--Httpd-------------------------'
if ! rpm -q httpd openssl mod_ssl
then
	yum -y install httpd openssl mod_ssl
fi

# status httpd
echo '--StatusHttpd-------------------'
systemctl status httpd

# varibale
v_fqdn=$1
v_date="$(date +%Y%m%d)"
v_time="$(date +%H%M%S)"
v_backup_suffix="_${v_date}_${v_time}.backup"

# edit conf
v_httpd_conf="/etc/httpd/conf/httpd.conf"
[ -f ${v_httpd_conf} ] || touch ${v_httpd_conf}
cp -p ${v_httpd_conf} ${v_httpd_conf}${v_backup_suffix}
# edit edit edit edit
# if no diff, overwrite file.
[ "$(diff ${v_httpd_conf} ${v_httpd_conf}${v_backup_suffix})" ] || \mv -f ${v_httpd_conf}${v_backup_suffix} ${v_httpd_conf}
echo '--HttpdConf---------------------'
ls -dl "${v_httpd_conf}"*

# mkdir vhost rootdir
v_vhosts_fqdn_docroot="/var/www/${v_fqdn}"
echo '--FqdnDocumentRoot--------------'
mkdir -p "${v_vhosts_fqdn_docroot}"
ls -ld "${v_vhosts_fqdn_docroot}"*
[ -d "${v_vhosts_fqdn_docroot}" ] || { echo "[ERROR]: $(basename "${v_vhosts_fqdn_docroot}"): Something wrong about DocumentRoot."; exit 1; }

# gen fqdn crt & key
v_fqdn_key=/etc/pki/tls/certs/${v_fqdn}.key
v_fqdn_csr=/etc/pki/tls/certs/${v_fqdn}.csr
v_fqdn_crt=/etc/pki/tls/certs/${v_fqdn}.crt
echo '--GenerateSslKeys---------------'
openssl genrsa 2048 >${v_fqdn_key}
openssl req -new -key ${v_fqdn_key} -subj "/C=JP/CN=${v_fqdn}" >${v_fqdn_csr}
openssl x509 -days 3650 -req -signkey ${v_fqdn_key} <${v_fqdn_csr} >${v_fqdn_crt}

# edit fqdn conf
v_httpd_conf_d_dir="/etc/httpd/conf.d"
v_httpd_vhosts_fqdn_conf="${v_httpd_conf_d_dir}/httpd-vhosts-${v_fqdn}.conf"
[ -d "${v_httpd_conf_d_dir}" ] || { echo "[ERROR]: $(basename ${v_httpd_conf_d_dir}): Something wrong about Directory."; exit 1; }
[ -f "${v_httpd_vhosts_fqdn_conf}" ] || touch "${v_httpd_vhosts_fqdn_conf}"
cp -p "${v_httpd_vhosts_fqdn_conf}" "${v_httpd_vhosts_fqdn_conf}${v_backup_suffix}"
cat <<__EOD__ >"${v_httpd_vhosts_fqdn_conf}"
# Edit 20170220

## http
NameVirtualhost *:80
<VirtualHost *:80>
    ServerName ${v_fqdn}
    DocumentRoot ${v_vhosts_fqdn_docroot}

    ErrorLog logs/${v_fqdn}-error_log
    CustomLog logs/${v_fqdn}-access_log combined
</VirtualHost>

## https
NameVirtualhost *:443
<VirtualHost *:443>
    ServerName ${v_fqdn}
    DocumentRoot ${v_vhosts_fqdn_docroot}

    SSLEngine on
    SSLCertificateFile ${v_fqdn_crt}
    SSLCertificateKeyFile ${v_fqdn_key}

    ErrorLog logs/${v_fqdn}-error_log
    CustomLog logs/${v_fqdn}-access_log combined
</VirtualHost>
__EOD__
[ "$(diff "${v_httpd_vhosts_fqdn_conf}" "${v_httpd_vhosts_fqdn_conf}${v_backup_suffix}")" ] || \mv -f "${v_httpd_vhosts_fqdn_conf}${v_backup_suffix}" "${v_httpd_vhosts_fqdn_conf}"
echo '--HttpdVhostsFqdnConf-----------'
ls -l "${v_httpd_vhosts_fqdn_conf}"*

# check conf error
echo '--HttpdConfError----------------'
v_judge="$(httpd -S >/dev/null 2>/dev/stdout)"
if [ "${v_judge}" ]
then
	echo "${v_judge}"
else
	echo "Nothing."
fi

# Edit logrotate.d/httpd
v_logrotate_httpd="/etc/logrotate.d/httpd"
cat <<'__EOD__' >${v_logrotate_httpd}
#/var/log/httpd/*log {
#    missingok
#    notifempty
#    sharedscripts
#    delaycompress
#    postrotate
#        /bin/systemctl reload httpd.service > /dev/null 2>/dev/null || true
#    endscript
#}
# Edit 20170220
/var/log/httpd/*log {
    missingok
    notifempty
    daily
    rotate 90
    compress
    sharedscripts
    delaycompress
    postrotate
        /bin/systemctl reload httpd.service > /dev/null 2>/dev/null || true
    endscript
}
__EOD__
echo '--logrotate.d/httpd-------------'
ls -dl "${v_logrotate_httpd}"*


#EOF

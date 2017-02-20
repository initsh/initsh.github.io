#!/bin/bash

# check env.
if ! egrep --quiet "CentOS.*7|Red.*7" /etc/system-release
then
	echo "This program supports only CentOS 7 or RedHat Enterprise Linux 7."
	exit 1
fi
if [ $(whoami) != "root" ]
then
	echo "This program needs to be executed by root user."
	exit 1
fi

# arguments
if [ $# -ge 1 ]
then
	v_fqdn=$1
else
	echo "$(basename $0) must have at least one argument."
	exit 1
fi

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
v_date="$(date +%Y%m%d)"
v_time="$(date +%H%M%S)"
v_backup_suffix="_${v_date}_${v_time}.backup"
v_httpd_conf="/etc/httpd/conf/httpd.conf"
v_docroot="$(sed -r -e '/^[ \t]*DocumentRoot/!d' -e 's/^[ \t]*DocumentRoot "(.*)"/\1/g' ${v_httpd_conf})"
v_vhosts_fqdn_docroot="${v_docroot}/${v_fqdn}"
v_httpd_conf_d_dir="/etc/httpd/conf.d"
v_httpd_vhosts_conf="/etc/httpd/conf.d/httpd-vhosts-00.conf"
v_httpd_vhosts_fqdn_conf="/etc/httpd/conf.d/httpd-vhosts-${v_fqdn}.conf"
v_logrotate_httpd="/etc/logrotate.d/httpd"

# mkdir vhost rootdir
echo '--MakeDocumentRoot--------------'
if [ -d "${v_docroot}" ]
then
	mkdir -p "${v_vhosts_fqdn_docroot}"
	ls -ld "${v_docroot}" "${v_docroot}"/*
else
	echo 'httpd.conf: Something wrong about DocumentRoot.'
	exit 1
fi

# edit vhosts conf
[ -f "${v_httpd_vhosts_conf}" ] || touch "${v_httpd_vhosts_conf}"
cp -p "${v_httpd_vhosts_conf}" "${v_httpd_vhosts_conf}${v_backup_suffix}"
cat <<__EOD__ >"${v_httpd_vhosts_conf}"
# Edit 20170220
# Deny access by IPAddress

## http
#NameVirtualhost *:80
<VirtualHost *:80>
    ServerName any
    <Location />
        Order deny,allow
        Deny from all
    </Location>
</VirtualHost>

## https
#NameVirtualhost *:443
<VirtualHost *:443>
    ServerName any
    <Location />
        Order deny,allow
        Deny from all
    </Location>
</VirtualHost>
__EOD__
[ "$(diff "${v_httpd_vhosts_conf}" "${v_httpd_vhosts_conf}${v_backup_suffix}")" ] || \mv -f "${v_httpd_vhosts_conf}${v_backup_suffix}" "${v_httpd_vhosts_conf}"
echo '--EditHttpdVhostsConf-----------'
cat "${v_httpd_vhosts_conf}"
echo '--------------------------------'
ls -l "${v_httpd_vhosts_conf}"*

# edit fqdn conf
[ -f "${v_httpd_vhosts_fqdn_conf}" ] || touch "${v_httpd_vhosts_fqdn_conf}"
cp -p "${v_httpd_vhosts_fqdn_conf}" "${v_httpd_vhosts_fqdn_conf}${v_backup_suffix}"
cat <<__EOD__ >"${v_httpd_vhosts_fqdn_conf}"
# Edit 20170220

## http
#NameVirtualhost *:80
<VirtualHost *:80>
    ServerName ${v_fqdn}
    DocumentRoot ${v_vhosts_fqdn_docroot}

    ErrorLog logs/${v_fqdn}-error_log
    CustomLog logs/${v_fqdn}-access_log combined
</VirtualHost>

## https
#NameVirtualhost *:443
<VirtualHost ${v_fqdn}:443>
    ServerName ${v_fqdn}
    DocumentRoot ${v_vhosts_fqdn_docroot}

    SSLEngine on
    SSLCertificateFile /etc/pki/tls/certs/localhost.crt
    SSLCertificateKeyFile /etc/pki/tls/private/localhost.key

    ErrorLog logs/${v_fqdn}-error_log
    CustomLog logs/${v_fqdn}-access_log combined
</VirtualHost>
__EOD__
[ "$(diff "${v_httpd_vhosts_fqdn_conf}" "${v_httpd_vhosts_fqdn_conf}${v_backup_suffix}")" ] || \mv -f "${v_httpd_vhosts_fqdn_conf}${v_backup_suffix}" "${v_httpd_vhosts_fqdn_conf}"
echo '--EditHttpdVhostsFqdnConf-----------'
cat "${v_httpd_vhosts_fqdn_conf}"
echo '--------------------------------'
ls -l "${v_httpd_vhosts_fqdn_conf}"*

# edit conf
[ -f ${v_httpd_conf} ] || touch ${v_httpd_conf}
cp -p ${v_httpd_conf} ${v_httpd_conf}${v_backup_suffix}
# edit edit edit edit
# if no diff, overwrite file.
[ "$(diff ${v_httpd_conf} ${v_httpd_conf}${v_backup_suffix})" ] || \mv -f ${v_httpd_conf}${v_backup_suffix} ${v_httpd_conf}
echo '--HttpdConfError----------------'
httpd -S >/dev/null
echo '--------------------------------'
ls -l "${v_httpd_conf}"*

# Edit logrotate.d/httpd
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
echo '--EditLogrotate.d/httpd---------'
cat ${v_logrotate_httpd}
echo '--------------------------------'
ls -l "${v_logrotate_httpd}"*


#EOF

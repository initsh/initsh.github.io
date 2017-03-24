#!/bin/bash

# Edit 20170306
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/owncloud.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh") || echo "$(date -Is) [ERROR]: Failed to load https://${v_github_dir}/functions.sh"

{
    LogInfo "Start \"${v_script_name}\"."
    
    . <(curl -LRs "${v_github_dir}/centos7/epel.sh")
    
    if ! rpm --quiet -q mariadb-server
    then
        LogInfo "bash# yum -y install mariadb-server"
        yum -y install mariadb-server 2>/dev/stdout
        
        v_my_server_cnf="/etc/my.cnf.d/server.cnf"
        v_my_small_cnf="/usr/share/mysql/my-small.cnf"
        \cp -p "${v_my_server_cnf}" "${v_my_server_cnf}${v_backup_suffix}"
        \cp -p "${v_my_small_cnf}" "${v_my_server_cnf}"
        
        systemctl enable mariadb
        systemctl start mariadb
        
        v_mariadb_root_passwd="$(cat /dev/urandom | tr -dc "0-9a-zA-Z_/" | head -c 64)"
        logger -t "${v_script_name}" "MariaDB initial root password: ${v_mariadb_root_passwd}"
        
        expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"\n\"
expect \"Set root password?\"
send \"y\n\"
expect \"New password:\"
send \"${v_mariadb_root_passwd}\n\"
expect \"Re-enter new password:\"
send \"${v_mariadb_root_passwd}\n\"
expect \"Remove anonymous users?\"
send \"y\n\"
expect \"Disallow root login remotely?\"
send \"y\n\"
expect \"Remove test database and access to it?\"
send \"y\n\"
expect \"Reload privilege tables now?\"
send \"y\n\"
interact
"
        
        v_mariadb_oc_user="$(cat /dev/urandom | tr -dc "0-9a-zA-Z_/" | head -c 32)"
        v_mariadb_oc_passwd="$(cat /dev/urandom | tr -dc "0-9a-zA-Z_/" | head -c 64)"
        logger -t "${v_script_name}" "MariaDB initial OwnCloud User,Password: ${v_mariadb_oc_user},${v_mariadb_oc_passwd}"
        
        mysql -u"root" -p"${v_mariadb_root_passwd}" <<__EOD__
mysql -u"root" -p"${v_mariadb_root_passwd}"
CREATE USER '${v_mariadb_oc_user}'@'localhost' IDENTIFIED BY '${v_mariadb_oc_passwd}';
CREATE DATABASE IF NOT EXISTS owncloud;
GRANT ALL PRIVILEGES ON owncloud.* TO '${v_mariadb_oc_user}'@'localhost' IDENTIFIED BY '${v_mariadb_oc_passwd}';
__EOD__
        
    fi
    
    if ! rpm --quiet -q owncloud
    then
        LogInfo "bash# yum -y install owncloud --enablerepo=epel"
        yum -y install owncloud --enablerepo=epel
    fi
    
    if [ ! -f /etc/httpd/conf.d/z-owncloud-access.conf ]
    then
        LogInfo "bash# ln -s /etc/httpd/conf.d/owncloud-access.conf.avail /etc/httpd/conf.d/z-owncloud-access.conf"
        ln -s /etc/httpd/conf.d/owncloud-access.conf.avail /etc/httpd/conf.d/z-owncloud-access.conf
    fi
    
    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF

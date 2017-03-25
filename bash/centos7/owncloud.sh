#!/bin/bash

# Edit 20170306
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/owncloud.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh") || echo "$(date -Is) [ERROR]: Failed to load https://${v_github_dir}/functions.sh"

{
    LogInfo "Start \"${v_script_name}\"."
    
    # check
    . <(curl -LRs "${v_github_dir}/check/centos7.sh")
    . <(curl -LRs "${v_github_dir}/check/root.sh")
    
    # install epel-release
    . <(curl -LRs "${v_github_dir}/centos7/epel.sh")
    
    ## MariaDB
    if ! rpm --quiet -q mariadb-server
    then
        # install MariaDB
        LogInfo "bash# yum -y install mariadb-server"
        yum -y install mariadb-server 2>/dev/stdout
        
        # variables for MariaDB
        v_my_server_cnf="/etc/my.cnf.d/server.cnf"
        v_my_small_cnf="/usr/share/mysql/my-small.cnf"
        
        # conf MariaDB
        LogInfo "Edit .conf File(${v_my_server_cnf})."
        \cp -p "${v_my_server_cnf}" "${v_my_server_cnf}${v_backup_suffix}"
        \cp -p "${v_my_small_cnf}" "${v_my_server_cnf}"
        sed -r -e 's@(\[client\])@\1\n# '"$(date +%Y%m%d)"' #\ndefault-character-set = utf8\n# '"$(date +%Y%m%d)"' #@g' "${v_my_server_cnf}" -i
        sed -r -e 's@(\[mysqld\])@\1\n# '"$(date +%Y%m%d)"' #\ncharacter-set-server = utf8\n# '"$(date +%Y%m%d)"' #@g' "${v_my_server_cnf}" -i
        
        # enable and start MariaDB
        LogInfo "bash# systemctl enable mariadb"
        systemctl enable mariadb 2>/dev/stdout
        LogInfo "bash# systemctl start mariadb"
        systemctl start mariadb 2>/dev/stdout
        
        # variables for mysql_secure_installation
        v_mariadb_root_passwd="$(cat /dev/urandom | tr -dc "0-9a-zA-Z_/" | head -c 32)"
        
        # mysql_secure_installation
        LogInfo "bash# mysql_secure_installation"
        expect <<__EOD__ 2>/dev/stdout
set timeout 10
spawn mysql_secure_installation

expect "Enter current password for root (enter for none):"
send "\n"

expect "Set root password?"
send "y\n"

expect "New password:"
send "${v_mariadb_root_passwd}\n"

expect "Re-enter new password:"
send "${v_mariadb_root_passwd}\n"

expect "Remove anonymous users?"
send "y\n"

expect "Disallow root login remotely?"
send "y\n"

expect "Remove test database and access to it?"
send "y\n"

expect "Reload privilege tables now?"
send "y\n"

interact
__EOD__
        
        # Write MariaDB root password to syslog
        LogInfo "Write MariaDB root password to syslog."
        logger -t "${v_script_name}" "MariaDB root password: ${v_mariadb_root_passwd}"
        
        # variables for MariaDB USER & PASSWORD & TABLE for owncloud
        v_mariadb_oc_admin="ocadmin"
        v_mariadb_oc_passwd="$(cat /dev/urandom | tr -dc "0-9a-zA-Z_/" | head -c 32)"
        
        # CREATE ownCloud environment on MariaDB
        LogInfo "CREATE ownCloud environment on MariaDB"
        mysql -u root -p"${v_mariadb_root_passwd}" <<__EOD__ 2>/dev/stdout
CREATE USER '${v_mariadb_oc_admin}'@'localhost' IDENTIFIED BY '${v_mariadb_oc_passwd}';
CREATE DATABASE IF NOT EXISTS owncloud;
GRANT ALL PRIVILEGES ON owncloud.* TO '${v_mariadb_oc_admin}'@'localhost' IDENTIFIED BY '${v_mariadb_oc_passwd}';
__EOD__
        
        # write owncloud MariaDB USER & PASSWORD
        LogInfo "Write ownCloud admin & password to syslog."
        logger -t "${v_script_name}" "ownCloud admin,password: ${v_mariadb_oc_admin},${v_mariadb_oc_passwd}"
    fi
    
    ## ownCloud
    if ! rpm --quiet -q owncloud
    then
        LogInfo "bash# yum -y install owncloud --enablerepo=epel"
        yum -y install owncloud --enablerepo=epel 2>/dev/stdout
        # ln conf
        if [ ! -f /etc/httpd/conf.d/z-owncloud-access.conf ]
        then
            LogInfo "bash# ln -s /etc/httpd/conf.d/owncloud-access.conf.avail /etc/httpd/conf.d/z-owncloud-access.conf"
            ln -s /etc/httpd/conf.d/owncloud-access.conf.avail /etc/httpd/conf.d/z-owncloud-access.conf
        fi
    fi
        
    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF

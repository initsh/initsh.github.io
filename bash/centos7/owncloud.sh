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
    
    # requirement
    bash <(curl -LRs "${v_github_dir}/centos7/selinux.sh")
    bash <(curl -LRs "${v_github_dir}/centos7/tz.tokyo.sh")
    bash <(curl -LRs "${v_github_dir}/centos7/utils.sh")
    bash <(curl -LRs "${v_github_dir}/centos7/epel.sh")
    
    ## MariaDB
    if ! rpm --quiet -q mariadb-server
    then
        # install MariaDB
        LogInfo "bash# yum -y install mariadb-server"
        yum -y install mariadb-server 2>&1
        
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
        systemctl enable mariadb 2>&1
        LogInfo "bash# systemctl start mariadb"
        systemctl start mariadb 2>&1
        
        # variables for mysql_secure_installation
        v_mariadb_root_passwd="$(cat /dev/urandom | tr -dc "0-9a-zA-Z" | head -c 32)"
        
        # install expect
        if ! rpm --quiet -q expect
        then
            LogInfo "bash# yum -y install expect"
            yum -y install expect 2>&1
        fi
        
        # mysql_secure_installation
        LogInfo "bash# mysql_secure_installation"
        expect <<__EOD__ 2>&1
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
        LogNotice "MariaDB root password: ${v_mariadb_root_passwd}"
        
        # variables for MariaDB USER & PASSWORD & TABLE for owncloud
        v_mariadb_oc_admin="ocadmin"
        v_mariadb_oc_passwd="$(cat /dev/urandom | tr -dc "0-9a-zA-Z" | head -c 32)"
        v_mariadb_oc_dbname="owncloud"
        
        # CREATE ownCloud environment on MariaDB
        LogInfo "CREATE ownCloud environment on MariaDB"
        mysql -u root -p"${v_mariadb_root_passwd}" <<__EOD__ 2>&1
CREATE USER '${v_mariadb_oc_admin}'@'localhost' IDENTIFIED BY '${v_mariadb_oc_passwd}';
CREATE DATABASE IF NOT EXISTS ${v_mariadb_oc_dbname};
GRANT ALL PRIVILEGES ON ${v_mariadb_oc_dbname}.* TO '${v_mariadb_oc_admin}'@'localhost' IDENTIFIED BY '${v_mariadb_oc_passwd}';
__EOD__
        
        # write owncloud MariaDB USER & PASSWORD
        LogNotice "ownCloud on MariaDB admin,password,database: ${v_mariadb_oc_admin},${v_mariadb_oc_passwd},${v_mariadb_oc_dbname}"
    fi
    
    ## ownCloud
    if ! rpm --quiet -q owncloud
    then
        LogInfo "bash# yum -y --enablerepo=epel install owncloud"
        yum -y --enablerepo=epel install owncloud 2>&1
        # ln conf
        if [ ! -f /etc/httpd/conf.d/z-owncloud-access.conf ]
        then
            LogInfo "bash# ln -s /etc/httpd/conf.d/owncloud-access.conf.avail /etc/httpd/conf.d/z-owncloud-access.conf"
            ln -s /etc/httpd/conf.d/owncloud-access.conf.avail /etc/httpd/conf.d/z-owncloud-access.conf
        fi
    fi
    
    # install mod_ssl
    if ! rpm --quiet -q mod_ssl
    then
        LogInfo "bash# yum -y install mod_ssl"
        yum -y install mod_ssl 2>&1
        if ! rpm -q mod_ssl
        then
            LogError "Failed to install mod_ssl."
            exit 1
        fi	
    fi
    
    # Notice URL
    var_gip=$(curl -s ipinfo.io | sed -r -e /"ip"/\!d -e 's/.+"ip": "([0-9\.]+)",/\1/g')
    [ -n "${var_gip}" ] && LogNotice "If you have Global IPAddress for https server, access https://${var_gip}/owncloud"
    
    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF

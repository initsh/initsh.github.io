#!/bin/bash

# Edit 20170306
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/owncloud.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh") || echo "$(date -Is) [ERROR]: Failed to load https://${v_github_dir}/functions.sh"

{
    LogInfo "Start \"${v_script_name}\"."
    
    
    . <(curl -LRs "${v_github_dir}/centos7/selinux.sh")
    . <(curl -LRs "${v_github_dir}/centos7/timezone.sh")
    . <(curl -LRs "${v_github_dir}/centos7/utils.sh")
    
    . <(curl -LRs "${v_github_dir}/centos7/epel.sh")
    
    if ! rpm --quiet -q mariadb-server
    then
        LogInfo "bash# yum -y install mariadb-server"
        yum -y install mariadb-server 2>/dev/stdout
        
        v_my_server_cnf="/etc/my.cnf.d/server.cnf"
        v_my_small_cnf="/usr/share/mysql/my-small.cnf"
        \cp -p "${v_my_server_cnf}" "${v_my_server_cnf}${v_backup_suffix}"
        \cp -p "${v_my_small_cnf}" "${v_my_server_cnf}"
    fi
    
    if ! rpm --quiet -q owncloud
    then
        LogInfo "bash# yum -y install owncloud --enablerepo=epel"
        yum -y install owncloud --enablerepo=epel
        if ! rpm --quiet -q mariadb-server
        then
            LogInfo "mariadb> yum -y install owncloud --enablerepo=epel"
            mysql -u"root" -D$schema <<__EOD__
begin;
select table_name, column_name from information_schema.columns where table_schema = "$schema";
insert into hoge values(1, $name3);
commit;
__EOD__
        fi
    fi
    
    if [ ! -f /etc/httpd/conf.d/z-owncloud-access.conf ]; 
        LogInfo "bash# ln -s /etc/httpd/conf.d/owncloud-access.conf.avail /etc/httpd/conf.d/z-owncloud-access.conf"
        ln -s /etc/httpd/conf.d/owncloud-access.conf.avail /etc/httpd/conf.d/z-owncloud-access.conf
    fi
    
    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF

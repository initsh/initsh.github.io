## Zabbix

### Zabbix Server
- ListenPort 10051
```
yum -y install httpd
yum -y install mysql-server
yum -y install http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm
yum-config-manager --disablerepo=zabbiz*
yum -y --enablerepo=zabbix install zabbix-server-mysql zabbix-web-mysql zabbix-web-japanese
chkconfig mysqld on
service mysqld start
mysql_secure_installation
  BuNaiKyoutsu
mysql -uroot -p
  CREATE USER zabbix;
  CREATE DATABASE zabbix CHARACTER SET utf8;
  GRANT ALL PRIVILEGES on zabbix.* TO zabbix@localhost IDENTIFIED BY 'BuNaiKyoutsu';
  FLUSH PRIVILEGES;
mysql -u zabbix -p zabbix < /usr/share/doc/zabbix-server-mysql-2.4.8/create/data.sql
mysql -u zabbix -p zabbix < /usr/share/doc/zabbix-server-mysql-2.4.8/create/images.sql
mysql -u zabbix -p zabbix < /usr/share/doc/zabbix-server-mysql-2.4.8/create/schema.sql
sed -r -e 's/^(# DBPassword=)$/# '"$(date +%Y%m%d)"' #\1\nDBPassword=BuNaiKyoutsu/g' /etc/zabbix/zabbix_server.conf
sed -r -e 's@^([ \t]*)(#[ \t]*)(php_value date.timezone )(Europe/Riga)@# '"$(date +%Y%m%d)"' #\1\2\3\4\n\1\3Asia/Tokyo@g' /etc/httpd/conf.d/zabbix.conf
chkconfig zabbix-server on
service zabbix-server start
chkconfig httpd on
service httpd start
```

### Zabbix Agent
- ListenPort 10050
```
yum -y install http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm
yum-config-manager --disablerepo=zabbiz*
yum -y --enablerepo=zabbix install zabbix-agent
chkconfig zabbix-agent on
server zabbix-agent start
```

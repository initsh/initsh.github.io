# Samba

## CentOS 6.x
#### 下記スクリプトを使用する。
```bash
#!/bin/bash

# utils
yum -y install bind-utils expect lsof mailx net-tools nmap openssh-clients parted tcpdump telnet traceroute unzip vim-enhanced yum-utils zip

# vm-tools
yum -y install open-vm-tools

# mod_ssl
yum -y install mod_ssl

# php 5.6
yum -y install epel-release
yum -y install http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
yum -y install --enablerepo=remi,remi-php56 php php-devel php-mbstring php-pdo php-gd
chkconfig httpd on
lokkit -s http
lokkit -s https
service httpd start

# perl-CGI
yum -y install perl-CGI

# samba
yum -y install samba
echo -n "TYPE SAMBA USER \"root\" PASSWORD(use [a-zA-Z0-9\.]): "
read -s _READ
echo -e "${_READ}\n${_READ}" | pdbedit --password-from-stdin -a root
cat <<__EOD__ > /root/samba.cred
user,password
root,${_READ}
__EOD__
if [ ! -f /etc/samba/smb.conf.org ]; then \cp -p /etc/samba/smb.conf /etc/samba/smb.conf.org; fi
curl -LRsS initsh.github.io/memo/smb.conf > /etc/samba/smb.conf
ln -s / /root/rootdir
ln -s /var /root/var
chkconfig smb on
chkconfig nmb on
service smb start
service nmb start
lokkit -s samba

# EOF
```

# Samba

## CentOS 6.x
```bash
yum -y install samba
chkconfig smb on
chkconfig nmb on
cp -p /etc/samba/smb.conf /etc/samba/smb.conf.org
vim /etc/samba/smb.conf
pdbedit -a $USERNAME
service smb start
service nmb start
lokkit -s samba
```

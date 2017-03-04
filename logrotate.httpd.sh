#!/bin/bash

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
    daily
    rotate 90
    create
    ifempty
    missingok
    dateext
    compress
    delaycompress
    sharedscripts
    postrotate
        /bin/systemctl reload httpd.service > /dev/null 2>/dev/null || true
    endscript
}
__EOD__
echo '--logrotate.d/httpd-------------'
ls -dl "${v_logrotate_httpd}"*

#EOF

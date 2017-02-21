#!/bin/bash
# Edit 20170221
#v_epel_dir='http://dl.fedoraproject.org/pub/epel/7/x86_64/e/'
#v_epel_url="${v_epel_dir}$(curl -kLRs $v_epel_dir | sed -r -e '/epel-release/!d' -e 's/^.*href="(epel-release.*\.rpm)".*$/\1/g')"
v_epel_url='https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
yum -y install yum-utils "${v_epel_url}"
yum-config-manager --disable epel*

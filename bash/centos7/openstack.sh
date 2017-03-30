#!/bin/bash

# https://www.rdoproject.org/install/quickstart/
systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network
yum install -y centos-release-openstack-ocata
yum update -y
yum install -y openstack-packstack



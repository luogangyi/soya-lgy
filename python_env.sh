#!/bin/bash 
yum install python-setuptools
yum install python-setuptools-devel
yum install MySQL-python
yum install mysql-devel
yum install mysql-dev
easy_install -U distribute
easy_install beautifulsoup
easy_install sqlalchemy
easy_install -U pyqqweibo
easy_install MySQL-python

mkdir -p /tbsdata/dosa/src/main/Python/log
mkdir -p /tbsdata/dosa/src/main/Python/log/backup

cp hosts /etc/hosts
service crond restart

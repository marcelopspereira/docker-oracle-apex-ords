#!/bin/bash

exec >> /files/docker_log.txt
exec 2>&1

mv /files/chkconfig /sbin/chkconfig
apt-get update && apt-get install -y -q libaio1 net-tools bc vim
ln -s /usr/bin/awk /bin/awk && mkdir /var/lock/subsys
chmod 755 /sbin/chkconfig


cat /files/oracle-xe_11.2.0-1.0_amd64.deba* > /files/oracle-xe_11.2.0-1.0_amd64.deb
dpkg --install /files/oracle-xe_11.2.0-1.0_amd64.deb
mv /files/init.ora       /u01/app/oracle/product/11.2.0/xe/config/scripts
mv /files/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts

echo "Configure database: -> "$PASSWORD
printf 8888\\n1521\\n$PASSWORD\\n$PASSWORD\\ny\\n | /etc/init.d/oracle-xe configure
echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> /etc/bash.bashrc
echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc
echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc


echo "Install APEX: -> "$PASSWORD
install_apex $PASSWORD


# clean
apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
rm -rf /files/oracle-xe*
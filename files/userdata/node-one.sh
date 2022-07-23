#!/bin/sh
sudo su -
yum -y install samba-client cifs-utils
hostnamectl set-hostname ${tag_name}
echo "${master_private_ip}  master" >> /etc/hosts
mkdir /mnt/master
mkdir /mnt/lab

cat >> /root/.credfile << EOF
username=lab
password=${samba_password}
EOF

echo "//master/lab /mnt/lab  cifs uid=1000,credentials=/root/.credfile,file_mode=0755,dir_mode=0755 0 0" >> /etc/fstab
reboot




#!/bin/sh
sudo su -
dnf -y install samba-client cifs-utils
hostnamectl set-hostname ${tag_name}
echo "${master_private_ip}  master" >> /etc/hosts
mkdir /mnt/master
mkdir /mnt/lab
#mount -t cifs -o username=rocky,password=rocky //master/public /mnt/master

cat >> /root/.credfile << EOF
username=lab
password=bAO9A3fZS312
EOF

echo "//master/lab /mnt/lab   cifs -o credentials=/root/.credfile 0 0" >> /etc/fstab
reboot
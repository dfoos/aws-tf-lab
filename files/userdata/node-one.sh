#!/bin/sh
sudo su -
dnf -y install samba-client cifs-utils postgresql telnet net-tools httpd
hostnamectl set-hostname ${tag_name}
echo "${management_private_ip}  management" >> /etc/hosts
mkdir /mnt/management
mkdir /mnt/lab

cat >> /root/.credfile << EOF
username=lab
password=${samba_password}
EOF

echo "//management/lab /mnt/lab  cifs uid=1000,credentials=/root/.credfile,file_mode=0755,dir_mode=0755 0 0" >> /etc/fstab

sudo systemctl start httpd
sudo systemctl enable httpd

reboot
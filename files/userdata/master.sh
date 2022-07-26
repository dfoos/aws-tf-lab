#!/bin/sh
sudo su -
yum -y install samba samba-common samba-client

mkdir -p /srv/public
chmod -R 755 /srv/public
chown -R  nobody:nobody /srv/public
chcon -t samba_share_t /srv/public


groupadd private_group
useradd -g private_group lab 
mkdir -p /srv/lab
chmod -R 770 /srv/lab
chcon -t samba_share_t /srv/lab
chown -R root:private_group /srv/lab
pass=${samba_password}
printf "$pass\n$pass\n" | smbpasswd -a -s lab

mv /etc/samba/smb.conf /etc/samba/smb.conf.bk

cat >> /etc/samba/smb.conf << EOF
[global]
        workgroup = SAMBA
        security = user

        passdb backend = tdbsam

        printing = cups
        printcap name = cups
        load printers = yes
        cups options = raw

[lab]
        path = /srv/lab
        valid users = lab
        guest ok = no
        writable = yes
        browsable = yes
EOF

systemctl start smb
systemctl enable smb
systemctl start nmb
systemctl enable nmb

sudo firewall-cmd --add-service=samba --zone=public --permanent
sudo firewall-cmd --reload

hostnamectl set-hostname ${tag_name}
reboot
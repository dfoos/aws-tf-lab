#!/bin/sh

# Samba install script for CentOS 7 
sudo su -
yum -y install samba samba-common samba-client telnet net-tools haproxy

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

#sudo firewall-cmd --add-service=samba --zone=public --permanent
#sudo firewall-cmd --reload

# install postgres 11

dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
dnf module -y disable postgresql
dnf clean all
dnf -y install postgresql11-server postgresql11
/usr/pgsql-11/bin/postgresql-11-setup initdb

sudo firewall-cmd --add-service=postgresql
sudo firewall-cmd --runtime-to-permanent

echo "listen_addresses = '*'" >> /var/lib/pgsql/11/data/postgresql.conf
echo "host  all  all 0.0.0.0/0 md5" >> /var/lib/pgsql/11/data/pg_hba.conf
#sed -i '1i host  all  all 0.0.0.0/0 md5' /var/lib/pgsql/11/data/pg_hba.conf
systemctl enable --now postgresql-11

sudo su - postgres <<EOF
psql -c "alter user postgres with password '${samba_password}';"
psql -c "create user user_1;"
psql -c "alter user user_1 with password '${samba_password}';"
psql -c "create database user_db OWNER user_1;"
psql -c "grant all privileges on database user_db to user_1;"
EOF

hostnamectl set-hostname ${tag_name}

sudo systemctl enable --now haproxy
reboot
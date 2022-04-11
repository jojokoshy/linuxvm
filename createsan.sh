#!/bin/bash

#echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

apt -y update 
apt upgrade -y
echo -e '\n updated OS'
# install Apache2
apt install tgt lvm2 -y
echo -e '\n installed required software'
 


 
lsblk --nodeps| awk '$4 ~ /G$/ && $4+0 >= 100 {print $1}' > disknames.txt

while read p; do   pvcreate "/dev/$p"; done <disknames.txt

#DEBIAN_FRONTEND=noninteractive pvcreate /dev/sd{c,d}

 

echo -e '\n pv created successfully'

disknames=''
while read p;do  disknames=$disknames" /dev/"$p; done <disknames.txt

vgcreate jk_iscsi $disknames

echo -e '\n volume created successfully'

sudo lvcreate -l 100%FREE -n jk-1_lun1 jk_iscsi

echo -e '\n logical volume created '

sleep 2m

cat << EOF >> /etc/tgt/conf.d/jk-1_iscsi.conf
<target iqn.0jkepic.jk.com:lun1>
     # Provided device as an iSCSI target
     backing-store /dev/jk_iscsi/jk-1_lun1
     initiator-address 10.1.1.4
 
</target>
EOF

echo -e '\n printed the file '


service tgt restart
systemctl restart tgt

echo -e '\n restarted services '

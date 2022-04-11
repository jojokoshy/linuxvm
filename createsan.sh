#!/bin/bash

echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

sudo apt-get -y update
echo 'updated OS'
# install Apache2
sudo apt-get --assume-yes install tgt lvm2
echo 'installed required software'
 


 
lsblk --nodeps| awk '$4 ~ /G$/ && $4+0 >= 100 {print $1}' > disknames.txt

while read p; do   pvcreate "/dev/$p"; done <disknames.txt

#DEBIAN_FRONTEND=noninteractive pvcreate /dev/sd{c,d}

 

echo 'pv created successfully'

while read p; do   vgcreate jk_iscsi "/dev/$p"; done <disknames.txt



echo 'volume created successfully'

sudo lvcreate -l 100%FREE -n jk-1_lun1 jk_iscsi

echo 'logical volume created '

cat << EOF >> /etc/tgt/conf.d/jk-1_iscsi.conf
<target iqn.0jkepic.jk.com:lun1>
     # Provided device as an iSCSI target
     backing-store /dev/jk_iscsi/jk-1_lun1
     initiator-address 10.1.1.4
 
</target>
EOF

echo 'printed the file '


service tgt restart
systemctl restart tgt

echo 'restarted services '

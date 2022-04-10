#!/bin/bash
apt-get -y update
echo 'updated OS'
# install Apache2
apt-get --assume-yes install tgt lvm2
echo 'installed software'
sudo pvcreate /dev/sd{c,d}
echo 'pv created'

vgcreate jk_iscsi /dev/sd{c,d}

echo 'volume created '

lvcreate -l 100%FREE -n jk-1_lun1 jk_iscsi

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

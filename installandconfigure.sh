#!/bin/bash
apt-get -y update

# install Apache2
apt-get --assume-yes install tgt lvm2

pvcreate /dev/sd{c,d}
vgcreate jk_iscsi /dev/sd{c,d}

lvcreate -l 100%FREE -n jk-1_lun1 jk_iscsi
cat << EOF >> /etc/tgt/conf.d/jk-1_iscsi.conf
<target iqn.0jkepic.jk.com:lun1>
     # Provided device as an iSCSI target
     backing-store /dev/jk_iscsi/jk-1_lun1
     initiator-address 10.1.1.4
 
</target>
EOF

service tgt restart
systemctl restart tgt

#!/bin/bash

echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

sudo apt-get -y update
echo 'updated OS'
# install Apache2
sudo apt-get --assume-yes install tgt lvm2
echo 'installed software'
 


 
 

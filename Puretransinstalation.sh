#!/bin/bash


cd /tmp
set -e
rm -rf *Puretransinstalation* > /dev/null 2>&1
wget https://github.com/ahmeds200917/A.Shawky/blob/main/Puretransinstalation.sh
tar -xzf /tmp/*.tar.gz -C /

wait
opkg install --force-overwrite /tmp/*.ipk

rm -r /tmp/pure2trans.tar.gz
sleep 2;

fi

sync
echo "#########################################################"
echo "#      Pure2 translation installed              #"
echo "#                 By Ahmed Shawky                     #"              
echo "#                     support                           #"
echo "#                   Novaler team              #"
echo "#########################################################"
echo "#           your Device will RESTART Now                #"
echo "#########################################################"
sleep 3
killall enigma2
exit 0











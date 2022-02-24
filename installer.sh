#!/bin/sh

version=1.4
Novaler
# remove old version
if [ -f /var/lib/dpkg/status ]; then
   apt-ger -r enigma2-plugin-extensions-arabicsavior
else
   opkg remove enigma2-plugin-extensions-arabicsavior
fi

cd /tmp
rm -f *ArabicSavior*
# Download new version
wget -O /tmp/ArabicSavior-1.4.tar.gz "https://raw.githubusercontent.com/ahmeds200917/A.Shawky/main/ArabicSavior-1.4.tar.gz"

# remove old version
rm -r /usr/lib/enigma2/python/Plugins/Extensions/ArabicSavior > /dev/null 2>&1

# Install new version
tar -xzf /tmp/*.tar.gz -C /

sync
echo "#########################################################"
echo "#      ArabicSavior INSTALLED SUCCESSFULLY              #"
echo "#     mfaraj57  &  RAED  & Ahmed Shawky                 #"              
echo "#                     support                           #"
echo "#   https://www.tunisia-sat.com/forums/threads/3896466/ #"
echo "#########################################################"
echo "#           your Device will RESTART Now                #"
echo "#########################################################"
sleep 3
killall -9 enigma2
exit 0

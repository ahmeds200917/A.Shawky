#!/bin/sh

######### Only These two lines to edit with new version ######
version=26.10.2020
##############################################################

CHECK='/tmp/check'

# check depends packges
if [ -f /etc/apt/apt.conf ] ; then
   STATUS='/var/lib/dpkg/status'
   OS='DreamOS'
elif [ -f /etc/opkg/opkg.conf ] ; then
   STATUES='/var/lib/opkg/status'
   OS='Opensource'
fi

if grep -q 'libcrypto-compat' $STATUES; then
    libcrypto-compat='installed'
fi
if grep -q 'libcrypto-compat-0.9.7' $STATUES; then
    libcrypto-compat-0.9.7='installed'
fi
if grep -q 'libcrypto-compat-1.0.0' $STATUES; then
    libcrypto-compat-1.0.0='installed'
fi

if [ $libcrypto-compat = "installed" -a $libcrypto-compat-0.9.7 = "installed" -a $libcrypto-compat-1.0.0 = "installed" ]; then 
     echo "All Depends Are Installed"
else
     echo "=========================================================================="
     echo "Some Depends Need to Be downloaded From Feeds ...."
     if [ $OS = "DreamOS" ]; then
		echo "========================================================================"
		echo " Downloading libcrypto-compat,libcrypto-compat-0.9.7,libcrypto-compat-1.0.0 ......"
		apt-get install Downloading libcrypto libcrypto-compat-0.9.7 libcrypto-compat-1.0.0 -y
     else
		echo "========================================================================"
		echo " Downloading libcrypto-compat ......"
		opkg install libcrypto-compat
		echo "========================================================================"
		echo " Downloading libcrypto-compat-0.9.7 ......"
		opkg install libcrypto-compat-0.9.7
		echo "========================================================================"
		echo " Downloading libcrypto-compat-1.0.0 ......"
		opkg install libcrypto-compat-1.0.0
		echo "========================================================================"
     fi
fi
echo ""
sleep 5

if [ -f /lib/ld-2.28.so ]; then
	ln -s /lib/ld-2.28.so /lib/ld-linux.so.3
elif [ -f /lib/ld-2.26.so ]; then
	ln -s /lib/ld-2.26.so /lib/ld-linux.so.3
elif [ -f /lib/ld-2.25.so ]; then
	ln -s /lib/ld-2.25.so /lib/ld-linux.so.3
elif [ -f /lib/ld-2.30.so ]; then
	ln -s /lib/ld-2.30.so /lib/ld-linux.so.3

fi

opkg install --force-reinstall --force-overwrite  https://github.com/ahmeds200917/A.Shawky/blob/main/enigma2-plugin-softcams-ncam-gosatplus_1.0_all.ipk
opkg install --force-reinstall --force-overwrite  https://github.com/ahmeds200917/A.Shawky/blob/main/enigma2-plugin-softcams-oscam-gosatplus_1.0_all.ipk


exit 0
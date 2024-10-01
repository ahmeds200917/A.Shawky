#!/bin/sh

echo ''
echo '************************************************************'
echo "**                       STARTED                          **"
echo '************************************************************'
echo "**                  Uploaded by: AShawky                    **"
echo "************************************************************"
echo ''
sleep 3s

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/xtraEvent ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/xtraEvent > /dev/null 2>&1
fi

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-xtraEvent'

if grep -q $package $status; then
opkg remove $package > /dev/null 2>&1
fi

sleep 3s

echo "downloading xtraEvent..."
wget -O  /var/volatile/tmp/xtraevent-6.78.tar.gz https://gitlab.com/eliesat/extensions/-/raw/main/xtraevent/xtraevent-6.78.tar.gz
echo "Installing SubsSupport..."
tar -xzf /var/volatile/tmp/xtraevent-6.78.tar.gz -C /
rm -rf /var/volatile/tmp/xtraevent-6.78.tar.gz
sync
echo "#########################################################"
echo "#########################################################"
echo "Installing dependency files"
opkg install python3-codecs" "python3-compression" "python3-core" "python3-difflib" "python3-json" "python3-requests" "python3-xmlrpc

SETTINGS="/etc/enigma2/settings"
echo "Adding new settings for xtraevent..."
echo ""
echo ">>>>>>>>>     RESTARTING     <<<<<<<<<"
echo ""
init 4
sleep 3
sed -i "/xtraevent/d" $SETTINGS
{
    echo "config.plugins.xtraEvent.apis=True"
	echo "config.plugins.xtraEvent.deletFiles=False"
	echo "config.plugins.xtraEvent.extra3=True"
	echo "config.plugins.xtraEvent.FanartSearchType=movies"
	echo "config.plugins.xtraEvent.loc=/media/hdd/"
	echo "config.plugins.xtraEvent.searchMANUELnmbr=0"
	echo "config.plugins.xtraEvent.searchNUMBER=8"
	echo "config.plugins.xtraEvent.tmdbAPI=c7ca0c239088f1ae72a197d1b4be51b8"
	echo "config.plugins.xtraEvent.searchType=movie"
	echo "config.plugins.xtraEvent.timerHour=2"
	echo "config.plugins.xtraEvent.timerMod=Period"
	echo "config.plugins.xtraEvent.tmdbAPI=c7ca0c239088f1ae72a197d1b4be51b8"
	echo "config.plugins.xtraEvent.tvdb=True"
        echo "config.plugins.xtraEvent.tvdbAPI=a99d487bb3426e5f3a60dea6d3d3c7ef"
	
} >> $SETTINGS

# ============================================================================================================
sleep 2
sync
init 3
echo "==================================================================="
echo "===                          FINISHED                           ==="
echo "                         Modded by AShawky                        ==="
echo "==================================================================="
sleep 2
exit 0

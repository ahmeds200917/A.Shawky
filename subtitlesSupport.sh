#!/bin/sh
echo ''
echo '************************************************************'
echo "**                       STARTED                          **"
echo '************************************************************'
echo "**                  Uploaded by: Ahmed Shawky                    **"
echo "************************************************************"
echo "**                 SubsSupport v1.5.11                  **"
echo "************************************************************"
echo ''
sleep 3s

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/SubsSupport ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/SubsSupport > /dev/null 2>&1
fi

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-subssupport'

if grep -q $package $status; then
opkg remove $package > /dev/null 2>&1
fi

sleep 3s

echo "downloading SubsSupport..."
wget -O  /var/volatile/tmp/SubsSupport.tar.gz https://github.com/ahmeds200917/A.Shawky/raw/refs/heads/main/SubsSupport.tar.gz
echo "Installing SubsSupport..."
tar -xzf /var/volatile/tmp/SubsSupport.tar.gz -C /
rm -rf /var/volatile/tmp/SubsSupport.tar.gz
sync
echo "#########################################################"
echo "#########################################################"
echo "Installing dependency files"
opkg install python3-codecs python3-compression python3-core python3-difflib python3-json python3-requests python3-xmlrpc unrar

SETTINGS="/etc/enigma2/settings"
echo "Adding new settings for subssupport..."
echo ""
echo ">>>>>>>>>     RESTARTING     <<<<<<<<<"
echo ""
init 4
sleep 3
sed -i "/subtitlesSupport/d" $SETTINGS
{
	echo "config.plugins.subtitlesSupport.encodingsGroup=Arabic"
echo "config.plugins.subtitlesSupport.external.font.bold.color=ffff00"
echo "config.plugins.subtitlesSupport.external.font.bold.type=Regular"
echo "config.plugins.subtitlesSupport.external.font.italic.color=ffff00"
echo "config.plugins.subtitlesSupport.external.font.italic.type=Regular"
echo "config.plugins.subtitlesSupport.external.font.regular.color=ffff00"
echo "config.plugins.subtitlesSupport.external.font.regular.type=Regular"
echo "config.plugins.subtitlesSupport.external.font.size=59"
echo "config.plugins.subtitlesSupport.external.shadow.color=ff0000"
echo "config.plugins.subtitlesSupport.external.shadow.size=4"
echo "config.plugins.subtitlesSupport.search.edna_cz.enabled=False"
echo "config.plugins.subtitlesSupport.search.history=A Thousand and One,Carmen"
echo "config.plugins.subtitlesSupport.search.indexsubtitle.enabled=False"
echo "config.plugins.subtitlesSupport.search.itasa.enabled=False"
echo "config.plugins.subtitlesSupport.search.lang1=ar"
echo "config.plugins.subtitlesSupport.search.lang2=ar"
echo "config.plugins.subtitlesSupport.search.lang3=ar"
echo "config.plugins.subtitlesSupport.search.moviesubtitles.enabled=False"
echo "config.plugins.subtitlesSupport.search.moviesubtitles2.enabled=False"
echo "config.plugins.subtitlesSupport.search.opensbutitles_com.enabled=False"
echo "config.plugins.subtitlesSupport.search.opensubtitles.enabled=False"
echo "config.plugins.subtitlesSupport.search.opensubtitles_com.enabled=False"
echo "config.plugins.subtitlesSupport.search.podnapisi.enabled=False"
echo "config.plugins.subtitlesSupport.search.prijevodionline.enabled=False"
echo "config.plugins.subtitlesSupport.search.serialzone_cz.enabled=False"
echo "config.plugins.subtitlesSupport.search.subdl_com.enabled=False"
echo "config.plugins.subtitlesSupport.search.subscene.enabled=False"
echo "config.plugins.subtitlesSupport.search.subtitlecat_com.enabled=False"
echo "config.plugins.subtitlesSupport.search.subtitles_gr.enabled=False"
echo "config.plugins.subtitlesSupport.search.subtitlist.enabled=False"
echo "config.plugins.subtitlesSupport.search.titlovi.enabled=False"
echo "config.plugins.subtitlesSupport.search.titulky_com.enabled=False"

	
} >> $SETTINGS

# ============================================================================================================
sleep 2
sync
init 3
echo "==================================================================="
echo "===                          FINISHED                           ==="
echo "                         Modded by Ahmed Shawky                        ==="
echo "==================================================================="
sleep 2
exit 0
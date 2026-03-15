#!/bin/sh

if [ -d /usr/lib/enigma2/python/Plugins/Extensions/IPAudioUltmate ]; then
echo "> removing package please wait..."
sleep 3s 
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/IPAudioUltmate > /dev/null 2>&1

status='/var/lib/opkg/status'
package='enigma2-plugin-extensions-IPAudioUltmate'

if grep -q $package $status; then
opkg remove $package > /dev/null 2>&1
fi

echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By Ahhmed Shawky          *"
echo "*******************************************"
sleep 3s

else

#remove unnecessary files and folders
if [  -d "/CONTROL" ]; then
rm -r  /CONTROL >/dev/null 2>&1
fi
rm -rf /control >/dev/null 2>&1
rm -rf /postinst >/dev/null 2>&1
rm -rf /preinst >/dev/null 2>&1
rm -rf /prerm >/dev/null 2>&1
rm -rf /postrm >/dev/null 2>&1
rm -rf /tmp/*.ipk >/dev/null 2>&1
rm -rf /tmp/*.tar.gz >/dev/null 2>&1

#config
version=py3.13
TEMPATH='/tmp'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/IPAudioUltmate'
CHECK='/tmp/check'
BINDIR='/usr/bin/'
ARMBIN='/tmp/IPAudioUltmate/bin/arm/gst1.0-IPAudioUltmate'
FFPPLAYERA='/tmp/IPAudioUltmate/bin/arm/ff4/ff-IPAudioUltmate'
MIPSBIN='/tmp/IPAudioUltmate/bin/mips/gst1.0-IPAudioUltmate'
FFPPLAYERM='/tmp/IPAudioUltmate/bin/mips/ff4/ff-IPAudioUltmate'
IPAudioUltmate='/tmp/IPAudioUltmate/usr/*'
PLAYLIST='/tmp/IPAudioUltmate/etc/IPAudioUltmate.json'
ASOUND='/tmp/IPAudioUltmate/etc/asound.conf'

uname -m >$CHECK

# kill player if in use
ps_out=$(ps -ef | grep gst1.0-IPAudioUltmate | grep -v 'grep' | grep -v $0)
result=$(echo $ps_out | grep "gst1.0-IPAudioUltmate")
if [[ "$result" != "" ]]; then
        killall -9 gst1.0-IPAudioUltmate
fi

ps_out=$(ps -ef | grep ff-IPAudioUltmate | grep -v 'grep' | grep -v $0)
result=$(echo $ps_out | grep "ff-IPAudioUltmate")
if [[ "$result" != "" ]]; then
        killall -9 ff-IPAudioUltmate
fi

# check depends packges
if [ -f /var/lib/dpkg/status ]; then
        STATUS='/var/lib/dpkg/status'
        OS='DreamOS'
else
        STATUS='/var/lib/opkg/status'
        OS='Opensource'
fi

if grep -q 'gstreamer1.0-plugins-base-volume' $STATUS; then
        gstVol='Installed'
fi

if grep -q 'gstreamer1.0-plugins-good-ossaudio' $STATUS; then
        gstOss='Installed'
fi

if grep -q 'gstreamer1.0-plugins-good-mpg123' $STATUS; then
        gstMp3='Installed'
fi

if grep -q 'gstreamer1.0-plugins-good-equalizer' $STATUS; then
        equalizer='Installed'
fi

if grep -q 'ffmpeg' $STATUS; then
        ffmpeg='Installed'
fi

if grep -q 'alsa-plugins' $STATUS; then
        alsaPlug='Installed'
fi

if [ "$gstVol" = "Installed" ] && [ "$gstOss" = "Installed" ] && [ "$gstMp3" = "Installed" ] && [ "$equalizer" = "Installed" ] && [ "$ffmpeg" = "Installed" ] && [ "$alsaPlug" = "Installed" ]; then
        echo ""
else
        if [ $OS = "DreamOS" ]; then
                echo "=========================================================================="
                echo "Some Depends Need to Be downloaded From Feeds ...."
                echo "=========================================================================="
                echo "apt update ..."
                echo "========================================================================"
                apt-get update
                echo " Downloading gstreamer1.0-plugins-base-volume ......"
                apt-get install gstreamer1.0-plugins-base-volume -y
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-ossaudio ......"
                apt-get install gstreamer1.0-plugins-good-ossaudio -y
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-mpg123 ......"
                apt-get install gstreamer1.0-plugins-good-mpg123 -y
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-equalizer ......"
                apt-get install gstreamer1.0-plugins-good-equalizer -y
                echo "========================================================================"
                echo " Downloading ffmpeg ......"
                apt-get install ffmpeg -y
                echo "========================================================================"
                echo " Downloading alsa-plugins ......"
                apt-get install alsa-plugins -y
                echo "========================================================================"
        else
                echo "=========================================================================="
                echo "Some Depends Need to Be downloaded From Feeds ...."
                echo "=========================================================================="
                echo "Opkg Update ..."
                echo "========================================================================"
                opkg update
                echo " Downloading gstreamer1.0-plugins-base-volume ......"
                opkg install gstreamer1.0-plugins-base-volume
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-ossaudio ......"
                opkg install gstreamer1.0-plugins-good-ossaudio
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-mpg123 ......"
                opkg install gstreamer1.0-plugins-good-mpg123
                echo "========================================================================"
                echo " Downloading gstreamer1.0-plugins-good-equalizer ......"
                opkg install gstreamer1.0-plugins-good-equalizer
                echo "========================================================================"
                echo " Downloading ffmpeg ......"
                opkg install ffmpeg
                echo "========================================================================"
                echo " Downloading alsa-plugins ......"
                opkg install alsa-plugins
                echo "========================================================================"
        fi
fi

if grep -q 'gstreamer1.0-plugins-base-volume' $STATUS; then
        echo ""
else
        echo "#########################################################"
        echo "#  gstreamer1.0-plugins-base-volume Not found in feed   #"
        echo "#         IPAudioUltmate has not been installed                #"
        echo "#########################################################"
        rm -r /tmp/IPAudioUltmate >/dev/null 2>&1
        rm -f $CHECK >/dev/null 2>&1
        exit 1
fi

if grep -q 'alsa-plugins' $STATUS; then
        echo ""
else
        echo "#########################################################"
        echo "#         alsa-plugins Not found in feed                #"
        echo "#         IPAudioUltmate has not been installed                #"
        echo "#########################################################"
        rm -r /tmp/IPAudioUltmate >/dev/null 2>&1
        rm -f $CHECK >/dev/null 2>&1
        exit 1
fi

# remove old version
rm -rf $PLUGINPATH >/dev/null 2>&1
rm -f /usr/bin/gst1.0-IPAudioUltmate >/dev/null 2>&1
rm -f /usr/bin/ff-IPAudioUltmate >/dev/null 2>&1

echo "> Downloading IPAudioUltmate-$version package  please wait ..."
sleep 3s

cd $TEMPATH
set -e
wget "https://raw.githubusercontent.com/ahmeds200917/A.Shawky/refs/heads/main/IPAudioUltmateUltmatepy3.13.tar.gz"

tar -xzf IPAudioUltmate-"$version"-ffmpeg.tar.gz -C /tmp
set +e
extract=$?
rm -f IPAudioUltmate-"$version"-ffmpeg.tar.gz
cd ..

if grep -qs -i 'mips' cat $CHECK; then
        echo "[ Your device is MIPS ]"
        cp -a $MIPSBIN $BINDIR
        cp -a $FFPPLAYERM $BINDIR
        chmod 0775 /usr/bin/gst1.0-IPAudioUltmate
        chmod 0775 /usr/bin/ff-IPAudioUltmate
elif grep -qs -i 'armv7l' cat $CHECK; then
        echo "[ Your device is armv7l ]"
        cp -a $ARMBIN $BINDIR
        cp -a $FFPPLAYERA $BINDIR
        chmod 0775 /usr/bin/gst1.0-IPAudioUltmate
        chmod 0775 /usr/bin/ff-IPAudioUltmate
else
        
        echo "> Your stb is not supported "
        
        rm -r /tmp/IPAudioUltmate
        rm -f $CHECK
        exit 1
        echo ""
fi

mkdir -p $PLUGINPATH
cp -r $IPAudioUltmate $PLUGINPATH

if [ ! -f /etc/enigma2/IPAudioUltmate.json ]; then
        cp -a $PLAYLIST /etc/enigma2
fi

if [ ! -f /etc/asound.conf ]; then
        echo "Sending asound.conf to /etc"
        cp -a $ASOUND /etc
fi

rm -r /tmp/IPAudioUltmate
rm -f $CHECK

echo ''
if [ $extract -eq 0 ]; then
echo "> IPAudioUltmate-$version package installed successfully"
echo "> Uploaded By ElieSat"
sleep 3s

else

echo "> IPAudioUltmate-$version package installation failed"
sleep 3s
fi

fi
exit 0

#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL ncam-gosatplus
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Oscam_Ncam/installer.sh -q; sh installer.sh
#
# ###########################################

###########################################
# Configure where we can find things here #

PACKAGE='libcurl4'
TMPDIR='/tmp'
DIR=$(pwd)
SOFTPATH='/etc/tuxbox/config/GoSatPluS-emu/SoftCam.Key'
OSC_VERSION='11.703-emu-r798'
NCM_VERSION='V12.4-r0'
OSC_PACKAGE='enigma2-plugin-softcams-oscam'
NCM_PACKAGE='enigma2-plugin-softcams-ncam'
MY_URL='https://github.com/ahmeds200917/A.Shawky/blob/main/enigma2-plugin-softcams-ncam-gosatplus_1.0_all.ipk'

####################
#  Image Checking  #

if [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGREMOV='opkg remove --force-depends'
elif [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
    OPKGREMOV='apt-get purge --auto-remove'
    DPKINSTALL='dpkg -i --force-overwrite'
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${OSC_PACKAGE:?}"* $TMPDIR/"${NCM_PACKAGE:?}"* > /dev/null 2>&1

################
# Oscam Remove #
removeoscam() {
    if grep -qs "Package: $OSC_PACKAGE*" $STATUS ; then
        echo "   >>>>   Remove Old Version   <<<<"
        echo
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGREMOV $OSC_PACKAGE*
            sleep 2; clear
        else
            $OPKGREMOV $OSC_PACKAGE
            sleep 2; clear
        fi
    else
        echo "   >>>>   No Older Version Was Found   <<<<"
        sleep 1; clear
    fi
}
################
# Ncam Remove  #
removencam() {
    if grep -qs "Package: $NCM_PACKAGE" $STATUS ; then
        echo "   >>>>   Remove Old Version   <<<<"
        echo
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGREMOV $NCM_PACKAGE
            sleep 2; clear
        else
            $OPKGREMOV $NCM_PACKAGE
            sleep 2; clear
        fi
    else
        echo "   >>>>   No Older Version Was Found   <<<<"
        sleep 1; clear
    fi
}
#####################
# Package Checking  #
if grep -qs "Package: $PACKAGE" $STATUS ; then
    echo
else
    echo "   >>>>   Need to install $PACKAGE   <<<<"
    echo
    if [ $OSTYPE = "Opensource" ]; then
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        echo
        echo " Downloading $PACKAGE ......"
        echo
        $OPKGINSTAL $PACKAGE
    elif [ $OSTYPE = "DreamOS" ]; then
        echo "APT Update ..."
        $OPKG > /dev/null 2>&1
        echo " Downloading $PACKAGE ......"
        echo
        $OPKGINSTAL $PACKAGE -y
    else
        echo ""
        echo ""
        echo "   >>>>   Feed Missing $PACKAGE   <<<<"
        echo "   >>>>   Notification Emu will not work without $PACKAGE   <<<<"
        sleep 3
        exit 0
    fi
fi

#####################
clear
echo "> Oscam EMU MENU"
echo
echo "  1 - Oscam"
echo "  2 - Ncam"
echo "  3 - SupTV_Oscam"
echo "  4 - oscam-gosatplus"
echo "  5 - SoftCam_Online"
echo "  6 - ncam-gosatplus"
echo
echo "  x - Exit"
echo
echo "- Enter option:"
read -r opt
case $opt in
    "1") Oscam removeoscam
        if [ $OSTYPE = "Opensource" ]; then
            echo "Insallling Oscam plugin Please Wait ......"
            wget $MY_URL/${OSC_PACKAGE}_${OSC_VERSION}_all.ipk -qP $TMPDIR
            $OPKGINSTAL $TMPDIR/${OSC_PACKAGE}_${OSC_VERSION}_all.ipk
        else
            echo "Insallling Oscam plugin Please Wait ......"
            wget $MY_URL/${OSC_PACKAGE}_${OSC_VERSION}_all.deb -qP $TMPDIR
            $DPKINSTALL $TMPDIR/${OSC_PACKAGE}_${OSC_VERSION}_all.deb; $OPKGINSTAL -f -y
        fi
        ;;
    "2") EMU=Ncam removencam
        if [ $OSTYPE = "Opensource" ]; then
            echo "Insallling Ncam plugin Please Wait ......"
            wget $MY_URL/${NCM_PACKAGE}_${NCM_VERSION}_all.ipk -qP $TMPDIR
            $OPKGINSTAL $TMPDIR/${NCM_PACKAGE}_${NCM_VERSION}_all.ipk
        else
            echo "Insallling Ncam plugin Please Wait ......"
            wget $MY_URL/${NCM_PACKAGE}_${NCM_VERSION}_all.deb -qP $TMPDIR
            $DPKINSTALL $TMPDIR/${NCM_PACKAGE}_${NCM_VERSION}_all.deb; $OPKGINSTAL -f -y
        fi
        ;;
    "3") EMU=SupTV_Oscam removeoscam
        echo "Insallling SupTV_Oscam plugin Please Wait ......"
        wget $MY_URL/${OSC_PACKAGE}-supcam_${OSC_VERSION}_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${OSC_PACKAGE}-supcam_${OSC_VERSION}_all.ipk
        ;;
    "4") EMU=oscam-gosatplus removeoscam
        echo "Insallling oscam-gosatplus plugin Please Wait ......"
        wget $MY_URL/${OSC_PACKAGE}-revcamv2_${OSC_VERSION}_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${OSC_PACKAGE}-revcamv2_${OSC_VERSION}_all.ipk
        ;;
    "5") EMU=SoftCam_Online
        rm -rf $SOFTPATH
        echo "Downlaod Softcam Please Wait ......"
        wget -qO $SOFTPATH "https://raw.githubusercontent.com/popking159/softcam/master/SoftCam.Key"
        chmod 755 $SOFTPATH
        ;;
    "6") EMU=ncam-gosatplus removeoscam
        echo "Insallling ncam-gosatplus plugin Please Wait ......"
        wget $MY_URL/${OSC_PACKAGE}-revcamv2_${OSC_VERSION}_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${OSC_PACKAGE}-revcamv2_${OSC_VERSION}_all.ipk
        ;;
    x)
        clear
        echo
        echo "Goodbye ;)"
        echo
        ;;
    *)
        echo "Invalid option"
        sleep 2
        ;;
esac


################################
# Remove script files (if any) #
rm -rf $TMPDIR/"${OSC_PACKAGE:?}"* $TMPDIR/"${NCM_PACKAGE:?}"* "$DIR"/installer.sh > /dev/null 2>&1

exit 1
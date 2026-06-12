#!/bin/bash
#
# Command: wget -q "--no-check-certificate" https://github.com/ahmeds200917/A.Shawky/blob/main/enigma2-plugin-skins-jihad_2.10_all.ipk -O - | /bin/sh #
echo "------------------------------------------------------------------------"
echo "              You are going to install Jihad                      "
echo "------------------------------------------------------------------------"
echo "removing the previous version of Jihad... "
sleep 2;
if [ -d /usr/share/enigma2/Jihad] ; then
    opkg remove Jihad
    rm -rf /usr/share/enigma2/Jihad> /dev/null 2>&1
    echo 'Package removed.'
else
    echo "You do not have previous version of Jihad"
fi
echo ""
# Install curl if not already installed
echo "Install curl if not already installed "
opkg install curl
sleep 2

#
cd /tmp
echo "Downloading Jihadskin package..."
curl -s -k -L "https://github.com/ahmeds200917/A.Shawky/blob/main/enigma2-plugin-skins-jihad_2.10_all.ipk" -o /tmp/aglareatv.ipk
if [ $? -ne 0 ]; then
    echo "Error downloading Jihad"
    exit 1
fi
sleep 1

echo "Installing ...."
opkg install --force-overwrite /tmp/enigma2-plugin-skins-jihad_2.10_all.ipk
if [ $? -ne 0 ]; then
    echo "Error installing Jihad"
    exit 1
fi

echo ""
echo ""
echo ""
sleep 1

echo "Clean up the temporary file"
if [ -f /tmp/enigma2-plugin-skins-jihad_2.10_all.ipk ]; then
    rm -f /tmp/enigma2-plugin-skins-jihad_2.10_all.ipk
fi

echo "Done"
#
echo "------------------------------------------------------------------------"
echo "                            CONGRATULATIONS                             "
echo "                   JihadInstalled Successfully                    "
echo "------------------------------------------------------------------------"
echo "   "
exit 0

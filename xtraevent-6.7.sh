#!/bin/sh

# Configuration
plugin="xtraevent"
version="6.78"
targz_file="$plugin-$version.tar.gz"
package="enigma2-plugin-extensions-xtraevent"
temp_dir="/tmp"
url="https://raw.githubusercontent.com/ahmeds200917/A.Shawky/refs/heads/main/xtraevent_6.78.tar.gz"



#check and install dependencies
# Check python
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")

deps=("unrar" "perl-module-io-zlib")

if [ "$pyVersion" = 3 ]; then
  deps+=( "python3-codecs" "python3-compression" "python3-core" "python3-difflib" "python3-json" "python3-requests" "python3-xmlrpc" )
else
deps+=( "python-codecs" "python-compression" "python-core" "python-difflib" "python-json" "python-requests" "python-xmlrpc" )
fi

left=">>>>"
right="<<<<"
LINE1="---------------------------------------------------------"
LINE2="-------------------------------------------------------------------------------------"

if [ -f /etc/opkg/opkg.conf ]; then
  STATUS='/var/lib/opkg/status'
  OSTYPE='Opensource'
  OPKG='opkg update'
  OPKGINSTAL='opkg install'
elif [ -f /etc/apt/apt.conf ]; then
  STATUS='/var/lib/dpkg/status'
  OSTYPE='DreamOS'
  OPKG='apt-get update'
  OPKGINSTAL='apt-get install -y'
fi

install() {
  if ! grep -qs "Package: $1" "$STATUS"; then
    $OPKG >/dev/null 2>&1
    rm -rf /run/opkg.lock
    echo -e "> Need to install ${left} $1 ${right} please wait..."
    echo "$LINE2"
    sleep 0.8
    echo
    if [ "$OSTYPE" = "Opensource" ]; then
      $OPKGINSTAL "$1"
      sleep 1
      clear
    elif [ "$OSTYPE" = "DreamOS" ]; then
      $OPKGINSTAL "$1" -y
      sleep 1
      clear
    fi
  fi
}

for i in "${deps[@]}"; do
  install "$i"
done

#download & install package
echo "> Downloading $plugin-$version package  please wait ..."
sleep 3
wget --show-progress -qO $temp_dir/$targz_file --no-check-certificate $url
tar -xzf $temp_dir/$targz_file -C /
extract=$?
rm -rf $temp_dir/$targz_file >/dev/null 2>&1

echo ''
if [ $extract -eq 0 ]; then
echo "> $plugin-$version package installed successfully"
sleep 3

echo "> Setup the plugin..."
# Configure ajpanel_settings
touch "$temp_dir/temp_file"
cat <<EOF > "$temp_dir/temp_file"
config.plugins.xtraEvent.apis=True
config.plugins.xtraEvent.deletFiles=False
config.plugins.xtraEvent.extra3=True
config.plugins.xtraEvent.FanartSearchType=movies
config.plugins.xtraEvent.loc=/media/hdd/
config.plugins.xtraEvent.searchMANUELnmbr=0
config.plugins.xtraEvent.searchNUMBER=8
config.plugins.xtraEvent.tmdbAPI=c7ca0c239088f1ae72a197d1b4be51b8
config.plugins.xtraEvent.searchType=movie
config.plugins.xtraEvent.timerHour=2
config.plugins.xtraEvent.timerMod=Period
config.plugins.xtraEvent.tmdbAPI=c7ca0c239088f1ae72a197d1b4be51b8
config.plugins.xtraEvent.tvdb=True
config.plugins.xtraEvent.tvdbAPI=a99d487bb3426e5f3a60dea6d3d3c7ef
EOF

# Update Enigma2 settings
sed -i "/xtraEvent/d" /etc/enigma2/settings
grep "config.plugins.xtraEvent.*" "$temp_dir/temp_file" >> /etc/enigma2/settings
rm -rf "$temp_dir/temp_file" >/dev/null 2>&1

sleep 2
echo "> Setup done..., Please wait enigma2 restarting..."
sleep 1
echo "> Uploaded By ElieSat"

# Restart Enigma2 service or kill enigma2 based on the system
if [ -f /etc/apt/apt.conf ]; then
    sleep 2
    systemctl restart enigma2
else
    sleep 2
    killall -9 enigma2
fi
else
echo "> $plugin-$version package installation failed"
sleep 3
fi
    

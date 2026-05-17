#!/bin/sh

# Configuration
plugin="DVBAudioPRO"
version="6.8"
targz_file="$plugin-$version.tar.gz"
package="enigma2-plugin-extensions-DVBAudioPRO"
temp_dir="/tmp"
url="https://raw.githubusercontent.com/ahmeds200917/A.Shawky/refs/heads/main/DVBAudioPRO3.13.tar.gz"

# Determine package manager
if command -v dpkg &> /dev/null; then
package_manager="apt"
status_file="/var/lib/dpkg/status"
uninstall_command="apt-get purge --auto-remove -y"
else
package_manager="opkg"
status_file="/var/lib/opkg/status"
uninstall_command="opkg remove --force-depends"
fi

check_and_remove_package() {
if [ -d /usr/lib/enigma2/python/Plugins/Extensions/DVBAudioPRO ]; then
echo "> removing package old version please wait..."
sleep 3
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/DVBAudioPRO > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Converter/xtra* > /dev/null 2>&1
rm -rf /usr/lib/enigma2/python/Components/Renderer/xtra* > /dev/null 2>&1

if grep -q "$package" "$status_file"; then
echo "> Removing existing $package package, please wait..."
$uninstall_command $package
fi
echo "*******************************************"
echo "*             Removed Finished            *"
echo "*            Uploaded By ahmed shawky          *"
echo "*******************************************"
sleep 3
exit 1
else
echo " " 
fi  }
check_and_remove_package

#check and install dependencies
# Check python
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")

deps=("unrar" "perl-module-io-zlib")

if [ "$pyVersion" = 3 ]; then
  deps+=( "gstreamer1.0-plugins-base-volume" "python3-pytz" "ffmpeg" "gstreamer1.0" "gstreamer1.0-plugins-base" "gstreamer1.0-plugins-good" "gstreamer1.0-plugins-bad" "gstreamer1.0-plugins-ugly" "gstreamer1.0-libav" "python3-core" "python3-twisted" "alsa-utils" )
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

sleep 2
echo "> Setup done..., Please wait enigma2 restarting..."
sleep 1
echo "> Uploaded By Ahmed shawky "

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
    
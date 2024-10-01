#!/bin/sh
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

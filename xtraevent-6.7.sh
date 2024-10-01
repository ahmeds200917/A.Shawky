#!/bin/sh

sleep 1
wget -q https://gitlab.com/eliesat/extensions/-/raw/main/xtraevent/xtraevent-6.78.tar.gz -P /tmp
echo "Downloading the latest plugin version..."
sleep 1
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/xtraEvent
rm -rf /usr/lib/enigma2/python/Components/Converter/xtra*
rm -rf /usr/lib/enigma2/python/Components/Renderer/xtra*
rm -rf /usr/share/enigma2/xtra
echo "old version is removed..."
sleep 1
if [ -f /tmp/xtraEvent.tar.gz ]; then
	tar -xzf /tmp/xtraEvent.tar.gz -C /
sleep 1


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
    

#!/bin/sh

URL="https://raw.githubusercontent.com/ahmeds200917/A.Shawky/refs/heads/main/jihad.ipk"
TMP="/tmp/jihad.ipk"

echo "Downloading Skin..."
wget -q --no-check-certificate -O "$TMP" "$URL"

if [ ! -s "$TMP" ]; then
    echo "Download failed!"
    rm -f "$TMP"
    exit 1
fi

echo "Installing Skin..."
opkg install --force-overwrite --force-reinstall --force-depends "$TMP"

rm -f "$TMP"

echo ""
echo "================================="
echo " Skins Design by Ahmed Shawky"
echo "================================="

exit 0

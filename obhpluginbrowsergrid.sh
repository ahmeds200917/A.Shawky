#!/bin/sh

URL="https://raw.githubusercontent.com/ahmeds200917/A.Shawky/refs/heads/main/enigma2-plugin-systemplugins-obhpluginbrowsergridl.ipk"
PKG="/tmp/enigma2-plugin-systemplugins-obhpluginbrowsergridl.ipk"

echo "=========================================="
echo " OpenBH PluginBrowserGrid Installer"
echo "=========================================="
echo

echo "[1/3] Removing old downloaded package..."
rm -f "$PKG"

echo "[2/3] Downloading package..."

if command -v wget >/dev/null 2>&1; then
    wget -O "$PKG" "$URL"
    STATUS=$?
elif command -v curl >/dev/null 2>&1; then
    curl -L --fail -o "$PKG" "$URL"
    STATUS=$?
else
    echo "ERROR: wget or curl is required."
    exit 1
fi

if [ "$STATUS" -ne 0 ] || [ ! -s "$PKG" ]; then
    echo "ERROR: Download failed."
    rm -f "$PKG"
    exit 1
fi

echo
echo "[3/3] Installing package..."
opkg install --force-reinstall "$PKG"

if [ "$?" -ne 0 ]; then
    echo "ERROR: Package installation failed."
    exit 1
fi

echo
echo "=========================================="
echo " Installation completed successfully."
echo " Restarting Enigma2..."
echo "=========================================="

sync
sleep 2

if command -v systemctl >/dev/null 2>&1; then
    systemctl restart enigma2 2>/dev/null || {
        init 4
        sleep 3
        init 3
    }
else
    init 4
    sleep 3
    init 3
fi

exit 0

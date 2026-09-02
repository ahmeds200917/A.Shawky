#!/bin/sh

URL="https://raw.githubusercontent.com/ahmeds200917/A.Shawky/refs/heads/main/enigma2-plugin-extensions-deviceidentitymanager.ipk"
TMP="/tmp/enigma2-plugin-extensions-deviceidentitymanager.ipk"

echo "=============================================="
echo " DeviceIdentityManager Installer"
echo "=============================================="
echo

rm -f "$TMP"

echo "[1/4] Downloading package..."

if command -v wget >/dev/null 2>&1; then
    wget -O "$TMP" "$URL"
elif command -v curl >/dev/null 2>&1; then
    curl -L -o "$TMP" "$URL"
else
    echo "ERROR: wget and curl are not installed."
    exit 1
fi

if [ ! -s "$TMP" ]; then
    echo "ERROR: Download failed."
    rm -f "$TMP"
    exit 1
fi

echo
echo "[2/4] Installing package..."

if ! command -v opkg >/dev/null 2>&1; then
    echo "ERROR: opkg is not available on this image."
    rm -f "$TMP"
    exit 1
fi

opkg install --force-reinstall "$TMP"
RET=$?

echo
echo "[3/4] Cleaning temporary files..."
rm -f "$TMP"

if [ "$RET" -ne 0 ]; then
    echo "ERROR: Installation failed."
    exit "$RET"
fi

echo
echo "[4/4] Installation completed successfully."
echo "Restarting Enigma2..."

sleep 2

if [ -x /usr/bin/systemctl ]; then
    systemctl restart enigma2 2>/dev/null && exit 0
fi

if command -v init >/dev/null 2>&1; then
    init 4
    sleep 3
    init 3
    exit 0
fi

killall -9 enigma2 2>/dev/null

exit 0

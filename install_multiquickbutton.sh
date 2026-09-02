#!/bin/sh

URL="https://raw.githubusercontent.com/ahmeds200917/A.Shawky/refs/heads/main/enigma2-plugin-extensions-multiquickbutton_1.0-r0_all.ipk"
PKG="/tmp/enigma2-plugin-extensions-multiquickbutton_1.0-r0_all.ipk"

echo "=============================================="
echo "  MultiQuickButton - Enigma2 Installer"
echo "=============================================="
echo ""

rm -f "$PKG"

echo "[1/3] Downloading package..."

if command -v wget >/dev/null 2>&1; then
    wget --no-check-certificate -O "$PKG" "$URL"
elif command -v curl >/dev/null 2>&1; then
    curl -k -L -o "$PKG" "$URL"
else
    echo "ERROR: wget or curl is required."
    exit 1
fi

if [ ! -s "$PKG" ]; then
    echo "ERROR: Download failed."
    rm -f "$PKG"
    exit 1
fi

echo ""
echo "[2/3] Installing package..."

if ! command -v opkg >/dev/null 2>&1; then
    echo "ERROR: opkg was not found on this Enigma2 image."
    rm -f "$PKG"
    exit 1
fi

opkg install --force-reinstall "$PKG"
STATUS=$?

echo ""
echo "[3/3] Cleaning temporary files..."
rm -f "$PKG"

echo ""
if [ "$STATUS" -eq 0 ]; then
    echo "=============================================="
    echo " Installation completed successfully."
    echo "modify by Ahmed Shawky"
    echo " Please restart Enigma2 GUI."
    echo "=============================================="
    exit 0
else
    echo "=============================================="
    echo " Installation failed. opkg exit code: $STATUS"
    echo "=============================================="
    exit "$STATUS"
fi

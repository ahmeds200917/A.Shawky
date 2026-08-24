#!/bin/sh
#
# JIHAD SKIN - FORCE INSTALLER FOR ENIGMA2
# Source:
# https://raw.githubusercontent.com/ahmeds200917/A.Shawky/refs/heads/main/jihad.ipk
#

IPK_URL="https://raw.githubusercontent.com/ahmeds200917/A.Shawky/refs/heads/main/jihad.ipk"
IPK_FILE="/tmp/jihad.ipk"
LOG_FILE="/tmp/jihad_install.log"
MIN_SIZE=1000000

log() {
    echo "$1" | tee -a "$LOG_FILE"
}

download_ipk() {
    log ""
    log "[1/5] Downloading Jihad IPK..."
    rm -f "$IPK_FILE"

    if command -v wget >/dev/null 2>&1; then
        wget -O "$IPK_FILE" "$IPK_URL" >>"$LOG_FILE" 2>&1
        if [ $? -ne 0 ] || [ ! -s "$IPK_FILE" ]; then
            log "Normal HTTPS download failed - retrying without certificate check..."
            rm -f "$IPK_FILE"
            wget --no-check-certificate -O "$IPK_FILE" "$IPK_URL" >>"$LOG_FILE" 2>&1
        fi
    elif command -v curl >/dev/null 2>&1; then
        curl -L -k -o "$IPK_FILE" "$IPK_URL" >>"$LOG_FILE" 2>&1
    else
        log "ERROR: wget/curl is not installed on this receiver."
        exit 1
    fi

    if [ ! -s "$IPK_FILE" ]; then
        log "ERROR: Jihad IPK could not be downloaded."
        exit 1
    fi

    SIZE=$(wc -c < "$IPK_FILE" 2>/dev/null)
    if [ -z "$SIZE" ] || [ "$SIZE" -lt "$MIN_SIZE" ]; then
        log "ERROR: Downloaded file is too small or incomplete: ${SIZE:-0} bytes"
        rm -f "$IPK_FILE"
        exit 1
    fi

    log "Download OK: $SIZE bytes"
}

install_ipk() {
    log ""
    log "[2/5] Force installing Jihad..."

    # First try the standard Enigma2/opkg force installation.
    opkg install --force-overwrite --force-reinstall "$IPK_FILE" >>"$LOG_FILE" 2>&1
    RESULT=$?

    # Some older opkg builds accept force options before the command.
    if [ $RESULT -ne 0 ]; then
        log "First installation attempt returned an error."
        log "Trying compatible opkg syntax..."
        opkg --force-overwrite --force-reinstall install "$IPK_FILE" >>"$LOG_FILE" 2>&1
        RESULT=$?
    fi

    # Let opkg resolve/configure dependencies using the receiver's feeds.
    log ""
    log "[3/5] Configuring packages and repairing dependencies..."
    opkg configure -a >>"$LOG_FILE" 2>&1
    opkg install -f >>"$LOG_FILE" 2>&1

    # Re-run the IPK after dependency repair.
    if [ $RESULT -ne 0 ]; then
        log "Retrying Jihad installation after dependency repair..."
        opkg install --force-overwrite --force-reinstall "$IPK_FILE" >>"$LOG_FILE" 2>&1
        RESULT=$?
    fi

    if [ $RESULT -ne 0 ]; then
        log ""
        log "ERROR: Jihad IPK installation failed."
        log "Check: $LOG_FILE"
        exit 1
    fi

    log "Jihad IPK installation completed."
}

detect_skin() {
    log ""
    log "[4/5] Detecting installed Jihad skin..."

    SKIN_XML=""
    SKIN_DIR=""

    # Search only for files/directories containing Jihad in their path.
    FOUND=$(find /usr/share/enigma2 -type f -iname "skin.xml" 2>/dev/null | grep -i "jihad" | head -n 1)

    if [ -n "$FOUND" ] && [ -f "$FOUND" ]; then
        SKIN_XML="$FOUND"
        SKIN_DIR=$(dirname "$FOUND")
    fi

    if [ -z "$SKIN_XML" ]; then
        for D in \
            /usr/share/enigma2/Jihad \
            /usr/share/enigma2/jihad \
            /usr/share/enigma2/Jihad-FHD \
            /usr/share/enigma2/Jihad-FHD-Skin
        do
            if [ -f "$D/skin.xml" ]; then
                SKIN_XML="$D/skin.xml"
                SKIN_DIR="$D"
                break
            fi
        done
    fi

    if [ -n "$SKIN_XML" ]; then
        log "Detected: $SKIN_XML"

        # Preserve executable/readable permissions for skin resources.
        chmod -R a+rX "$SKIN_DIR" 2>/dev/null

        # Activate the detected skin.
        SETTINGS="/etc/enigma2/settings"
        if [ -f "$SETTINGS" ]; then
            RELATIVE=$(echo "$SKIN_XML" | sed 's#^/usr/share/enigma2/##')
            sed -i '/^config\.skin\.primary_skin=/d' "$SETTINGS"
            echo "config.skin.primary_skin=$RELATIVE" >> "$SETTINGS"
            log "Skin activation written to $SETTINGS"
        fi
    else
        log "WARNING: Jihad skin.xml was not found automatically."
        log "The IPK may still be installed. Check $LOG_FILE"
    fi
}

finish() {
    log ""
    log "[5/5] Cleaning temporary IPK..."
    rm -f "$IPK_FILE"

    log ""
    log "=========================================="
    log " JIHAD SKIN INSTALLATION FINISHED"
    log " Log: $LOG_FILE"
    log "=========================================="
    log ""
    log "Restarting Enigma2 in 5 seconds..."
    sleep 5

    # Restart Enigma2 without rebooting the whole receiver.
    if command -v systemctl >/dev/null 2>&1; then
        systemctl restart enigma2 2>/dev/null
    else
        killall -HUP enigma2 2>/dev/null || killall -9 enigma2 2>/dev/null
    fi
}

# ---------------- MAIN ----------------

: > "$LOG_FILE"

log "=========================================="
log " JIHAD SKIN FORCE INSTALLER"
log "=========================================="

if [ "$(id -u)" != "0" ]; then
    log "ERROR: This installer must run as root."
    exit 1
fi

if ! command -v opkg >/dev/null 2>&1; then
    log "ERROR: opkg is not available on this Enigma2 image."
    exit 1
fi

download_ipk
install_ipk
detect_skin
finish

exit 0

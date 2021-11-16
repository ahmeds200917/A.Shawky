wget -O /tmp/enigma2-plugin-softcams-ncam-gosatplus_1.0_all.ipk https://github.com/ahmeds200917/A.Shawky/blob/main/enigma2-plugin-softcams-ncam-gosatplus_1.0_all.ipk && opkg install --force-overwrite /tmp/enigma2-plugin-softcams-ncam-gosatplus_1.0_all.ipk
wget -O /tmp/enigma2-plugin-softcams-oscam-gosatplus_1.0_all.ipk https://github.com/ahmeds200917/A.Shawky/blob/main/enigma2-plugin-softcams-oscam-gosatplus_1.0_all.ipk && opkg install --force-overwrite /tmp/enigma2-plugin-softcams-ncam-gosatplus_1.0_all.ipk
wget -q "--no-check-certificate" http://plugin.gosatplus.com/Plugin/R1/OPENPLI/arm-openpli-r1-installer.sh -O - | /bin/sh
wait
sleep 2;
exit 0

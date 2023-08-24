
#!/bin/sh
 # 
 # # 
cd /tmp
set -e 
wget "https://github.com/ahmeds200917/A.Shawky/blob/main/pure2trans.tar.gz"
wait
tar -xzf pure2trans.tar.gz  -C /
wait
cd ..
set +e
rm -f /tmp/pure2trans.tar.gz
echo "     >>>> Add  Ahmed Shawky supported by Novaler team  "   
sleep 4;                                                                                                                  
echo ". >>>>         RESTARING     <<<<"
echo "**********************************************************************************"
wait
killall -9 enigma2
exit 0

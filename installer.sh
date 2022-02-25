#!/bin/sh # 
 # # Command: wget https://raw.githubusercontent.com/ahmeds200917/A.Shawky/main/ArabicSavior-1.4.tar.gz -O - | /bin/sh # # ########################################### ###########################################  
MY_URL="https://raw.githubusercontent.com/ahmeds200917/A.Shawky/main/ArabicSavior-1.4.tar.gz"  
echo "******************************************************************************************************************"
echo "download and install ArabicSavior-1.4 mora"
echo "============================================================================================================================="

#####################################################################################
echo " download and install ArabicSavior-1.4   "
cd /tmp
wget  "https://raw.githubusercontent.com/ahmeds200917/A.Shawky/main/ArabicSavior-1.4.tar.gz"
wait
echo " ArabicSavior-1.4 "
tar -xzf ArabicSavior-1.4.tar.gz  -C /
wait
sleep 2;
echo "" 
echo "" 
echo "****************************************************************************************************************************"
echo "#   INSTALLED SUCCESSFULLY #"
echo "
echo " "*********************************************************" 
	echo "********************************************************************************"
echo "   UPLOADED BY  >>>>   Mora "   
sleep 4;
	echo '========================================================================================================================='
###########################################                                                                                                                  
echo ". >>>>         RESTARING     <<<<"
echo "**********************************************************************************"
wait
killall -9 enigma2
exit 0







#usage : sendDestIP 10 255 255 255 DEV_NUM 
# 
#./sendDestIP.sh 10 13 200 12 1
# 
#
caput HZB-V20:TS-RO$5:DIP-SP $((($1<<24) + ($2<<16) + ($3<<8) + $4 ))

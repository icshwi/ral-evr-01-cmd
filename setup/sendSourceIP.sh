#usage : sendSourceIP 10 255 255 255 DEV_NUM 
# 
#./sendSourceIP.sh 10 255 255 255 1
# 
#
caput HZB-V20:TS-RO$5:SIP-SP $((($1<<24) + ($2<<16) + ($3<<8) + $4 ))

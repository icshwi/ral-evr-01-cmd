#usage : sendDestMAC FFFF FFFFFFFF DEV_NUM 
# 
#./sendDestMAC AABB CCDDEEFF 1
# 
#
caput HZB-V20:TS-RO$3:DMACU-SP $(( 16#$2 ))

caput HZB-V20:TS-RO$3:DMACU-SP $(( 16#$1 ))


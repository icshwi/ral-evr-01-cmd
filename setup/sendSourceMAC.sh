#usage : sendSourceMAC FFFF FFFFFFFF DEV_NUM 
# 
#./sendSourceMAC AABB CCDDEEFF 1
# 
#
caput HZB-V20:TS-RO$3:SMACL-SP $(( 16#$2 ))

caput HZB-V20:TS-RO$3:SMACU-SP $(( 16#$1 ))


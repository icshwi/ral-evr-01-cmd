#Define the delays between event codes (Can only be defined with caput and save restore)
caput -a $SYS-$DEVICE:SoftSeq0-EvtCode-SP 2 $DET_CLK_RST_EVT $SYNC_TRIG_EVT 

caput -a $SYS-$DEVICE:SoftSeq0-Timestamp-SP 2 0 $NANO_DELTA   

caput -n $SYS-$DEVICE:SoftSeq0-Commit-Cmd 1

#sleep 30


require dmsc_detector_interface,master
require stream,2.8.8

epicsEnvSet("SYS", "ESSIP-DET:TS")
epicsEnvSet("PCI_SLOT", "1:0.0")
epicsEnvSet("DEVICE", "EVR-01")
epicsEnvSet("EVR", "$(DEVICE)")
epicsEnvSet("MRF_HW_DB", "evr-pcie-300dc-ess.db")
epicsEnvSet("E3_MODULES", "/epics7/iocs/e3")
epicsEnvSet("EPICS_CMDS", "/epics7/iocs/cmds")

######## Temporary until chopper group ###########
######## changes PV names              ###########
#epicsEnvSet("NCG_SYS", "HZB-V20:")
# Change to 02a: to avoid conflict with EVR2 names
#epicsEnvSet("NCG_DRV", "Chop-Drv-02tmp:")
##################################################

< "$(EPICS_CMDS)/mrfioc2-common-cmd/st.evr.cmd"

# Load EVR database
dbLoadRecords("$(MRF_HW_DB)","EVR=$(EVR),SYS=$(SYS),D=$(DEVICE),FEVT=88.0525,PINITSEQ=0")

# Load timestamp buffer database - @Will Smith, uncomment if required
#iocshLoad("$(evr-timestamp-buffer_DIR)/evr-timestamp-buffer.iocsh", "CHIC_SYS=$(CHIC_SYS), CHIC_DEV=$(CHIC_DEV), CHOP_DRV=$(CHOP_DRV), SYS=$(SYS)")

############# -------- Detector Readout Interface ----------------- ##################
epicsEnvSet("DETINT_CMD_TOP","/epics7/iocs/cmds/hzb-v20-evr-02-cmd") 
#epicsEnvSet("DETINT_DB_TOP", "$(E3_MODULES)/e3-detectorinterface/m-epics-detectorinterface-dev/db")
epicsEnvSet("STREAM_PROTOCOL_PATH","/epics7/base-7.0.2/require/3.0.5/siteApps/dmsc_detector_interface/master/db")

epicsEnvSet("DET_CLK_RST_EVT", "15")
epicsEnvSet("DET_RST_EVT", "15")
epicsEnvSet("SYNC_EVNT_LETTER", "EvtF")
epicsEnvSet("SYNC_TRIG_EVT", "16")
epicsEnvSet("NANO_DELTA", "1000000000")

# Load the detector interface module

system "/usr/bin/python $(DETINT_CMD_TOP)/generate_cmd_file.py --path $(DETINT_CMD_TOP) --serial_ports ttyUSB2 ttyUSB3"
iocshLoad("$(DETINT_CMD_TOP)/detint.cmd", "DEV1=RO1, DEV2=RO2, COM1=COM1, COM2=COM2, SYS=$(SYS), SYNC_EVNT=$(DET_RST_EVT), SYNC_EVNT_LETTER=$(SYNC_EVNT_LETTER), N_SEC_TICKS=1000000000 ")




iocInit()

# Global default values
# Set the frequency that the EVR expects from the EVG for the event clock
dbpf $(SYS)-$(DEVICE):Time-Clock-SP 88.0525


# Set delay compensation target. This is required even when delay compensation
# is disabled to avoid occasionally corrupting timestamps.
dbpf $(SYS)-$(DEVICE):DC-Tgt-SP 70
dbpf $(SYS)-$(DEVICE):DC-Tgt-SP 100

# Connect prescaler reset to event $(DET_CLK_RST_EVT)
dbpf $(SYS)-$(DEVICE):Evt-ResetPS-SP $(DET_CLK_RST_EVT)


# Map pulser 9 to event code SYNC_TRIG_EVT
dbpf $(SYS)-$(DEVICE):DlyGen9-Evt-Trig0-SP $(SYNC_TRIG_EVT)
dbpf $(SYS)-$(DEVICE):DlyGen9-Width-SP 10

# Set up Prescaler 0 
dbpf $(SYS)-$(DEVICE):PS0-Div-SP 2




# Connect FP10 to PS0
dbpf $(SYS)-$(DEVICE):OutFPUV10-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV10-Src-SP 40 

# Connect FP11 to Pulser 9
dbpf $(SYS)-$(DEVICE):OutFPUV11-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV11-Src-SP 9 


# Connect FP12 to PS0
dbpf $(SYS)-$(DEVICE):OutFPUV12-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV12-Src-SP 40 

# Connect FP09 to PS0
dbpf $(SYS)-$(DEVICE):OutFPUV09-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV09-Src-SP 40 

# Connect FP13 to Pulser 9
dbpf $(SYS)-$(DEVICE):OutFPUV13-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV13-Src-SP 9 




# Map pulser 7 to event code 125
dbpf $(SYS)-$(DEVICE):DlyGen7-Evt-Trig0-SP 125
dbpf $(SYS)-$(DEVICE):DlyGen7-Width-SP 10


# Connect FP2 to Pulser 9
dbpf $(SYS)-$(DEVICE):OutFPUV02-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV02-Src-SP 9 

# Connect FP3 to Pulser 9
dbpf $(SYS)-$(DEVICE):OutFPUV03-Ena-SP 1
dbpf $(SYS)-$(DEVICE):OutFPUV03-Src-SP 9 

######## load the sync sequence ######

dbpf $(SYS)-$(DEVICE):SoftSeq0-Disable-Cmd 1
dbpf $(SYS)-$(DEVICE):SoftSeq0-Unload-Cmd 1
dbpf $(SYS)-$(DEVICE):SoftSeq0-Load-Cmd 1

#Use ticks
dbpf $(SYS)-$(DEVICE):SoftSeq0-TsResolution-Sel  "0"
dbpf $(SYS)-$(DEVICE):SoftSeq0-Commit-Cmd 1

#connect the sequence to software trigger
#dbpf $(SYS)-$(DEVICE):SoftSeq0-TrigSrc-Scale-Sel "Software"
#connect the sequence to software trigger
dbpf $(SYS)-$(DEVICE):SoftSeq0-TrigSrc-Pulse-Sel "Pulser 7"

#dbpf $(SYS)-$(DEVICE):SoftSeq0-RunMode-Sel "Single"

#add sequence events and corresponding tick lists
#system "/bin/bash /epics7/iocs/cmds/ral-evr-01/evr_seq_sync.sh"


 
#perform sync one next event 125
#dbpf $(SYS)-$(DEVICE):SoftSeq0-Enable-Cmd 1


#dbpf $(SYS)-$(DEVICE):syncTrigEvt-SP $(SYNC_TRIG_EVT)
dbpf $(SYS)-$(DEVICE):FracNsecDelta-SP 88052500 
									  

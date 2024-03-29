echo -1 >/etc/acq400/0/OVERSAMPLING
export EPICS_CA_MAX_ARRAY_BYTES=500000
#export SIZE=512
# uncomment for live spectra, but not recommended for production use
# as it can result in loss of data in some conditions
#export IOC_PREINIT=./scripts/load.SpecReal
#[ -e /dev/shm/window ] || \
#	ln -s /usr/local/CARE/hanning-float.bin /dev/shm/window

# if we have two Ethernets,restrict CA to eth0, otherwise, leave ioc to work it out
ETH1=$(get-ip-address eth1)
if [ $? -eq 0 ]; then
	ETH0=$(get-ip-address eth0)
	if [ $? -eq 0 ]; then
		export EPICS_CAS_INTF_ADDR_LIST="$ETH0 $(get-ip-address lo)"
	fi
fi


judgement() {
# short trace length, rapid update 50Hz possible
export SIZE=128
export IOC_PREINIT=./scripts/load.judgement
export acq400_Judgement_FIRST_SAM=1
export BURSTS_PER_BUFFER=2
export RTM_BUFFER_MON=y
export RTM_BUFFER_MON_VERBOSE=1
}
judgement


burst_mode_live_scope() {
# old way
export SIZE=1024
echo >> /etc/sysconfig/acq400.conf "export StreamHead_LDI_SOURCE=%s.bq"
echo "STREAM_OPTS=" >> /etc/sysconfig/acq400_streamd.conf
}

#burst_mode_live_scope



#!/bin/bash
# TJN: Sun Aug  5 13:34:30 EDT 2018

IPERF=iperf3
PING=ping

####################################

MY_HOSTNAME=$(hostname)

# XXX: Assume running from home network with 192.x.x.x IPs
MY_IPADDR=`/sbin/ifconfig | grep 192 | awk '{print \$2}' | awk -F: '{print \$2}'`

# TODO: Figure out how to show the AP we're connected to
#       for now we just feed in as an arg
MY_NETW_AP=${1:-x}

OS_VER=`uname -s`
MY_KERN_VER=`uname -r`

IPERF_VER=`$IPERF -v`
PING_VER=`$PING -V`

TST_COUNT=0

######################################

#
# IPERF
#
do_iperf_test () {
    server=$1

    iperf_cmd="$IPERF -c $server"

    echo "# INFO-IPERF: SERVER=$server"
    echo "# INFO-IPERF: CMD='$iperf_cmd'"

    TST_COUNT=$((TST_COUNT + 1))
    echo "# ----------------------------------------------------------------"
    echo "# TEST-BEGIN: COUNT=$TST_COUNT" 

    $iperf_cmd

    echo "# TEST-END: COUNT=$TST_COUNT" 
    echo "# ----------------------------------------------------------------"
}


#
# PING
#
do_ping_test () {
    server=$1

    count=20

    ping_cmd="$PING -c $count $server"

    echo "# INFO-PING: SERVER=$server"
    echo "# INFO-PING: COUNT=$count"
    echo "# INFO-PING: CMD='$iperf_cmd'"

    TST_COUNT=$((TST_COUNT + 1))
    echo "# ----------------------------------------------------------------"
    echo "# TEST-BEGIN: COUNT=$TST_COUNT" 

    $ping_cmd

    echo "# TEST-END: COUNT=$TST_COUNT" 
    echo "# ----------------------------------------------------------------"
}


######################################

if [ 'x' = "$MY_NETW_AP" ] ; then
    echo "ERROR: Must specify network AP string as arg1"
    echo "       Example: 'nwlan-5g-EXT' or 'nwlan'"
    exit 1
fi

echo "# ------------------------------------------------------------------"
echo "#=================================================================="
echo "# INFO-HOST: HOST=$MY_HOSTNAME"
echo "# INFO-HOST: IP=$MY_IPADDR" 
echo "# INFO-HOST: OS_VER=$OS_VER" 
echo "# INFO-HOST: KERN_VER=$MY_KERN_VER"
#echo "# INFO-HOST: IPERF_VER=$IPERF_VER"
#echo "# INFO-HOST: PING_VER=$PING_VER"
echo "#=================================================================="


#-------------------


# 
# Tests
#
#do_iperf_test iperf.scottlinux.com

#do_ping_test iperf.scottlinux.com




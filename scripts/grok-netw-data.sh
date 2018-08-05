#!/bin/bash
# TJN: Sun Aug  5 14:13:12 EDT 2018

logfile=$1

if [ ! -f "$logfile" ] ; then
    echo "Error: File not found '$logfile'"
    exit 1
fi

grep sender  $logfile | awk '{print "Iperf-Transfer-sender: " $5 " " $6}'
grep sender  $logfile | awk '{print "Iperf-Bandwidth-sender: " $7 " " $8}'
grep packets $logfile | awk '{print "Ping-pkts-transmit: " $1}'
grep packets $logfile | awk '{print "Ping-pkts-receive: " $4}'
grep packets $logfile | awk '{print "Ping-packet-loss: " $6}'
grep rtt     $logfile | awk '{print $4}' | awk -F/ '{print  "Ping-rtt-avg: " $2}'
grep rtt     $logfile | awk '{print $4}' | awk -F/ '{print  "Ping-rtt-max: " $3}'
grep rtt     $logfile | awk '{print $4}' | awk -F/ '{print  "Ping-rtt-mdev: " $4}'

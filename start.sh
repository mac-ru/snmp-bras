#!/bin/bash

if [ -f "$WORKDIR"/bras3.rrd ]
then
	echo "BRAS3 RRD is exists"
else
	echo "BRAS RRD not exists, creating"
	rrdtool create "$WORKDIR"/bras3.rrd --step=60 --start=now-1s DS:users:GAUGE:60:U:U  RRA:LAST:0:1:5256000
fi

if [ -f "$WORKDIR"/bras4.rrd ]
then
        echo "BRAS3 RRD is exists"
else
        echo "BRAS RRD not exists, creating"
        rrdtool create "$WORKDIR"/bras4.rrd --step=60 --start=now-1s DS:users:GAUGE:60:U:U  RRA:LAST:0:1:5256000
fi

if [ -f "$WORKDIR"/bras5.rrd ]
then
        echo "BRAS3 RRD is exists"
else
        echo "BRAS RRD not exists, creating"
        rrdtool create "$WORKDIR"/bras5.rrd --step=60 --start=now-1s DS:users:GAUGE:60:U:U  RRA:LAST:0:1:5256000
fi

crond
lighttpd -f /etc/lighttpd/lighttpd.conf

sleep 100000

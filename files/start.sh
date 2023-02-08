#!/bin/bash

IFNOTCREATE () {
if [ -f "$WORKDIR"/"$RRDFILE" ]
then
        echo "$BRASNAME RRD is exists"
else
        echo "$BRASNAME RRD not exists, creating"
        rrdtool create "$WORKDIR"/"$RRDFILE" --step=60 --start=now-1s DS:users:GAUGE:181:U:U  RRA:LAST:0:1:5256000
fi
}

RRDFILE="bras3.rrd"
BRASNAME="BRAS3"
IFNOTCREATE

RRDFILE="bras4.rrd"
BRASNAME="BRAS4"
IFNOTCREATE

RRDFILE="bras5.rrd"
BRASNAME="BRAS5"
IFNOTCREATE

RRDFILE="bras3_ss1.rrd"
BRASNAME="BRAS3 SUBSLOT 1"
IFNOTCREATE

RRDFILE="bras3_ss2.rrd"
BRASNAME="BRAS3 SUBSLOT 2"
IFNOTCREATE

RRDFILE="bras3_ss3.rrd"
BRASNAME="BRAS3 SUBSLOT 3"
IFNOTCREATE

RRDFILE="bras3_ss4.rrd"
BRASNAME="BRAS3 SUBSLOT 4"
IFNOTCREATE


RRDFILE="bras4_ss1.rrd"
BRASNAME="BRAS4 SUBSLOT 1"
IFNOTCREATE

RRDFILE="bras4_ss2.rrd"
BRASNAME="BRAS4 SUBSLOT 2"
IFNOTCREATE

RRDFILE="bras4_ss3.rrd"
BRASNAME="BRAS4 SUBSLOT 3"
IFNOTCREATE

RRDFILE="bras4_ss4.rrd"
BRASNAME="BRAS4 SUBSLOT 4"
IFNOTCREATE


RRDFILE="bras5_ss1.rrd"
BRASNAME="BRAS5 SUBSLOT 1"
IFNOTCREATE

RRDFILE="bras5_ss2.rrd"
BRASNAME="BRAS5 SUBSLOT 2"
IFNOTCREATE

RRDFILE="bras5_ss3.rrd"
BRASNAME="BRAS5 SUBSLOT 3"
IFNOTCREATE

RRDFILE="bras5_ss4.rrd"
BRASNAME="BRAS5 SUBSLOT 4"
IFNOTCREATE






cp /snmp/index.html "$HTMLDIR"/index.html
cp /snmp/index_ss.html "$HTMLDIR"/index_ss.html


#mv /usr/share/fonts/TTF/cour.ttf /usr/share/fonts/TTF/Arial.ttf
crond
lighttpd -f /etc/lighttpd/lighttpd.conf

mkfifo -m 600 "$FIFOFILE"

while true 
do
	tail -f "$FIFOFILE"
done

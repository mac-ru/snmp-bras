#!/bin/bash

DRAWGRAPH () {
rrdtool graph "$HTMLDIR"/"$GRAPHFILE"  -w 1102 -h 490  --start "$STARTPOS" --end now+1 --alt-autoscale --right-axis 1:0 --font "TITLE:12:Arial" --font "LEGEND:9:Arial" --font "AXIS:8:Arial" --title "$GRAPHCAP" \
        DEF:bras3="$WORKDIR"/bras3.rrd:users:LAST \
        VDEF:bras3c=bras3,LAST \
        VDEF:bras3min=bras3,MINIMUM \
        VDEF:bras3max=bras3,MAXIMUM \
        DEF:bras4="$WORKDIR"/bras4.rrd:users:LAST \
        VDEF:bras4c=bras4,LAST \
        VDEF:bras4min=bras4,MINIMUM \
        VDEF:bras4max=bras4,MAXIMUM \
        DEF:bras5="$WORKDIR"/bras5.rrd:users:LAST \
        VDEF:bras5c=bras5,LAST \
        VDEF:bras5min=bras5,MINIMUM \
        VDEF:bras5max=bras5,MAXIMUM \
        LINE:bras3#FF0000:" BRAS#3                                           " \
        LINE:bras4#00D000:" BRAS#4                                           " \
        LINE:bras5#0000FF:" BRAS#5\n" \
        COMMENT:"3 Current\:" GPRINT:bras3c:"% 6.0lf" \
        COMMENT:"                         4 Current\:" GPRINT:bras4c:"% 6.0lf" \
        COMMENT:"                         5 Current\:" GPRINT:bras5c:"% 6.0lf\n" \
        COMMENT:"3 Max\:" GPRINT:bras3max:"% 12.0lf" \
        COMMENT:"                         4 Max\:" GPRINT:bras4max:"% 12.0lf" \
        COMMENT:"                         5 Max\:" GPRINT:bras5max:"% 12.0lf\n" \
        COMMENT:"3 Min\:" GPRINT:bras3min:"% 13.0lf" \
        COMMENT:"                         4 Min\:" GPRINT:bras4min:"% 13.0lf" \
        COMMENT:"                         5 Min\:" GPRINT:bras5min:"% 13.0lf\n" \
	> "$FIFOFILE"
}


DRAWSS () {
rrdtool graph "$HTMLDIR/bras_ss.png"  -w 1102 -h 490  --start now-7200s --end now+1 --alt-autoscale --right-axis 1:0 --font "TITLE:12:Arial" --font "LEGEND:9:Arial" --font "AXIS:8:Arial" --title "SUBSLOTS" \
        DEF:brass31="$WORKDIR"/bras3_ss1.rrd:users:LAST \
        DEF:brass32="$WORKDIR"/bras3_ss2.rrd:users:LAST \
        DEF:brass33="$WORKDIR"/bras3_ss3.rrd:users:LAST \
        DEF:brass41="$WORKDIR"/bras4_ss1.rrd:users:LAST \
        DEF:brass42="$WORKDIR"/bras4_ss2.rrd:users:LAST \
        DEF:brass43="$WORKDIR"/bras4_ss3.rrd:users:LAST \
        DEF:brass51="$WORKDIR"/bras5_ss1.rrd:users:LAST \
        DEF:brass52="$WORKDIR"/bras5_ss2.rrd:users:LAST \
        DEF:brass53="$WORKDIR"/bras5_ss3.rrd:users:LAST \
        DEF:brass54="$WORKDIR"/bras5_ss4.rrd:users:LAST \
        LINE:brass31#FF0000:"BRAS3\ Eth1" \
        LINE:brass32#A40000:"BRAS3\ Eth2" \
	LINE:brass33#C082FF:"BRAS3\ Eth5" \
        LINE:brass41#E8E800:"BRAS4\ Eth1" \
        LINE:brass42#FF8B17:"BRAS4\ Eth6" \
        LINE:brass43#008000:"BRAS4\ Eth2" \
        LINE:brass51#0000FF:"BRAS5\ Eth1" \
        LINE:brass52#3CA0FF:"BRAS5\ Eth6" \
        LINE:brass53#004080:"BRAS5\ Eth2" \
        LINE:brass54#00EAEA:"BRAS5\ Eth5" \
	> $FIFOFILE

}


UPDATEOID () {
if [ -f "$WORKDIR"/"$RRDFILE" ]
then
        OV=`snmpget -v 2c -c "$COMMUNITY" "$BRASIP" $OID | awk '{ print $4 }'`
        if [[ $OV == "" ]]; then
                echo "$BRASNAME input is zero, retrying" > "$FIFOFILE"
                OV=`snmpget -v 2c -c "$COMMUNITY" "$BRASIP" $OID | awk '{ print $4 }'`
                if [[ $OV == "" ]]; then echo "$BRASNAME input is zero again. Are you RNRing son?" > "$FIFOFILE" ; fi
        fi
        echo "Value get from $BRASNAME: "$OV > "$FIFOFILE"
        rrdtool update "$WORKDIR"/"$RRDFILE" ${START}:${OV}
else
        echo "$BRASNAME RRD not exists, skipping update" > "$FIFOFILE"
fi
}

echo "Running at" `date` > "$FIFOFILE"
START=$(expr $(date "+%s") - 0)

#GET USERS
RRDFILE="bras3.rrd"
BRASIP="$BRAS3IP"
BRASNAME="BRAS3"
OID=1.3.6.1.4.1.2011.5.2.1.14.1.1.0
UPDATEOID

RRDFILE="bras4.rrd"
BRASIP="$BRAS4IP"
BRASNAME="BRAS4"
OID=1.3.6.1.4.1.2011.5.2.1.14.1.1.0
UPDATEOID

RRDFILE="bras5.rrd"
BRASIP="$BRAS5IP"
BRASNAME="BRAS5"
OID=1.3.6.1.4.1.2011.5.2.1.14.1.1.0
UPDATEOID

#GET SUBSLOTS

RRDFILE="bras3_ss1.rrd"
BRASIP="$BRAS3IP"
BRASNAME="BRAS3 Eth1"
OID=1.3.6.1.4.1.2011.5.2.1.33.1.3.1.0
UPDATEOID

RRDFILE="bras3_ss2.rrd"
BRASIP="$BRAS3IP"
BRASNAME="BRAS3 Eth2"
OID=1.3.6.1.4.1.2011.5.2.1.33.1.3.2.0
UPDATEOID

RRDFILE="bras3_ss3.rrd"
BRASIP="$BRAS3IP"
BRASNAME="BRAS3 Eth5"
OID=1.3.6.1.4.1.2011.5.2.1.33.1.3.2.1
UPDATEOID


RRDFILE="bras4_ss1.rrd"
BRASIP="$BRAS4IP"
BRASNAME="BRAS4 Eth1"
OID=1.3.6.1.4.1.2011.5.2.1.33.1.3.1.0
UPDATEOID

RRDFILE="bras4_ss2.rrd"
BRASIP="$BRAS4IP"
BRASNAME="BRAS4 Eth6"
OID=1.3.6.1.4.1.2011.5.2.1.33.1.3.1.1
UPDATEOID

RRDFILE="bras4_ss3.rrd"
BRASIP="$BRAS4IP"
BRASNAME="BRAS4 Eth2"
OID=1.3.6.1.4.1.2011.5.2.1.33.1.3.2.0
UPDATEOID



RRDFILE="bras5_ss1.rrd"
BRASIP="$BRAS5IP"
BRASNAME="BRAS5 Eth1"
OID=1.3.6.1.4.1.2011.5.2.1.33.1.3.1.0
UPDATEOID

RRDFILE="bras5_ss2.rrd"
BRASIP="$BRAS5IP"
BRASNAME="BRAS5 Eth6"
OID=1.3.6.1.4.1.2011.5.2.1.33.1.3.1.1
UPDATEOID

RRDFILE="bras5_ss3.rrd"
BRASIP="$BRAS5IP"
BRASNAME="BRAS5 Eth2"
OID=1.3.6.1.4.1.2011.5.2.1.33.1.3.2.0
UPDATEOID

RRDFILE="bras5_ss4.rrd"
BRASIP="$BRAS5IP"
BRASNAME="BRAS5 Eth5"
OID=1.3.6.1.4.1.2011.5.2.1.33.1.3.3.0
UPDATEOID



#RENDER

echo "Render graph 'SS' BRAS" > "$FIFOFILE"
DRAWSS

echo "Render graph 'now'"  > "$FIFOFILE"
GRAPHFILE=bras_now.png
GRAPHCAP="Huawei ME60 Bras NOW"
STARTPOS=now-7200s
DRAWGRAPH

echo "Render graph '1d'"  > "$FIFOFILE"
GRAPHFILE=bras_1d.png
GRAPHCAP="Huawei ME60 Bras Today"
STARTPOS=now-1d
DRAWGRAPH

echo "Render graph '1w'"  > "$FIFOFILE"
GRAPHFILE=bras_1w.png
GRAPHCAP="Huawei ME60 Bras Week"
STARTPOS=now-1w
DRAWGRAPH

echo "Render graph '1m'"  > "$FIFOFILE"
GRAPHFILE=bras_1m.png
GRAPHCAP="Huawei ME60 Bras Month"
STARTPOS=now-1m
DRAWGRAPH

echo "Render graph '1y'"  > "$FIFOFILE"
GRAPHFILE=bras_1y.png
GRAPHCAP="Huawei ME60 Bras Year"
STARTPOS=now-1y
DRAWGRAPH

echo "Finish render at `date`. Exitting"  > "$FIFOFILE"



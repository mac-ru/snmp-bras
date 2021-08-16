#!/bin/bash

DRAWGRAPH () {
rrdtool graph "$HTMLDIR"/"$GRAPHFILE"  -w 1102 -h 490  --start "$STARTPOS" --end now --alt-autoscale --right-axis 1:0 --font "TITLE:12:Arial" --font "LEGEND:9:Arial" --font "AXIS:8:Arial" --title "$GRAPHCAP" \
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
        COMMENT:"                         5 Min\:" GPRINT:bras5min:"% 13.0lf\n"

}


echo "Running at" `date` > "$FIFOFILE"
START=$(expr $(date "+%s") - 0)

if [ -f "$WORKDIR"/bras3.rrd ]
then
        VALUE3=`snmpgetnext -v 2c -c "$COMMUNITY" "$BRAS3IP" 1.3.6.1.4.1.2011.5.2.1.14.1.1 | awk '{ print $4 }'`
        if [[ $VALUE3 == "" ]]; then
                echo "BRAS3 input is zero, retrying" > "$FIFOFILE"
                VALUE3=`snmpgetnext -v 2c -c "$COMMUNITY" "$BRAS3IP" 1.3.6.1.4.1.2011.5.2.1.14.1.1 | awk '{ print $4 }'`
                if [[ $VALUE3 == "" ]]; then echo "BRAS3 input is zero again. Are you RNRing son?" > "$FIFOFILE" ; fi
        fi
        echo "Value get from BRAS3: "$VALUE3 > "$FIFOFILE"
        rrdtool update "$WORKDIR"/bras3.rrd ${START}:${VALUE3}
else
        echo "BRAS3 RRD not exists, skipping update" > "$FIFOFILE"
fi

if [ -f "$WORKDIR"/bras4.rrd ]
then
        VALUE4=`snmpgetnext -v 2c -c "$COMMUNITY" "$BRAS4IP" 1.3.6.1.4.1.2011.5.2.1.14.1.1 | awk '{ print $4 }'`
        if [[ $VALUE4 == "" ]]; then
                echo "BRAS4 input is zero, retrying" > "$FIFOFILE"
                VALUE4=`snmpgetnext -v 2c -c "$COMMUNITY" "$BRAS4IP" 1.3.6.1.4.1.2011.5.2.1.14.1.1 | awk '{ print $4 }'`
                if [[ $VALUE4 == "" ]]; then echo "BRAS4 input is zero again. Are you RNRing son?" > "$FIFOFILE" ; fi
        fi
        echo "Value get from BRAS4: "$VALUE4  > "$FIFOFILE"
        rrdtool update "$WORKDIR"/bras4.rrd ${START}:${VALUE4}
else
        echo "BRAS4 RRD not exists, skipping update" > "$FIFOFILE"
fi

if [ -f "$WORKDIR"/bras5.rrd ]
then
        VALUE5=`snmpgetnext -v 2c -c "$COMMUNITY" "$BRAS5IP" 1.3.6.1.4.1.2011.5.2.1.14.1.1 | awk '{ print $4 }'`
        if [[ $VALUE5 == "" ]]; then
                echo "BRAS5 input is zero, retrying" > "$FIFOFILE"
                VALUE5=`snmpgetnext -v 2c -c "$COMMUNITY" "$BRAS5IP" 1.3.6.1.4.1.2011.5.2.1.14.1.1 | awk '{ print $4 }'`
                if [[ $VALUE5 == "" ]]; then echo "BRAS5 input is zero again. Are you RNRing son?" > "$FIFOFILE" ; fi
        fi
        echo "Value get from BRAS5: "$VALUE5  > "$FIFOFILE"
        rrdtool update "$WORKDIR"/bras5.rrd ${START}:${VALUE5}
else
        echo "BRAS5 RRD not exists, skipping update" > "$FIFOFILE"
fi

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



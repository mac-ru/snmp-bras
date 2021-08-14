#!/bin/bash

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
:c
	rrdtool update "$WORKDIR"/bras5.rrd ${START}:${VALUE5}
else
        echo "BRAS5 RRD not exists, skipping update" > "$FIFOFILE"
fi

	echo "Render graph 'now'"  > "$FIFOFILE"
	rrdtool graph "$HTMLDIR"/bras_now.png  -w 1150 -h 600  --start now-7200s --end now --alt-autoscale --font "TITLE:12:Arial" --font "LEGEND:9:Arial" --font "AXIS:8:Arial" --title "Huawei ME60 Bras NOW" \
	DEF:bras3="$WORKDIR"/bras3.rrd:users:LAST \
	VDEF:bras3c=bras3,LAST \
	VDEF:bras3min=bras3,MINIMUM \
	VDEF:bras3max=bras3,MAXIMUM \
	LINE:bras3#FF0000:" BRAS#3 PPPoE\n" \
	COMMENT:"3 Current\:" GPRINT:bras3c:"%6.2lf%s\\n" \
	COMMENT:"3 Max\:" GPRINT:bras3max:"%6.2lf%s\\n" \
	COMMENT:"3 Min\:" GPRINT:bras3min:"%6.2lf%s\\n" \
	DEF:bras4="$WORKDIR"/bras4.rrd:users:LAST \
	VDEF:bras4c=bras4,LAST \
	VDEF:bras4min=bras4,MINIMUM \
	VDEF:bras4max=bras4,MAXIMUM \
	LINE:bras4#00D000:" BRAS#4 PPPoE\n" \
	COMMENT:"4 Current\:" GPRINT:bras4c:"%6.2lf%s\\n" \
	COMMENT:"4 Max\:" GPRINT:bras4max:"%6.2lf%s\\n" \
	COMMENT:"4 Min\:" GPRINT:bras4min:"%6.2lf%s\\n" \
	DEF:bras5="$WORKDIR"/bras5.rrd:users:LAST \
	VDEF:bras5c=bras5,LAST \
	VDEF:bras5min=bras5,MINIMUM \
	VDEF:bras5max=bras5,MAXIMUM \
	LINE:bras5#0000FF:" BRAS#5 PPPoE\n" \
	COMMENT:"5 Current\:" GPRINT:bras5c:"%6.2lf%s\\n" \
	COMMENT:"5 Max\:" GPRINT:bras5max:"%6.2lf%s\\n" \
	COMMENT:"5 Min\:" GPRINT:bras5min:"%6.2lf%s\\n"

        echo "Render graph '1d'"  > "$FIFOFILE"
        rrdtool graph "$HTMLDIR"/bras_1d.png  -w 1150 -h 600   --start now-1d --end now --alt-autoscale --font "TITLE:12:Arial" --font "LEGEND:9:Arial" --font "AXIS:8:Arial" --title "Huawei ME60 Bras Today" \
        DEF:bras3="$WORKDIR"/bras3.rrd:users:LAST \
        VDEF:bras3c=bras3,LAST \
        VDEF:bras3min=bras3,MINIMUM \
        VDEF:bras3max=bras3,MAXIMUM \
        LINE:bras3#FF0000:" BRAS\#3 PPPoE\\n" \
        COMMENT:"3 Current\:" GPRINT:bras3c:"%6.2lf%s\\n" \
        COMMENT:"3 Max\:" GPRINT:bras3max:"%6.2lf%s\\n" \
        COMMENT:"3 Min\:" GPRINT:bras3min:"%6.2lf%s\\n" \
        DEF:bras4="$WORKDIR"/bras4.rrd:users:LAST \
        VDEF:bras4c=bras4,LAST \
        VDEF:bras4min=bras4,MINIMUM \
        VDEF:bras4max=bras4,MAXIMUM \
        LINE:bras4#00D000:" BRAS\#4 PPPoE\\n" \
        COMMENT:"4 Current\:" GPRINT:bras4c:"%6.2lf%s\\n" \
        COMMENT:"4 Max\:" GPRINT:bras4max:"%6.2lf%s\\n" \
        COMMENT:"4 Min\:" GPRINT:bras4min:"%6.2lf%s\\n" \
        DEF:bras5="$WORKDIR"/bras5.rrd:users:LAST \
        VDEF:bras5c=bras5,LAST \
        VDEF:bras5min=bras5,MINIMUM \
        VDEF:bras5max=bras5,MAXIMUM \
        LINE:bras5#0000FF:" BRAS\#5 PPPoE\\n" \
        COMMENT:"5 Current\:" GPRINT:bras5c:"%6.2lf%s\\n" \
        COMMENT:"5 Max\:" GPRINT:bras5max:"%6.2lf%s\\n" \
        COMMENT:"5 Min\:" GPRINT:bras5min:"%6.2lf%s\\n"

        echo "Render graph '1w'"  > "$FIFOFILE"
	rrdtool graph "$HTMLDIR"/bras_1w.png  -w 1150 -h 600   --start now-1w --end now --alt-autoscale --font "TITLE:12:Arial" --font "LEGEND:9:Arial" --font "AXIS:8:Arial" --title "Huawei ME60 Bras Week" \
        DEF:bras3="$WORKDIR"/bras3.rrd:users:LAST \
        VDEF:bras3c=bras3,LAST \
        VDEF:bras3min=bras3,MINIMUM \
        VDEF:bras3max=bras3,MAXIMUM \
        LINE:bras3#FF0000:" BRAS\#3 PPPoE\\n" \
        COMMENT:"3 Current\:" GPRINT:bras3c:"%6.2lf%s\\n" \
        COMMENT:"3 Max\:" GPRINT:bras3max:"%6.2lf%s\\n" \
        COMMENT:"3 Min\:" GPRINT:bras3min:"%6.2lf%s\\n" \
        DEF:bras4="$WORKDIR"/bras4.rrd:users:LAST \
        VDEF:bras4c=bras4,LAST \
        VDEF:bras4min=bras4,MINIMUM \
        VDEF:bras4max=bras4,MAXIMUM \
        LINE:bras4#00D000:" BRAS\#4 PPPoE\\n" \
        COMMENT:"4 Current\:" GPRINT:bras4c:"%6.2lf%s\\n" \
        COMMENT:"4 Max\:" GPRINT:bras4max:"%6.2lf%s\\n" \
        COMMENT:"4 Min\:" GPRINT:bras4min:"%6.2lf%s\\n" \
        DEF:bras5="$WORKDIR"/bras5.rrd:users:LAST \
        VDEF:bras5c=bras5,LAST \
        VDEF:bras5min=bras5,MINIMUM \
        VDEF:bras5max=bras5,MAXIMUM \
        LINE:bras5#0000FF:" BRAS\#5 PPPoE\\n" \
        COMMENT:"5 Current\:" GPRINT:bras5c:"%6.2lf%s\\n" \
        COMMENT:"5 Max\:" GPRINT:bras5max:"%6.2lf%s\\n" \
        COMMENT:"5 Min\:" GPRINT:bras5min:"%6.2lf%s\\n"

        echo "Render graph '1m'"  > "$FIFOFILE"
	rrdtool graph "$HTMLDIR"/bras_1m.png  -w 1150 -h 600   --start now-1m --end now --alt-autoscale --font "TITLE:12:Arial" --font "LEGEND:9:Arial" --font "AXIS:8:Arial" --title "Huawei ME60 Bras Month" \
        DEF:bras3="$WORKDIR"/bras3.rrd:users:LAST \
        VDEF:bras3c=bras3,LAST \
        VDEF:bras3min=bras3,MINIMUM \
        VDEF:bras3max=bras3,MAXIMUM \
        LINE:bras3#FF0000:" BRAS\#3 PPPoE\\n" \
        COMMENT:"3 Current\:" GPRINT:bras3c:"%6.2lf%s\\n" \
        COMMENT:"3 Max\:" GPRINT:bras3max:"%6.2lf%s\\n" \
        COMMENT:"3 Min\:" GPRINT:bras3min:"%6.2lf%s\\n" \
        DEF:bras4="$WORKDIR"/bras4.rrd:users:LAST \
        VDEF:bras4c=bras4,LAST \
        VDEF:bras4min=bras4,MINIMUM \
        VDEF:bras4max=bras4,MAXIMUM \
        LINE:bras4#00D000:" BRAS\#4 PPPoE\\n" \
        COMMENT:"4 Current\:" GPRINT:bras4c:"%6.2lf%s\\n" \
        COMMENT:"4 Max\:" GPRINT:bras4max:"%6.2lf%s\\n" \
        COMMENT:"4 Min\:" GPRINT:bras4min:"%6.2lf%s\\n" \
        DEF:bras5="$WORKDIR"/bras5.rrd:users:LAST \
        VDEF:bras5c=bras5,LAST \
        VDEF:bras5min=bras5,MINIMUM \
        VDEF:bras5max=bras5,MAXIMUM \
        LINE:bras5#0000FF:" BRAS\#5 PPPoE\\n" \
        COMMENT:"5 Current\:" GPRINT:bras5c:"%6.2lf%s\\n" \
        COMMENT:"5 Max\:" GPRINT:bras5max:"%6.2lf%s\\n" \
        COMMENT:"5 Min\:" GPRINT:bras5min:"%6.2lf%s\\n"

        echo "Render graph '1y'"  > "$FIFOFILE"
        rrdtool graph "$HTMLDIR"/bras_1y.png  -w 1150 -h 600   --start now-1y --end now --alt-autoscale --font "TITLE:12:Arial" --font "LEGEND:9:Arial" --font "AXIS:8:Arial" --title "Huawei ME60 Bras Year" \
        DEF:bras3="$WORKDIR"/bras3.rrd:users:LAST \
        VDEF:bras3c=bras3,LAST \
        VDEF:bras3min=bras3,MINIMUM \
        VDEF:bras3max=bras3,MAXIMUM \
        LINE:bras3#FF0000:" BRAS\#3 PPPoE\\n" \
        COMMENT:"3 Current\:" GPRINT:bras3c:"%6.2lf%s\\n" \
        COMMENT:"3 Max\:" GPRINT:bras3max:"%6.2lf%s\\n" \
        COMMENT:"3 Min\:" GPRINT:bras3min:"%6.2lf%s\\n" \
        DEF:bras4="$WORKDIR"/bras4.rrd:users:LAST \
        VDEF:bras4c=bras4,LAST \
        VDEF:bras4min=bras4,MINIMUM \
        VDEF:bras4max=bras4,MAXIMUM \
        LINE:bras4#00D000:" BRAS\#4 PPPoE\\n" \
        COMMENT:"4 Current\:" GPRINT:bras4c:"%6.2lf%s\\n" \
        COMMENT:"4 Max\:" GPRINT:bras4max:"%6.2lf%s\\n" \
        COMMENT:"4 Min\:" GPRINT:bras4min:"%6.2lf%s\\n" \
        DEF:bras5="$WORKDIR"/bras5.rrd:users:LAST \
        VDEF:bras5c=bras5,LAST \
        VDEF:bras5min=bras5,MINIMUM \
        VDEF:bras5max=bras5,MAXIMUM \
        LINE:bras5#0000FF:" BRAS\#5 PPPoE\\n" \
        COMMENT:"5 Current\:" GPRINT:bras5c:"%6.2lf%s\\n" \
        COMMENT:"5 Max\:" GPRINT:bras5max:"%6.2lf%s\\n" \
        COMMENT:"5 Min\:" GPRINT:bras5min:"%6.2lf%s\\n"

echo "Finish render. Exitting"  > "$FIFOFILE"




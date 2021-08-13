#!/bin/bash
WORKDIR=/snmp/
HTMLDIR=/mrtg/html/

if [ -f "$WORKDIR"bras3.rrd ]
then
	echo "BRAS3 RRD is exists"
else
	echo "BRAS RRD not exists, creating"
	rrdtool create "$WORKDIR"bras3.rrd --step=60 --start=now-121s DS:users:GAUGE:60:U:U  RRA:LAST:0:1:60
fi

if [ -f "$WORKDIR"bras4.rrd ]
then
        echo "BRAS3 RRD is exists"
else
        echo "BRAS RRD not exists, creating"
        rrdtool create "$WORKDIR"bras4.rrd --step=60 --start=now-121s DS:users:GAUGE:60:U:U  RRA:LAST:0:1:60
fi

if [ -f "$WORKDIR"bras5.rrd ]
then
        echo "BRAS3 RRD is exists"
else
        echo "BRAS RRD not exists, creating"
        rrdtool create "$WORKDIR"bras5.rrd --step=60 --start=now-121s DS:users:GAUGE:60:U:U  RRA:LAST:0:1:60
fi

lighttpd -f /etc/lighttpd/lighttpd.conf

while true
do
    
    START=$(expr $(date "+%s") - 61)

    VALUE3=`snmpgetnext -v 2c -c "$COMMUNITY" "$BRAS3IP" 1.3.6.1.4.1.2011.5.2.1.14.1.1 | awk '{ print $4 }'`
    VALUE4=`snmpgetnext -v 2c -c "$COMMUNITY" "$BRAS4IP" 1.3.6.1.4.1.2011.5.2.1.14.1.1 | awk '{ print $4 }'`
    VALUE5=`snmpgetnext -v 2c -c "$COMMUNITY" "$BRAS5IP" 1.3.6.1.4.1.2011.5.2.1.14.1.1 | awk '{ print $4 }'`


    echo "Value get from BRAS3: "$VALUE3
    echo "Value get from BRAS4: "$VALUE4
    echo "Value get from BRAS5: "$VALUE5

    rrdtool update "$WORKDIR"bras3.rrd ${START}:${VALUE3}
    rrdtool update "$WORKDIR"bras4.rrd ${START}:${VALUE4}
    rrdtool update "$WORKDIR"bras5.rrd ${START}:${VALUE5}


	rrdtool graph "$HTMLDIR"rrdtool1_graph1.png  -w 800 -h 600   --start now-3600s --end now \
	DEF:bras3="$WORKDIR"bras3.rrd:users:LAST \
	VDEF:bras3u=bras3,LAST \
	LINE:bras3#FF0000:"BRAS3" \
	DEF:bras4="$WORKDIR"bras4.rrd:users:LAST \
	VDEF:bras4u=bras4,LAST \
	LINE:bras4#00FF00:"BRAS4" \
	DEF:bras5="$WORKDIR"bras5.rrd:users:LAST \
	VDEF:bras5u=bras5,LAST \
	LINE:bras5#0000FF:"BRAS5\n" \
	COMMENT:"BARS3\:" GPRINT:bras3u:"%6.2lf%s\\n" \
	COMMENT:"BARS4\:" GPRINT:bras4u:"%6.2lf%s\\n" \
	COMMENT:"BARS5\:" GPRINT:bras5u:"%6.2lf%s\\n"


    sleep 30

done

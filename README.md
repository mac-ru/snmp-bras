# Internal project.
## TL:DR
To run on server use command:

```
$ docker run -d --restart always --log-opt max-size=10m --log-opt max-file=5 --name bras-snmp -e BRAS3IP=3.3.3.3 -e BRAS4IP=4.4.4.4 -e BRAS5IP=5.5.5.5 -e COMMUNITY=public -p 8080:80 -v /home/rrd:/mrtg/data -v /home/html:/mrtg/html snmp:latest
```

## Description
This project saves special SNMP data and put it into RRD to dispay user counts.
Uses environment variables to put data into container

To build project:
```
$ ./build.sh 
```

To run
```
$ docker run -d --restart always --log-opt max-size=10m --log-opt max-file=5 --name bras-snmp -e BRAS3IP=3.3.3.3 -e BRAS4IP=4.4.4.4 -e BRAS5IP=5.5.5.5 -e COMMUNITY=public -p 8080:80 -v /home/rrd:/mrtg/data -v /home/html:/mrtg/html snmp:latest
```

or put variables into env-file i.e. enffile.conf 
```
$ cat env-file.conf
BRAS3IP=3.3.3.3
BRAS4IP=4.4.4.4
BRAS5IP=5.5.5.5
COMMUNITY=public
```

and run 
```
$ docker run -d --restart always --log-opt max-size=10m --log-opt max-file=5 --name bras-snmp --env-file envfile.conf -p 8080:80 -v /home/rrd:/mrtg/data -v /home/html:/mrtg/html snmp:latest
```

RRD data stored in /mrtg/data
HTML files stored in /mrtg/html

To save them use volumes

Container outputs to log. To limit logfile use:
--log-opt max-size=10m --log-opt max-file=5

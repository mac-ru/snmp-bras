docker build --tag snmp:latest --tag localhost:5000/snmp:latest .
docker tag snmp:latest localhost:5000/snmp
docker push localhost:5000/snmp

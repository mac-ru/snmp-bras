FROM fboaventura/dckr-mrtg:v2.3.0
ENV TZ "Europe/Samara"
RUN mkdir /snmp/
RUN mkdir /mrtg/data/
WORKDIR /snmp/
COPY start.sh /snmp/
COPY arial.ttf /usr/share/fonts/TTF/arial.ttf
COPY crontab /etc/crontabs/root
COPY run.sh /snmp/run.sh
ENV WORKDIR=/mrtg/data
ENV FIFOFILE=/snmp/socket.fifo
ENV HTMLDIR=/mrtg/html
ENTRYPOINT ["./start.sh"]

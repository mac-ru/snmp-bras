FROM fboaventura/dckr-mrtg:v2.3.0
ENV TZ "Europe/Samara"
RUN mkdir /snmp/
RUN mkdir /mrtg/data/
WORKDIR /snmp/
COPY files/start.sh /snmp/
COPY files/arial.ttf /usr/share/fonts/TTF/Arial.ttf
COPY files/cour.ttf /usr/share/fonts/TTF/Courier.ttf
COPY files/crontab /etc/crontabs/root
COPY files/run.sh /snmp/run.sh
COPY files/index.html /snmp/index.html
ENV WORKDIR=/mrtg/data
ENV FIFOFILE=/snmp/socket.fifo
ENV HTMLDIR=/mrtg/html
ENTRYPOINT ["./start.sh"]

FROM fboaventura/dckr-mrtg:v2.3.0
ENV TZ "Europe/Samara"
RUN mkdir /snmp/
RUN mkdir /mrtg/data/
WORKDIR /snmp/
COPY start.sh /snmp/
ENV WORKDIR=/mrtg/data
ENV HTMLDIR=/mrtg/html
ENTRYPOINT ["./start.sh"]
CMD ["1.1.1.1"]

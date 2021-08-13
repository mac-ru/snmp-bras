FROM fboaventura/dckr-mrtg:v2.3.0
RUN mkdir /snmp/
WORKDIR /snmp/
COPY start.sh /snmp/
ENV BRAS3IP=
ENTRYPOINT ["./start.sh"]
CMD ["1.1.1.1"]

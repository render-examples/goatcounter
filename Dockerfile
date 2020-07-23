FROM debian

RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install postgresql

ENV GC_VERSION=v1.3.2

ADD https://github.com/zgoat/goatcounter/releases/download/${GC_VERSION}/goatcounter-${GC_VERSION}-linux-amd64.gz /bin/goatcounter.gz

ADD https://raw.githubusercontent.com/zgoat/goatcounter/c47bde96ad1de204fbcf573e5ca3a507330c4279/db/schema.pgsql /db/schema.pgsql
RUN chmod 0755 -R /db/ 

RUN gunzip /bin/goatcounter.gz \
    && chmod +x /bin/goatcounter

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT [ "/docker-entrypoint.sh" ]

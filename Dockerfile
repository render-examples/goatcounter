FROM debian

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y \
    tzdata \
    postgresql

ENV GC_VERSION=v1.4.2
ENV GC_BRANCH_NAME=release-1.4

ADD https://github.com/zgoat/goatcounter/releases/download/${GC_VERSION}/goatcounter-${GC_VERSION}-linux-amd64.gz /bin/goatcounter.gz
ADD https://raw.githubusercontent.com/zgoat/goatcounter/${GC_BRANCH_NAME}/db/schema.pgsql /db/schema.pgsql
RUN chmod 0755 -R /db/

RUN gunzip /bin/goatcounter.gz \
    && chmod +x /bin/goatcounter

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 10000

ENTRYPOINT [ "/docker-entrypoint.sh" ]

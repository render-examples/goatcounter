FROM alpine:3.12

RUN apk --no-cache add \
    bash \
    gzip \
    postgresql-client \
    tzdata \
    wget

ENV GC_VERSION=v1.3.2
ENV GC_DOWNLOAD="https://github.com/zgoat/goatcounter/releases/download/${GC_VERSION}/goatcounter-${GC_VERSION}-linux-amd64.gz"
ENV GC_SCHEMA="https://raw.githubusercontent.com/zgoat/goatcounter/${GC_VERSION}/db/schema.pgsql"

RUN wget -O- "${GC_DOWNLOAD}" | gunzip -c > /bin/goatcounter \
    && chmod +x /bin/goatcounter \
    && wget -O- "${GC_SCHEMA}" > /etc/schema.pgsql

COPY render-goatcounter.sh /bin/render-goatcounter
ENTRYPOINT ["/bin/render-goatcounter"]
CMD ["serve"]

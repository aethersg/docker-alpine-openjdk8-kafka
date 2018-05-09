FROM judetan/docker-alpine-openjdk8:latest


MAINTAINER wurstmeister

ENV KAFKA_VERSION=1.1.0 \
    SCALA_VERSION=2.12 \
    KAFKA_HOME=/opt/kafka \
    GLIBC_VERSION=$2.27-r0

ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY download-kafka.sh start-kafka.sh broker-list.sh create-topics.sh /tmp/

RUN apk add --no-cache bash curl jq docker \
 && mkdir /opt \
 && chmod a+x /tmp/*.sh \
 && mv /tmp/start-kafka.sh /tmp/broker-list.sh /tmp/create-topics.sh /usr/bin \
 && sync && /tmp/download-kafka.sh \
 && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
 && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
 && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka \
 && rm /tmp/*
# && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
# && apk add --no-cache --allow-untrusted glibc-${GLIBC_VERSION}.apk \
# && rm glibc-${GLIBC_VERSION}.apk

VOLUME ["/kafka"]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]
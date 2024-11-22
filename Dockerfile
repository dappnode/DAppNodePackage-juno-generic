ARG UPSTREAM_VERSION
FROM nethermind/juno:${UPSTREAM_VERSION}

RUN apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /var/lib/juno

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "-c", "./entrypoint.sh"]

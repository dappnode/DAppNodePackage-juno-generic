ARG UPSTREAM_VERSION
FROM nethermind/juno:${UPSTREAM_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends wget \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/juno

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["bash", "-c", "./entrypoint.sh"]

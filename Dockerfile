ARG UPSTREAM_VERSION
FROM nethermindeth/juno:${UPSTREAM_VERSION}

RUN mkdir -p home/juno

ENTRYPOINT juno

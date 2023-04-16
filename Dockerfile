ARG UPSTREAM_VERSION
FROM nethermindeth/juno:${UPSTREAM_VERSION}

ENTRYPOINT /usr/local/bin/juno

ARG UPSTREAM_VERSION
FROM nethermind/juno:${UPSTREAM_VERSION}

# Install required tools (wget + zstd) in one layer before cleaning up
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget zstd && \
    rm -rf /var/lib/apt/lists/*

# Create juno data directory
RUN mkdir -p /var/lib/juno

# Add the entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

#!/bin/sh

set -e

JUNO_DIR=/var/lib/juno

echo "Starting Juno node with the following parameters:"
echo "Juno data directory: $JUNO_DIR"
echo "Snapshot URL: $SNAPSHOT_URL"
echo "Network: $NETWORK"
echo "Ethereum L1 RPC URL: $ETH_L1_RPC_URL"
echo "WebSocket enabled: $ENABLE_WS"
echo "WebSocket port: $WS_PORT"
echo "WebSocket host: $WS_HOST"
echo "Extra options: $EXTRA_OPTS"

# echo all envs
printenv

# if dir is empty and URL is configured, download the snapshot
if [ "$(ls -A $JUNO_DIR)" ]; then
  echo "Skipping snapshot download."
elif [ -n "$SNAPSHOT_URL" ]; then
  echo "Juno data directory is empty. Downloading snapshot."
  snapshot=mainnet.tar
  wget --progress=dot:giga -O $snapshot $SNAPSHOT_URL
  tar --checkpoint=65536 -xf $snapshot -C $JUNO_DIR
  rm $snapshot
fi

ethnode=""
if [ -n "$ETH_L1_RPC_URL" ]; then
  echo "Using Ethereum node to verify the state on L1."
  ethnode="--eth-node $ETH_L1_RPC_URL"
else
  echo "L1 verification is disabled."
  ethnode="--disable-l1-verification"
fi

wsopts=""
if [ "$ENABLE_WS" = "true" ]; then
  echo "WebSocket interface enabled."
  wsopts="--ws --ws-port ${WS_PORT:-6061} --ws-host ${WS_HOST:-0.0.0.0}"
fi

juno \
  --network ${NETWORK:-sepolia} \
  --http \
  --http-port ${HTTP_PORT:-6060} \
  --http-host 0.0.0.0 \
  --db-path $JUNO_DIR \
    --metrics \
  --metrics-port 9090 \
  --metrics-host 0.0.0.0 \
  $ethnode $wsopts $EXTRA_OPTS


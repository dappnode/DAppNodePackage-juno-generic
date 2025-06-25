#!/bin/bash

set -e

JUNO_DIR=/var/lib/juno

# Ensure the data directory exists
mkdir -p $JUNO_DIR

# Build snapshot URL based on network
if [ -z "$SNAPSHOT_URL" ] && [ -n "$NETWORK" ]; then
  case $NETWORK in
    "mainnet")
      SNAPSHOT_URL="https://juno-snapshots.nethermind.io/files/mainnet/latest"
      SNAPSHOT_SIZE="~172 GB"
      ;;
    "sepolia")
      SNAPSHOT_URL="https://juno-snapshots.nethermind.io/files/sepolia/latest"
      SNAPSHOT_SIZE="~5.7 GB"
      ;;
    "sepolia-integration")
      SNAPSHOT_URL="https://juno-snapshots.nethermind.io/files/sepolia-integration/latest"
      SNAPSHOT_SIZE="~2.4 GB"
      ;;
    *)
      echo "Unknown network: $NETWORK. Available: mainnet, sepolia, sepolia-integration"
      SNAPSHOT_URL=""
      SNAPSHOT_SIZE="unknown"
      ;;
  esac
fi

echo "Starting Juno node with the following parameters:"
echo "Juno data directory: $JUNO_DIR"
echo "Network: ${NETWORK:-not specified}"
echo "Snapshot URL: $SNAPSHOT_URL"
echo "Snapshot size: ${SNAPSHOT_SIZE:-not specified}"
echo "Ethereum L1 RPC URL: $ETH_L1_RPC_URL"
echo "WebSocket enabled: $ENABLE_WS"
echo "WebSocket port: $WS_PORT"
echo "WebSocket host: $WS_HOST"
echo "Extra options: $EXTRA_OPTS"

# if dir is empty and URL is configured, download the snapshot
if [ -f "$JUNO_DIR/.initialized" ]; then
  echo "Snapshot already initialized. Skipping download."
else
  if [ -n "$SNAPSHOT_URL" ]; then
    echo "Juno data directory is empty. Downloading snapshot for $NETWORK network."
    mkdir -p $JUNO_DIR
    snapshot="${NETWORK:-mainnet}.tar"
    
    # Download with retries and resume capability
    max_retries=3
    retry_count=0
    
    while [ $retry_count -lt $max_retries ]; do
      echo "Download attempt $((retry_count + 1)) of $max_retries"
      
      if wget --continue --progress=dot:giga --timeout=60 --tries=3 -O $snapshot $SNAPSHOT_URL; then
        echo "Download completed successfully!"
        break
      else
        retry_count=$((retry_count + 1))
        if [ $retry_count -lt $max_retries ]; then
          echo "Download failed. Retrying in 30 seconds..."
          sleep 30
        else
          echo "Download failed after $max_retries attempts. Starting Juno without snapshot."
          rm -f $snapshot
          break
        fi
      fi
    done
    
    # Extract if download was successful
    if [ -f "$snapshot" ]; then
      echo "Extracting snapshot..."
      if tar --checkpoint=65536 -xf $snapshot -C $JUNO_DIR; then
        echo "Snapshot extracted successfully!"
        touch $JUNO_DIR/.initialized
      else
        echo "Failed to extract snapshot. Starting Juno without snapshot."
      fi
      rm -f $snapshot
    fi
  else
    echo "No snapshot URL configured. Starting Juno without snapshot (will sync from scratch)."
  fi
fi

ethnode=""
if [ -n "$ETH_L1_RPC_URL" ]; then
  echo "Using Ethereum node to verify the state on L1."
  ethnode="--eth-node $ETH_L1_RPC_URL"
fi

wsopts=""
if [ "$ENABLE_WS" = "true" ]; then
  echo "WebSocket interface enabled."
  wsopts="--ws --ws-port ${WS_PORT:-6061} --ws-host ${WS_HOST:-0.0.0.0}"
fi

juno \
  --http \
  --http-port 6060 \
  --http-host 0.0.0.0 \
  --db-path $JUNO_DIR \
  $ethnode $wsopts $EXTRA_OPTS

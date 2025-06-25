#!/bin/bash

# Juno Snapshot Downloader
# Usage: ./download-snapshot.sh [mainnet|sepolia|sepolia-integration]

set -e

# Default to mainnet if no argument provided
NETWORK=${1:-mainnet}

# Snapshot URLs
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
    echo "Invalid network. Use: mainnet, sepolia, or sepolia-integration"
    exit 1
    ;;
esac

JUNO_DIR=~/juno
SNAPSHOT_FILE="${NETWORK}.tar"

echo "=== Juno Snapshot Downloader ==="
echo "Network: $NETWORK"
echo "Size: $SNAPSHOT_SIZE"
echo "URL: $SNAPSHOT_URL"
echo "Target directory: $JUNO_DIR"
echo ""

# Create directory if it doesn't exist
mkdir -p $JUNO_DIR

# Check if already initialized
if [ -f "$JUNO_DIR/.initialized" ]; then
  echo "Snapshot already initialized. Skipping download."
  exit 0
fi

echo "Starting download..."
echo "This may take a while. You can stop and resume later with Ctrl+C and running this script again."

# Download with resume capability and better error handling
max_retries=5
retry_count=0

while [ $retry_count -lt $max_retries ]; do
  echo ""
  echo "Download attempt $((retry_count + 1)) of $max_retries"
  
  if wget --continue \
          --progress=dot:giga \
          --timeout=60 \
          --tries=3 \
          --retry-connrefused \
          --waitretry=10 \
          -O $SNAPSHOT_FILE \
          $SNAPSHOT_URL; then
    echo ""
    echo "✅ Download completed successfully!"
    break
  else
    retry_count=$((retry_count + 1))
    if [ $retry_count -lt $max_retries ]; then
      echo ""
      echo "❌ Download failed. Retrying in 60 seconds..."
      sleep 60
    else
      echo ""
      echo "❌ Download failed after $max_retries attempts."
      echo "You can try again later by running this script again."
      exit 1
    fi
  fi
done

# Extract snapshot
if [ -f "$SNAPSHOT_FILE" ]; then
  echo ""
  echo "Extracting snapshot..."
  if tar --checkpoint=65536 -xf $SNAPSHOT_FILE -C $JUNO_DIR; then
    echo "✅ Snapshot extracted successfully!"
    touch $JUNO_DIR/.initialized
    echo "✅ Snapshot initialization complete!"
  else
    echo "❌ Failed to extract snapshot."
    exit 1
  fi
  rm -f $SNAPSHOT_FILE
fi

echo ""
echo "🎉 Snapshot download and extraction completed!"
echo "You can now start Juno with: docker-compose up -d" 
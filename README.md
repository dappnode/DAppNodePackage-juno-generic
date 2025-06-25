# DappNode Juno Package

[![DAppNodeStore Available](https://img.shields.io/badge/DAppNodeStore-Available-brightgreen.svg)](http://my.dappnode/#/installer/juno.public.dappnode.eth)

Wrapper around Nethermind Juno to run a Starknet full node giving you a safe view into StarkNet network, helping to keep the network secure and the data accurate.

Juno is a Go implementation of a Starknet full-node client created by Nethermind to allow node operators to easily and reliably support the network and advance its decentralisation goals. See the [Juno website](https://juno.nethermind.io/)

## Quick Start

The package automatically creates the required data directory and downloads the latest snapshot on first run. No manual setup required!

```bash
docker-compose up -d
```

## Accessing the Service

Once running, you can access the Juno node using the following DappNode DNS aliases:

- **HTTP API**: `http://juno.public.dappnode:6060`
- **WebSocket API**: `ws://juno.public.dappnode:6061`

Or using the full domain:
- **HTTP API**: `http://juno.public.dappnode.eth:6060`
- **WebSocket API**: `ws://juno.public.dappnode.eth:6061`

## DappNode configuration

`NETWORK`: Select the Starknet network to sync (default: "mainnet"). Available options:

- **mainnet**: Mainnet network (~172 GB snapshot)
- **sepolia**: Sepolia testnet (~5.7 GB snapshot)
- **sepolia-integration**: Sepolia integration testnet (~2.4 GB snapshot)

`SNAPSHOT_URL`: To speed up first sync, set a snapshot URL. Default is the latest mainnet snapshot from Nethermind. Leave empty to sync from scratch. See [Snapshots](https://juno.nethermind.io/snapshots). 

`ETH_L1_RPC_URL`: To enable L1 verification, provide the Websocket endpoint of a running Ethereum node. Leave empty to skip verification. See `eth-node` parameter in [Configuration options](https://juno.nethermind.io/configuring#configuration-options)

> Note: a failed snapshot download may leave files in the snapshot directory and will skip downloading at the next restart. To force a snapshot download, delete the package and reinstall. 

`ENABLE_WS`: Enable WebSocket RPC server (default: "true"). Set to "false" to disable.

`WS_PORT`: WebSocket server port (default: 6061). See [WebSocket Interface](https://juno.nethermind.io/websocket)

`WS_HOST`: WebSocket server host interface (default: "0.0.0.0"). See [WebSocket Interface](https://juno.nethermind.io/websocket)

`EXTRA_OPTS`: Additional configuration options. See [Configuration options](https://juno.nethermind.io/configuring#configuration-options)

## Network Configuration Examples

### Mainnet (Production)

```yaml
environment:
  NETWORK: "mainnet"
  # Will download ~172 GB snapshot
```

### Sepolia (Testing)

```yaml
environment:
  NETWORK: "sepolia"
  # Will download ~5.7 GB snapshot
```

### Sepolia Integration (Development)

```yaml
environment:
  NETWORK: "sepolia-integration"
  # Will download ~2.4 GB snapshot
```

### Custom Snapshot URL

```yaml
environment:
  NETWORK: "mainnet"
  SNAPSHOT_URL: "https://your-custom-snapshot-url.com/snapshot.tar"
```

### No Snapshot (Sync from scratch)

```yaml
environment:
  NETWORK: "mainnet"
  SNAPSHOT_URL: ""
```

## Data Persistence

The package uses Docker named volumes for data persistence:

- **Volume name**: `juno_data`
- **Data location**: `/var/lib/juno` (inside container)
- **Persistence**: Data persists across container restarts and updates

## WebSocket Interface

This package includes WebSocket support for real-time interactions with the Starknet network. The WebSocket server runs on port 6061 by default and supports:

- All Starknet JSON-RPC API endpoints
- Subscription to newly created blocks (`starknet_subscribeNewHeads`)
- Subscription to events (`starknet_subscribeEvents`)
- Subscription to transaction status (`starknet_subscribeTransactionStatus`)
- Subscription to pending transactions (`starknet_subscribePendingTransactions`)

For more information, see the [Juno WebSocket documentation](https://juno.nethermind.io/websocket).

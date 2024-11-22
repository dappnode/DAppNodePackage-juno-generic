# DappNode Juno Package

[![DAppNodeStore Available](https://img.shields.io/badge/DAppNodeStore-Available-brightgreen.svg)](http://my.dappnode/#/installer/juno.public.dappnode.eth)

Wrapper around Nethermind Juno to run a Starknet full node giving you a safe view into StarkNet network, helping to keep the network secure and the data accurate.

Juno is a Go implementation of a Starknet full-node client created by Nethermind to allow node operators to easily and reliably support the network and advance its decentralisation goals. See the [Juno website](https://juno.nethermind.io/)


## DappNode configuration

`ETH_L1_RPC_URL`: To enable L1 verification, provide the Websocket endpoint of a running Ethereum node. Leave empty to skip verification. See `eth-node` parameter in [Configuration options](https://juno.nethermind.io/configuring#configuration-options)

`SNAPSHOT_URL`: To speed up first sync, set a snapshot URL. Default is the latest mainnet snapshot from Nethermind. Leave empty to sync from scratch. See [Snapshots](https://juno.nethermind.io/snapshots). 
> Note: a failed snapshot download may leave files in the snapshot directory and will skip downloading at the next restart. To force a snapshot download, delete the package and reinstall. 

`EXTRA_OPTS`: Additional configuration options. See [Configuration options](https://juno.nethermind.io/configuring#configuration-options)
# DappNode Juno Package

[![DAppNodeStore Available](https://img.shields.io/badge/DAppNodeStore-Available-brightgreen.svg)](http://my.dappnode/#/installer/juno.public.dappnode.eth)

Wrapper around Nethermind Juno to run a Starknet full node giving you a safe view into StarkNet network, helping to keep the network secure and the data accurate.

Juno is a golang Starknet node implementation by Nethermind with the aim of decentralising Starknet.

## ✔ Supported Features

- Starknet state construction and storage using a path-based Merkle Patricia trie. 
- Pedersen and `starknet_keccak` hash implementation over starknet field.
- Feeder gateway synchronisation of Blocks, Transactions, Receipts, State Updates and Classes.
- Block and Transaction hash verification.
- JSON-RPC Endpoints:
  - `starknet_chainId`
  - `starknet_blockNumber`
  - `starknet_blockHashAndNumber`
  - `starknet_getBlockWithTxHashes`
  - `starknet_getBlockWithTxs`
  - `starknet_getTransactionByHash`
  - `starknet_getTransactionReceipt`
  - `starknet_getBlockTransactionCount`
  - `starknet_getTransactionByBlockIdAndIndex`
  - `starknet_getStateUpdate`

---
title: AGORIC_NET
source: docs/env.md
source_repo: agoric/agoric-sdk
source_commit: 8051bed260133080a0d46339aefcc9baba5c1d34
source_date: 2026-03-31
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [tooling, repository-governance, errors]
status: current
parent: agoric-sdk--docs-env--all-vars
---

Affects: CLIs (`agoric` etc.), ymax-planner, other uses of `@agoric/client-utils`

Purpose: specify the chain/endpoint for outbound queries and transactions

Description: if nonempty, its contents must use one of the following formats:
  - "$subdomain": a subdomain of agoric.net that is expected to respond to an
    HTTP request for `/network-config` (e.g., "local" or "main" or a network
    listed at https://all.agoric.net/ ) with a JSON MinimalNetworkConfig object
    containing at least the following properties:
      * `chainName`: a Cosmos Chain ID (cf.
         https://evm.cosmos.network/docs/next/documentation/concepts/chain-id
         and https://github.com/cosmos/chain-registry )
      * `rpcAddrs`: an array of endpoints that are expected to respond to
        cosmos-sdk RPC requests
  - "$subdomain,$chainId": a single-word subdomain of rpc.agoric.net that is
    expected to respond to cosmos-sdk RPC requests, and a Cosmos Chain ID to
    associate with it
  - "$fqdn,$chainId": a fully-qualified domain name that is expected to respond
    to cosmos-sdk RPC requests, and a Cosmos Chain ID to associate with it

The default is usually `'local'`, which uses RPC endpoint http://0.0.0.0:26657
and chain ID "agoriclocal".

Lifetime: probably forever

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md) at commit `8051bed2`.

---
title: Bootstrap Sequence
source: doc/design/root-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage, networking]
status: current
---

Abstract: The three startup paths for a CASK server's root structure. A **fresh server** (no existing root) generates an identity (ed25519 key pair plus a random node_id), initializes empty structures (session table, cell bank, membership with self only, pinned roots; consensus and application set to ZeroHash), writes the root block (assemble component hashes, set flags defaulting to not-clustered with encryption optional, store, and record the root hash as "current root"), then pins the root to bootstrap the GC system. An **existing server** (root exists) loads the current root hash from stable storage, validates the block and extracts component hashes, decrypts and verifies the identity key pair (may require passphrase or HSM), initializes subsystems (load the session table and start the expiration goroutine, load the cell bank, load membership and attempt peer connections, and if clustered load Raft state and join consensus), then is ready to accept connections and process LOAD/STOR requests. **Joining a cluster** requires a fresh server with identity, the address of an existing member, and an out-of-band trust token: the joiner connects and exchanges identities, the existing member adds the new node to membership and to the trusted set and sends current membership, the new node sets its clustered flag and initializes Raft as a follower, then catches up by applying log entries the Raft leader sends until it becomes a voting member.

## Bootstrap Sequence

### Fresh Server (No Existing Root)

1. **Generate Identity** - create ed25519 key pair, generate random node_id, store identity block.
2. **Initialize Structures** - create empty session table, empty cell bank, empty membership (self only), empty pinned roots; set consensus to ZeroHash (not clustered) and application to ZeroHash.
3. **Write Root Block** - assemble all component hashes, set flags (default: not clustered, encryption optional), store root block, record root hash as "current root".
4. **Pin Root** - add root hash to pinned roots; this bootstraps the GC system.

### Existing Server (Root Exists)

1. **Load Root Block** - read current root hash from stable storage, load and validate the root block, extract component hashes.
2. **Load Identity** - decrypt private key (may require passphrase/HSM), verify key pair consistency.
3. **Initialize Subsystems** - load session table and start expiration goroutine, load cell bank, load membership and attempt peer connections; if clustered, load Raft state and join consensus.
4. **Ready for Operations** - accept incoming connections, process LOAD/STOR requests, handle session establishment.

### Joining a Cluster

1. **Prerequisites** - fresh server with identity, address of an existing cluster member, trust token (out-of-band).
2. **Join Protocol** - connect to existing member, exchange identities; existing member adds new node to membership and to the trusted set; new node receives current membership, sets the clustered flag, and initializes Raft as a follower.
3. **Catch Up** - Raft leader sends log entries; new node applies entries to reach current state and becomes a voting member.

Source: [doc/design/root-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/root-design.md) at commit `cdb975d8`.

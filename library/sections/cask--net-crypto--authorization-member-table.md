---
title: Authorization (Member Table)
source: doc/design/net-crypto.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking, capability-security]
status: current
---

> Abstract: How casknet decides which peers may open a session. Each node maintains a **member table** of authorized peer ed25519 public keys. Before a session can be established, each peer's public key must be added to the other's member table via `cask accept <hex-pubkey>`. During the Noise IK handshake the server decrypts the initiator's static public key out of message 1 and checks it against the member table; if the key is absent, the server replies with a plaintext rejection carrying `status=2` (not authorized). The `cask invite` command prints the local node's ed25519 public key in hex for out-of-band exchange. This is the authorization layer the `membertable` package and the `mode`/session-gating state in the session table implement.

## Authorization

Nodes maintain a **member table** of authorized peer public keys. Before a session can be established, each peer's ed25519 public key must be added to the other's member table using `cask accept <hex-pubkey>`.

During the Noise IK handshake, the server decrypts the initiator's static public key from message 1 and checks it against the member table. If the key is not found, the server sends a plaintext rejection with `status=2` (not authorized).

The `cask invite` command prints the local node's ed25519 public key in hex, suitable for out-of-band exchange.

Source: [doc/design/net-crypto.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-crypto.md) at commit `cdb975d8`.

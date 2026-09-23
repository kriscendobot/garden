---
title: Noise-protocol cryptography
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: CASK's transport cryptography. All inter-node UDP traffic is encrypted with ChaCha20-Poly1305 AEAD. Sessions are established with a two-message Noise IK handshake using x25519 key exchange derived from each node's persistent ed25519 identity. This eliminates dependence on DNS, TLS, and certificate authorities. Only the local Unix domain socket (`cask/sock`) remains plaintext, protected by filesystem permissions.

All inter-node UDP traffic is encrypted with ChaCha20-Poly1305 AEAD. Sessions are established with a two-message Noise IK handshake using x25519 key exchange derived from each node's persistent ed25519 identity (see the `net-crypto` design doc).

This eliminates dependence on DNS, TLS, and certificate authorities. Only the local Unix domain socket (`cask/sock`) remains plaintext, protected by filesystem permissions.

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.

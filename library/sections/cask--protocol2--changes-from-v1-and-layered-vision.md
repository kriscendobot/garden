---
title: CASK Network Protocol v2 (superseded) — changes from v1 and the layered vision
source: doc/design/protocol2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: superseded
notes: |
  Protocol v2 was a proposed UDP protocol that was **never implemented**. The
  shipped implementation uses the plaintext casksock wire format
  (cask--protocol--*), the Noise-IK encryption layer (cask--net-crypto--*), and
  encrypted session establishment (cask--net-session-init-design--*) instead.
  Ingested as the historical record of the abandoned design and the origin of
  the Layer 0-4 architecture vision (which carried forward into architecture.md).
---

## Abstract

The motivation and scope of CASK Protocol v2, an evolution of v1 toward fixed-offset framing, ed25519 session identity, and Dapper-style distributed tracing over a UDP substrate. **This document was never implemented** (it self-declares "SUPERSEDED" in its header): the shipped system uses the plaintext casksock format plus the Noise-IK encrypted casknet protocol, not this proposal. The four key v2 improvements were regular 1026-byte block framing, session management keyed by ed25519 public keys, span+cohort distributed-tracing fields, and fixed-offset structured headers. v2 was explicitly not backward-compatible with v1, expecting either version detection from the first message, dual-protocol-on-different-ports operation, or a full migration. The "Future Extensions" section sketches the Layer 0-4 stack (block transfer, session/encryption, Merkle/filesystem, RPC/routing, orchestration/consensus) that later materialized in `architecture.md`.

## Changes from v1

Key improvements: (1) **regular block framing** (fixed 1026-byte block: 1 byte depth + 1 byte type + 1024 bytes payload); (2) **session management** (session-based communication with ed25519 public-key identification); (3) **distributed tracing** (span and cohort fields for request correlation and trace aggregation); (4) **structured headers** (fixed-offset message format for efficient parsing).

**Backward compatibility.** v2 is not backward compatible with v1. Implementations were expected to detect protocol version during handshake or first message, support both protocols simultaneously on different ports, or migrate fully to v2.

## Transport

UDP, 1500-byte maximum packet size (Ethernet MTU), configurable port (no default specified), version 2 identified by uppercase command strings (`STOR`/`LOAD`) rather than v1's lowercase. v2 was described as "Layer 0 (Block Transfer)" of a larger layered architecture.

## Future extensions (the layered vision)

This protocol (Layer 0) was intended as the foundation for a layered architecture, with additional layers added as requirements emerged:

- **Layer 1**: session establishment, encryption (Noise Protocol), authentication.
- **Layer 2**: Merkle-tree operations, filesystem abstractions, garbage collection.
- **Layer 3**: RPC, request routing, load balancing, coordinated load-shedding.
- **Layer 4**: orchestration, consensus, leader election, sharding, replication.

This five-layer framing is the direct ancestor of the casknet stack documented in `cask--architecture--design-principles-and-protocols` and the Layer 0-4 sections that follow it; the architecture document realized the vision over the actual (non-v2) wire formats.

Source: [doc/design/protocol2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/protocol2.md) at commit `cdb975d8`.

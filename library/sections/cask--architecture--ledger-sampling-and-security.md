---
title: Ledger, Sampling, Session Abstraction, and Security Architecture
source: doc/design/architecture.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: The cross-layer and supporting facilities of casknet. Because all blocks are content-addressed and already in storage format, a low-cost activity **ledger** can be captured directly from network traffic with simple memcopy and no translation; the `SAMP` command samples blocks by rate and filter (cohort, span, session, time range) without parsing them, and the ledger itself is a Merkle tree of activity blocks. **Session abstraction** offers two modes: session-based (sequence-ordered spans for stateful, ordered RPC) and sessionless (independent requests using ephemeral sessions for encryption, suited to idempotent operations). The **security architecture** layers transport encryption (optional DTLS), session encryption (Layer 1 Noise/ChaCha20-Poly1305), and application end-to-end encryption, authenticating nodes with ed25519, exchanging keys with x25519, and using the Noise Protocol for authenticated key exchange under a no-central-authority, peer-to-peer model.

## Ledger & Archiving

- All blocks are content-addressed (SHA-256) and captured directly from traffic — no translation, memcopy-friendly archival.
- **Sampling** (`SAMP`): sample rate plus a filter on cohort/span/session/time; sample blocks without expensive parsing; archive sampled blocks directly.
- **Ledger structure**: a Merkle tree of activity blocks, each holding timestamp, operation, participants, and result hash; samplable without full reconstruction.

The worked example in the document is a massively parallel generational cellular automaton: the world is sharded across workers (replicated for fault tolerance), a leader coordinates generation transitions via COOR, workers sync boundary regions with TREE operations between generations, results return via STOR, and unhealthy-cohort workers are excluded from coordination.

## Session Abstraction

- **Session-based**: spans within a session can be ordered via sequence numbers; supports ordered RPC and stateful protocols; session state can live in Merkle trees and be replicated or migrated.
- **Sessionless**: each request is independent, using ephemeral sessions only for encryption; simpler, more scalable, suited to idempotent operations.

## Security Architecture

- **Encryption layers**: optional transport DTLS; Layer 1 session encryption (Noise Protocol, ChaCha20-Poly1305); application-level end-to-end encryption.
- **Authentication**: ed25519 for node authentication; x25519 for key exchange; Noise Protocol for authenticated key exchange; session numbers signed by the recipient for authorization.
- **Decentralization**: no central authority; peer-to-peer discovery; distributed consensus for coordination; self-organizing systems.

Source: [doc/design/architecture.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/architecture.md) at commit `cdb975d8`.

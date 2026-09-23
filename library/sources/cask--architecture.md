---
source: doc/design/architecture.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 5
status: current
---

> Abstract: The layered-architecture design document for CASK Protocol v2. It establishes six design principles, distinguishes CASK's two protocols (casknet, encrypted UDP inter-node; casksock, plaintext local Unix socket), and lays out a five-layer stack for casknet: Layer 0 raw 1KB-block transfer (LOAD/STOR), Layer 1 PSK-authenticated sessions with ChaCha20-Poly1305 AEAD, Layer 2 Merkle-tree and filesystem operations (TREE, FSOP) with GC-transparent tree structure, Layer 3 RPC with cohort-based load shedding and consistent-hashing routing, Layer 4 orchestration (Raft-like LEAD consensus, sharding, COOR coordination). A cross-layer ledger captures content-addressed blocks straight from traffic with SAMP sampling, and a security section layers transport/session/application encryption over ed25519/x25519/Noise. Every layer is optional and higher layers do not break lower ones.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [design-principles-and-protocols](../sections/cask--architecture--design-principles-and-protocols.md) | networking, content-addressed-storage | current |
| [layers-0-1-block-transfer-and-session](../sections/cask--architecture--layers-0-1-block-transfer-and-session.md) | networking | current |
| [layer-2-merkle-tree-and-filesystem](../sections/cask--architecture--layer-2-merkle-tree-and-filesystem.md) | networking, content-addressed-storage | current |
| [layers-3-4-rpc-routing-orchestration](../sections/cask--architecture--layers-3-4-rpc-routing-orchestration.md) | networking | current |
| [ledger-sampling-and-security](../sections/cask--architecture--ledger-sampling-and-security.md) | networking | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal.
- The cryptography and session-establishment depth referenced from Layer 1 lives in `doc/design/net-crypto.md` and `doc/design/net-session-init-design.md`, deferred to a follow-on `scholar-ingest-cask` job. The GC referenced from Layer 2 is detailed in `doc/design/gc-and-retention.md` and `doc/design/gc-concurrent-design.md` (also deferred).

Source: [doc/design/architecture.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/architecture.md) at commit `cdb975d8`.

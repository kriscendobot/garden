---
title: Overview and Design Principles
source: doc/design/root-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
notes: This is the integrating "system root" design that joins network, cryptography, storage, and capability threads. caskhead0 (cask--caskroot-design) is the minimal shipped subset; this document sketches the fuller future caskhead1+ root. The implemented state is caskhead0 (schema version + session table); identity/cells/membership/consensus/pinned-roots are caskhead1+ future.
---

Abstract: The framing for the CASK **system root**, the bootstrap structure that joins the network, cryptography, storage, and capability threads. Two naming terms anchor it: the **tip** (or **store tip**) is the 32-byte hash of the root block, and the **CASK_ROOT** environment variable names the **root user**, the bootstrap controller's identity (a node_id; see the membership-next-steps design). Implementation status splits the root into versions: **caskhead0 (v0)** is implemented in `head/` and carries only a schema-version hash and a session table; **caskhead1+** is the future full root adding identity, cells, membership, consensus, and pinned roots. A CASK server needs five structures too fundamental to delegate to applications: (1) **identity** (an ed25519 key pair), (2) **sessions** (cryptographic session state for secure transport), (3) **cells** (mutable capability-addressed references that act as GC roots), (4) **membership** (known peers for clustering and replication), and (5) **consensus** (optional Raft state for leader election). Four design principles govern it: **self-describing** (the root block identifies its schema version), **evolvable** (the schema hash enables future migration via zippers), **minimal** (only server-essential structures), and **layered** (higher application layers build on this foundation).

## Naming

The **tip** (or **store tip**) is the 32-byte hash of the root block (see below). The **CASK_ROOT** environment variable names the **root user**, the bootstrap controller's identity (node_id); see MEMBERSHIP_NEXT_STEPS.md.

## Implementation Status

- **caskhead0** (v0): IMPLEMENTED in `head/`
  - Schema version hash
  - Session table
- **caskhead1+** (future): Identity, cells, membership, consensus, pinned roots

## Overview

A CASK server needs certain structures that are too fundamental to delegate to applications:

1. **Identity** - The server's cryptographic identity (ed25519 key pair)
2. **Sessions** - Cryptographic session state for secure transport
3. **Cells** - Mutable capability-addressed references (GC roots)
4. **Membership** - Known peers for clustering and replication
5. **Consensus** - Raft state for leader election (optional)

These form the **system root**, the bootstrap structure that enables all higher-level operations.

## Design Principles

1. **Self-describing** - The root block identifies its schema version
2. **Evolvable** - Schema hash enables future migration via zippers
3. **Minimal** - Only structures essential to server operation
4. **Layered** - Higher layers (application data) build on this foundation

Source: [doc/design/root-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/root-design.md) at commit `cdb975d8`.

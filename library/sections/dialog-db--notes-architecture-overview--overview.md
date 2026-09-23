---
title: Design goals and information model
source: notes/architecture overview.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, datalog-query]
status: current
---

> Abstract: DialogDB's six core goals: user-owned (not application-siloed) data; local-first offline operation with seamless sync; a flexible schema that avoids migration-forcing rigidity; efficient synchronization that minimizes transfer; strong privacy and security through encryption and access control; and collaborative multi-user capability with clear conflict resolution. The information model is an **immutable, append-only database of facts** forming a knowledge graph that cooperative user agents query and update on the user's behalf. It combines **Probabilistic B-Trees** (content-addressed deterministic layout) with **Datalog** queries to enable efficient data synchronization, local-first operation, and end-to-end encryption, following the [local-first] principles.

DialogDB is designed with six core goals:

1. **User-Owned Data**: a database where users own their data, rather than having it siloed within applications.
2. **Local-First Operation**: offline functionality with seamless synchronization when connectivity is available.
3. **Flexible Schema**: avoid rigid schemas that require migrations as applications evolve.
4. **Efficient Synchronization**: minimize data transfer when synchronizing between devices or instances.
5. **Privacy and Security**: strong privacy guarantees through encryption and access control.
6. **Collaborative Capabilities**: multi-user collaboration with clear conflict resolution.

The information model is built on an **immutable, append-only database of facts** that form a knowledge graph for cooperative user agents to query and update on the user's behalf. It combines **Probabilistic B-Trees** with **Datalog** queries to enable efficient data synchronization, local-first operation, and end-to-end encryption, following [local-first] principles.

The remaining architecture sections decompose this: facts as atomic units, the causal temporal model, schema-on-query, the Merkle-CRDT merge semantics, the Probabilistic B-Tree + segment storage layer, the EAV/AEV/VAE indexes, the blob-store + DID:key mutable-pointer decoupling, and the Datalog query language.

Source: [notes/architecture overview.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/architecture%20overview.md) at commit `f777fe7c`.

[local-first]: https://inkandswitch.com/essay/local-first

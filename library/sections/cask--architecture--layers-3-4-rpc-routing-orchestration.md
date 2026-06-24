---
title: Layers 3 and 4 — RPC, Routing, and Orchestration
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

> Abstract: The two upper casknet layers. Layer 3 adds remote procedure calls (`RPC ` command, method identified by SHA-256 hash, args and results as blocks), with cohort-based load management: requests are grouped by `cohort = hash(user_id, priority) & mask` into healthy and unhealthy buckets so an overloaded node sheds unhealthy cohorts first while continuing to serve healthy ones, and independent per-request spans let requests process out of order to avoid head-of-line blocking. The `ROUT` command does hash-based (consistent-hashing) routing to shards, replicas, or nodes. Layer 4 adds orchestration: a Raft-like `LEAD` consensus using Merkle trees for log replication, consistent-hashing sharding with Merkle-tree-synchronized replication and quorum consistency, and a `COOR` command for barriers, distributed locks, generation/epoch coordination, and work distribution.

## Layer 3: RPC & Request Routing

### RPC (`RPC `)

```
60  32  methodHash  SHA-256 hash of method name
92  2   argLen      Argument length (16-bit big-endian)
94  ..  args        Arguments (variable length)
```

Response is a STOR message with the result block. Features: method identification via hash (efficient routing); arguments and results as memcopy-friendly blocks; span-based correlation for distributed tracing; cohort-based grouping for load management.

### Load Shedding & Health Grouping

- **Cohort grouping**: healthy requests get `cohort = hash(user_id, priority) & healthy_mask`; unhealthy requests get `& unhealthy_mask`. The system prioritizes healthy cohorts; unhealthy requests are grouped so they do not block healthy ones.
- **Head-of-line-blocking prevention**: each request has an independent span; requests process out of order; unhealthy requests time out faster and do not consume resources.
- **Coordinated load shedding**: overloaded systems reject requests in specific cohorts; health status propagates via cohort assignment; unhealthy cohorts shed first to maximize service to healthy requests.

### Routing (`ROUT`)

Hash-based consistent-hashing routing to shards, replicas, or specific nodes; cohort-aware (route healthy requests to healthy nodes); supports session-based and sessionless routing.

## Layer 4: Orchestration

### Consensus & Leader Election (`LEAD`)

Op selects ELECT / VOTE / HEARTBEAT; carries a candidate ed25519 key and a term number. A Raft-like consensus algorithm uses Merkle trees for log replication; the leader coordinates generation/epoch transitions; supports strong and eventual consistency.

### Sharding & Replication

Consistent hashing for shard assignment; shard metadata in Merkle trees; transparent migration and rebalancing; cohort-aware sharding. Replication via Merkle-tree synchronization with quorum-based, configurable (strong/eventual) consistency and efficient cross-sync using tree diffs.

### Coordination (`COOR`)

Barrier synchronization, distributed locks, generation/epoch coordination, and work distribution.

Source: [doc/design/architecture.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/architecture.md) at commit `cdb975d8`.

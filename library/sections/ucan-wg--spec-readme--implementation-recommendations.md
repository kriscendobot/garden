---
title: Implementation recommendations for stores, validation, and deployment
source: README.md
source_repo: ucan-wg/spec
source_commit: 9955aa1fb7b32897f80b57651f4ee8b22ebf35a7
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Daniel Holmgren, Philipp Kruger]
ingested: 2026-07-29
ingested_by: scholar
topics: [ucan-authorization, capability-security, content-addressed-storage]
status: current
---

> Abstract: UCAN implementation guidance treats received delegations as immutable, time-bounded CID-indexed records; memoizes validation until irreversible revocation invalidates a proof and its derivatives; requires replay prevention through unique CIDs and a seen-token store; and explains both leaderless CRDT deployment and compatibility wrapping around ambient ACL systems. The latter works, but weakens UCAN's end-to-end security boundary.

## Stores and replay

A local delegation store may evict expired or revoked entries and should index by CID, with secondary indexes for search. Validation is idempotent except for revocation, so validated CIDs or capability-index entries can be memoized and shared proofs need not be re-walked. On learning a CID revocation, the cache must invalidate that token and every derivative. Replay prevention is required: record seen CIDs or require per-principal monotonic nonces, and use expiry indexes, Bloom filters, or multi-level caches as scale requires.

## Deployment boundaries

For location-independent leaderless data, the executor need not be the subject: replicas can apply locally authorized CRDT changes, retain an invocation log, and gossip provenance. By contrast, a system wrapped around an ACL or other ambient authority remains compatible but has a larger attack surface and part of its authorization semantics outside UCAN. The recommended case is an agent holding a unique resource reference in an end-to-end capability system.

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.

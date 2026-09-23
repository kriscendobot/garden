---
title: Deadline-Based (Ephemeral) Retention
source: doc/design/gc-and-retention.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: The in-memory ephemeral-retention regime, used for secure-transport sessions and temporary blocks. There is no notion of roots or reachability; retention is purely time-based — each entry carries a **deadline** (Unix nanoseconds) and is evicted once `now_ns >= deadline_ns`. To make "next to expire" cheap, a **min-heap keyed by deadline** keeps the smallest-deadline element at the top; eviction pops from the heap while the top is expired and deletes from the backing store. This is the same pattern as `recvbuffer` (which already indexes by deadline and priority and exposes `MinDeadline`) and the `cask/tempstore` collector (a min-heap of hashes by deadline). Eviction runs either on demand (when adding to a full store) or periodically (a goroutine that sleeps until the minimum deadline). Secure-transport session state — keys, counters, deadline — lives here, as do scratch/staging blocks needed only briefly.

## Goal

Retain blocks (or session state, etc.) only until a **deadline** (e.g. Unix ns). After the deadline, they are evicted. No notion of "roots" or reachability; retention is purely time-based.

## Backing store and heap

This regime is **in-memory** (or a dedicated ephemeral store), not the on-disk CAS used for pinned content:

- **Store**: e.g. memstore or a small key-value store keyed by hash (or session id). Blocks or records have an associated **deadline** (Unix ns).
- **Eviction**: When we need to free space or on a timer, we evict entries whose deadline has passed. To make "next to expire" cheap, we keep a **min-heap keyed by deadline**: the element with the smallest deadline is at the top. We evict by repeatedly popping from the heap until the top's deadline is in the future.

This is the same idea as:

- **recvbuffer** — already indexes by deadline (and priority). A min-heap on deadline makes "pop minimum deadline" O(log n); `MinDeadline` (or equivalent) gives the next expiry, and we can evict in batch by popping until `now_ns >= deadline_ns`.
- **cask/tempstore collector** — uses a min-heap of hashes by deadline and evicts expired entries from the in-memory cells.

So the **ephemeral system** uses an in-memory (or fast) store for the actual data; maintains a **heap** (min on deadline) using the same pattern as recvbuffer or the tempstore collector, registering each stored entity with a deadline and updating the heap (FixUp/FixDown) when lifetime is added or extended; and evicts either on demand (when putting a new entity and the store is full) or periodically (a goroutine that wakes on the minimum deadline and evicts until now). Eviction = pop from heap while top is expired, delete from store. No hash-trie and no reachability; only "deadline + heap" for efficient expiry.

## Use cases

- **Secure transport sessions**: Session state (keys, counters, deadline) lives in this ephemeral store. When `now_ns >= deadline_ns`, the session is evicted. The heap gives the next session to expire so we can sleep until then or batch-evict.
- **Temporary blocks**: Blocks needed only for a short time (e.g. scratch, staging) can be stored in the same in-memory store with a deadline; they are evicted when the deadline passes.

Source: [doc/design/gc-and-retention.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/gc-and-retention.md) at commit `cdb975d8`.

---
title: Why Eventual Send?
source: packages/eventual-send/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
---

> Abstract: Four reasons: (1) Uniform API: same code messages local and remote objects with no syntactic change. (2) Message Ordering: E() preserves causal order across the boundary. (3) Pipeline Optimization: avoids round-trip costs. (4) Future-Proof Code: code written with E() works against any handled-promise-aware runtime, including future distributed systems that don't exist yet.

## Why Eventual Send?

Eventual send provides four key benefits:

### 1. Uniform API

The same code works whether the target is local or remote:

```javascript
// This code works identically whether counter is:
// - A local object
// - In a different vat on the same machine
// - On a different machine across the network
const result = await E(counter).increment(5);
```

Write local code, deploy distributed, no changes needed.

### 2. Message Ordering

Messages to the same target are delivered and processed in send order:

```javascript
E(counter).increment(1);  // executed first
E(counter).increment(2);  // executed second
E(counter).increment(3);  // executed third
// Order is guaranteed
```

This simplifies reasoning about concurrency.

### 3. Pipeline Optimization

As shown above, eliminates round trips in distributed systems.

### 4. Future-Proof Code

Code written with `E()` works locally today and distributed tomorrow:

```javascript
// Works in development (local)
const result = await E(service).getData();

// Same code works in production (distributed)
// No changes needed when service moves to another vat/machine
```


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.

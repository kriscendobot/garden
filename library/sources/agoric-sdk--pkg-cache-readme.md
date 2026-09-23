---
source: packages/cache/README.md
source_repo: agoric/agoric-sdk
source_commit: 1fa31b00d031479481c30158286404ffd8a4ebed
source_date: 2022-08-10
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
section_count: 3
status: current
notes: The cache is built on the same store + coordinator pattern that appears in zoe (StoredPublishKit) and notifier (Coordinator interface for eventual consistency with optimistic updates). The guard-pattern + updater-function approach is a CAS-style transactional update — retries on stale read. Cross-cuts with patterns (M.any() etc.) and pass-style (cache keys + values must be Passable).
---

> Abstract: `@agoric/cache` is a cache mechanism that synchronizes a client function with a cache backend. Any Passable object can be a cache key or value. Three sections: overview + demo (single comprehensive example showing direct value, match-and-set, one-time-init, guard-pattern-update), cache-client API (`cache(key, updater, guardPattern?)` and the transactional retry semantics), cache-coordinator interface (the Coordinator interface supporting eventual consistency with optimistic updates: getRecentValue, setCacheValue, updateCacheValue).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-demo](../sections/agoric-sdk--pkg-cache-readme--overview-and-demo.md) | tooling, capability-security | current |
| [cache-client](../sections/agoric-sdk--pkg-cache-readme--cache-client.md) | tooling, patterns | current |
| [cache-coordinator](../sections/agoric-sdk--pkg-cache-readme--cache-coordinator.md) | tooling, pass-style | current |

## Source

[packages/cache/README.md](https://github.com/Agoric/agoric-sdk/blob/1fa31b00d031479481c30158286404ffd8a4ebed/packages/cache/README.md) at commit `1fa31b00`.

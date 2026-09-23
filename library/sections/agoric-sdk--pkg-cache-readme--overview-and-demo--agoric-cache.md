---
title: Agoric Cache
source: packages/cache/README.md
source_repo: agoric/agoric-sdk
source_commit: 1fa31b00d031479481c30158286404ffd8a4ebed
source_date: 2022-08-10
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, capability-security]
status: current
notes: The demo's four patterns (direct value, match-and-set, one-time-init, guard-pattern-update) are the core API surface in worked-example form. `M.any()` from `@agoric/store` is the no-guard match-anything pattern. Note that there's no way to distinguish a set value of undefined from an unset key — the ground state is always undefined.
parent: agoric-sdk--pkg-cache-readme--overview-and-demo
---

This cache mechanism allows a cache client function to synchronize with a cache backend. Any passable object can be a cache key or a cache value.

Source: [packages/cache/README.md](https://github.com/Agoric/agoric-sdk/blob/1fa31b00d031479481c30158286404ffd8a4ebed/packages/cache/README.md) at commit `1fa31b00`.

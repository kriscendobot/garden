---
title: Agoric Cache (overview + demo)
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
kind: index
section_count: 2
---

> Abstract: The cache lets a client function synchronize with a cache backend. Any Passable value can be a key or value. The worked demo shows: direct value get/set (`cache('baz')` to get, `cache('baz', 'value')` to set); match-and-set (3rd arg is the guard pattern — only set if current matches); one-time-init (second call returns the original since the guard implicitly requires undefined); updater function (`cache(key, updater, M.any())` with a function `(oldValue) => newValue` and any-match guard).

Sections:

- [Agoric Cache](agoric-sdk--pkg-cache-readme--overview-and-demo--agoric-cache.md)
- [Demo](agoric-sdk--pkg-cache-readme--overview-and-demo--demo.md)

Source: [packages/cache/README.md](https://github.com/Agoric/agoric-sdk/blob/1fa31b00d031479481c30158286404ffd8a4ebed/packages/cache/README.md) at commit `1fa31b00`.

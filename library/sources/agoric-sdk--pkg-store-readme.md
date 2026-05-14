---
source: packages/store/README.md
source_repo: agoric/agoric-sdk
source_commit: 7d4729735e3ce04b146f8982e6b537e86546bc8b
source_date: 2024-01-27
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
section_count: 1
status: current
notes: The README opens with `# TODO REWRITE` — explicit author flag that the documentation is incomplete. Like base-zone, this package is destined for migration to `@endo/store`. Cross-cuts with base-zone (both migrating together) and with exo (Stores hold Exo instances).
---

> Abstract: `@agoric/store` is a wrapper around JavaScript Map adding two things: an `init` vs `set` distinction that makes the intent clear (init = new key, set = update existing), and a functional-API style where `Store.get` can be passed around standalone (Map's methods are tied to their instance and can't be mapped over an array). Headed for migration to `@endo/store`. Header carries an explicit `# TODO REWRITE`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-store-readme--overview.md) | exo, capability-security | current |

## Source

[packages/store/README.md](https://github.com/Agoric/agoric-sdk/blob/7d4729735e3ce04b146f8982e6b537e86546bc8b/packages/store/README.md) at commit `7d472973`.

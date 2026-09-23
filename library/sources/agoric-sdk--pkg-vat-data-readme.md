---
source: packages/vat-data/README.md
source_repo: agoric/agoric-sdk
source_commit: 31d74ec8e861efc48db473fd9b68820e4c0e3d55
source_date: 2023-01-29
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
section_count: 2
status: current
notes: Vat-data is the Exo+persistence-zone-glue package that surfaces `prepareExo`, `prepareExoClass`, etc. for use within vat code. Two sections: the overview (vat / zone / turn / crank definitions, kinds-must-be-defined-first invariant) and the Tips section (synchronous-makers gotcha for converting async makers). Cross-cuts with endo--pkg-exo-readme--* and agoric-sdk--pkg-zoe-readme--upgrade.
---

> Abstract: `@agoric/vat-data` is the in-vat surface for persistence-aware Exo construction. Wraps the @endo/exo `prepare*` family with zone-awareness (heap/virtual/durable). Two sections: (1) overview defining vat / zone / turn / crank and the kinds-must-be-defined-in-first-crank invariant; (2) Tips section explaining why durable-kind maker functions must be synchronous (converting from async makers requires ensuring all data is available without await in the vat's `prepare`).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-vat-data-readme--overview.md) | exo, capability-security | current |
| [tips-synchronous-makers](../sections/agoric-sdk--pkg-vat-data-readme--tips-synchronous-makers.md) | exo, capability-security | current |

## Cross-references

- The "kinds must be defined in the first crank" rule is the same invariant captured in `agoric-sdk--pkg-zoe-readme--upgrade` (the four-requirement contract).
- `prepareExo` / `prepareExoClass` come from `@endo/exo`; see `endo--pkg-exo-docs-exo-taxonomy--*` for the `make*` vs `define*` vs `prepare*` distinction.

## Source

[packages/vat-data/README.md](https://github.com/Agoric/agoric-sdk/blob/31d74ec8e861efc48db473fd9b68820e4c0e3d55/packages/vat-data/README.md) at commit `31d74ec8`.

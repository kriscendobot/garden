---
title: Added/Changed by HardenedJS summary
source: docs/reference.md
source_repo: endojs/endo
source_commit: bffadcab8a39be8529406b22574e25cf64dec755
source_date: 2026-04-26
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
---

> Abstract: Inventory of what SES adds or modifies: introduces global Compartment class, replaces Error to hide stacks in-band, replaces console with the causal console, adds assert globals, freezes and makes non-configurable various primordials. Companion to the removed-summary section above.

## Added/Changed by HardenedJS summary

HardenedJS adds the following to JavaScript or changes them significantly:
- `lockdown()`
- `harden()`
- `Compartment`
- `console`
- `assert`
- Shared JavaScript primordials are frozen.


Source: [docs/reference.md](https://github.com/endojs/endo/blob/bffadcab8a39be8529406b22574e25cf64dec755/docs/reference.md) at commit `bffadcab`.

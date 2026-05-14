---
title: How passable objects should prepare
source: packages/ses/docs/preparing-for-stabilize.md
source_repo: endojs/endo
source_commit: 07ff084c87af4e567f6bf4f5e331742be94b6587
source_date: 2025-01-18
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, pass-style, persistence]
status: current
---

> Abstract: Specific guidance for code that constructs passable objects (copyArrays, copyRecords, Far-built remotables): how the new integrity-trait will affect these and what to change ahead of time.

## How passable objects should prepare

Although we think of `passStyleOf` as requiring its input to be hardened, `passStyleOf` instead checked that each relevant object is frozen. Manually freezing all objects reachable from a root object had been equivalent to hardening that root object. With these changes, even such manual transitive freezing will not make an object passable. To prepare for these changes, use `harden` explicitly instead.

Source: [packages/ses/docs/preparing-for-stabilize.md](https://github.com/endojs/endo/blob/07ff084c87af4e567f6bf4f5e331742be94b6587/packages/ses/docs/preparing-for-stabilize.md) at commit `07ff084c`.

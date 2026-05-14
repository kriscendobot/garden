---
title: Loopback
source: packages/captp/README.md
source_repo: endojs/endo
source_commit: 1b767034b305
source_date: 2022-01-13
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [captp]
status: current
---

> Abstract: How CapTP connects to itself in-process: a loopback pair lets two halves of a system communicate via CapTP semantics without an actual transport. Used for testing and for in-process vat isolation.

## Loopback

The `makeLoopback()` function creates an async barrier between "near" and "far"
objects.  This is useful for testing and isolation within the same address
space.


Source: [packages/captp/README.md](https://github.com/endojs/endo/blob/1b767034b305/packages/captp/README.md) at commit `1b767034`.

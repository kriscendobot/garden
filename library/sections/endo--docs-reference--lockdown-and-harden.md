---
title: lockdown() and harden()
source: docs/reference.md
source_repo: endojs/endo
source_commit: bffadcab8a39be8529406b22574e25cf64dec755
source_date: 2026-04-26
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: superseded
superseded_by: endo--docs-guide--api-overview
superseded_on: 2026-05-14
superseded_reason: Cluster B consolidation (per the cycle-15 review and the cycle-30 maintainer-discretion mandate). The guide's api-overview consolidates the lockdown()/harden() relationship with more context; this short standalone reference adds no information beyond the consolidated view.
---

> Abstract: How the two main SES verbs relate: lockdown() is one-time program-wide setup that freezes built-ins and installs the causal console; harden() is a per-value operation that transitively freezes an object graph. lockdown() is called once; harden() is called many times throughout program life. Without lockdown(), harden() works but does not benefit from frozen built-ins.

## `lockdown()` and `harden()`

`lockdown()` and `harden()` do the same thing; freeze objects so their
properties cannot be changed. You can only interact with frozen objects through
their methods. Their differences are what objects you use them on, and when you use them.

`lockdown()` **must** be called first. It hardens JavaScript's built-in *primordials*
(implicitly shared global objects) and enables `harden()`. Calling `harden()`
before `lockdown()` executes throws an error.

`lockdown()` works on objects created by the JavaScript language itself as part of
its definition. Use `harden()` to freeze objects created by your JavaScript code
after `lockdown()`was called.


Source: [docs/reference.md](https://github.com/endojs/endo/blob/bffadcab8a39be8529406b22574e25cf64dec755/docs/reference.md) at commit `bffadcab`.

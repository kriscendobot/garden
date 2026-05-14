---
title: repairIntrinsics(options) API
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
superseded_reason: Cluster B consolidation (per the cycle-15 review and the cycle-30 maintainer-discretion mandate). The guide's api-overview consolidates all four API verbs with more context; this short standalone reference adds no information beyond the consolidated view.
---

> Abstract: Signature and semantics of repairIntrinsics(): the first phase of lockdown(), which patches built-in objects to remove non-SES-conforming behaviors but does not freeze them. Used directly when an application wants to delay freezing (install monkey-patches between repair and harden) while still wanting SES-style built-in behavior.

## `repairIntrinsics(options)`

`repairIntrinsics()` *tames* some objects, such as:
- Regular expressions
  - A tamed RexExp does not have the deprecated compile method.
- Locale methods
  - Lockdown replaces locale methods like `String.prototype.localeCompare()` with lexical
    versions that do not reveal the user locale.
- Errors
  - A tamed error does not have a V8 stack, but the console can still see the stack.


Source: [docs/reference.md](https://github.com/endojs/endo/blob/bffadcab8a39be8529406b22574e25cf64dec755/docs/reference.md) at commit `bffadcab`.

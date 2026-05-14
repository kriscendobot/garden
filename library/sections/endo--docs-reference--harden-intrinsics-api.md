---
title: hardenIntrinsics() API
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

> Abstract: Signature and semantics of hardenIntrinsics(): the second phase of lockdown(), which transitively freezes built-in objects after repair. Calling it twice is a no-op. Useful in the delayed-freeze scenarios where repairIntrinsics() is called separately.

## `hardenIntrinsics()`

`hardenIntrinsics()` tamper-proofs all of the JavaScript intrinsics, so no
program can subvert their methods (preventing some man in the middle attacks).
Also, no program can use them to pass notes to parties that haven't been
expressly introduced (preventing some covert communication channels).

`hardenIntrinsics()` *freezes* all JavaScript defined objects accessible to any program in the realm. The frozen
accessible objects include but are not limited to:
- `[].__proto__` the array prototype, equivalent to `Array.prototype` in a pristine JavaScript environment.
- `{}.__proto__` the `Object.prototype`
- `(() => {}).__proto__` the `Function.prototype`
- `(async () => {}).__proto__` the prototype of all asynchronous functions, and has no alias
   in the global scope of a pristine JavaScript environment.
- The properties of any accessible object


Source: [docs/reference.md](https://github.com/endojs/endo/blob/bffadcab8a39be8529406b22574e25cf64dec755/docs/reference.md) at commit `bffadcab`.

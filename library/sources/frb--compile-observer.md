---
source: compile-observer.js
source_repo: kriskowal/frb
source_commit: 2162ce7cb574f1b5aed1cf8118c1548de8b85d70
source_date: 2013-07-31
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: `compile-observer.js` is the `frb/compile-observer` module: the visitor that turns a parsed syntax tree into the root of the compiled observer function-tree ([[frb-compiled-observer-tree]]). It is the source behind the README's one-sentence "visits the syntax tree and creates functions for each node." Two sections cover it: the ~50-entry `compilers` dispatch table plus the leaf/record special-casing in `compile()`, and the open-world fallback that lets any unrecognized node type become a method observer and auto-registers every `operators.js` export (including the non-enumerable `toString` special case the author flags as "a special Hell for non-enumerable inheritance"). The takeaway the README omits: the expressible-node set is the *union* of the explicit table, every operator, and every method name, not a closed list.

| Section | Topics | Status |
|---------|--------|--------|
| [compilers-table-and-visitor](../sections/frb--compile-observer--compilers-table-and-visitor.md) | reactive-bindings | current |
| [open-world-method-and-operator-fallback](../sections/frb--compile-observer--open-world-method-and-operator-fallback.md) | reactive-bindings | current |

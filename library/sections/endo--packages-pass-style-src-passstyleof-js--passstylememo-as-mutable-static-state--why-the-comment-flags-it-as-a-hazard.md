---
title: Why the comment flags it as a hazard
source: packages/pass-style/src/passStyleOf.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "101-144"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why passStyleOf carries a WeakMap memo (asymptotic correctness for nested copyRecord walks), why the comment flags it as mutable static state, and how the inProgress Set complements the memo to catch cyclic structures during the recursive walk"
ingested: 2026-05-28
ingested_by: scholar
topics: [pass-style, marshal, capability-security, hardened-javascript]
status: current
parent: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state
---

The comment names two distinct hazard classes:

1. **Mutable static state.** The memo is module-scoped (or
   factory-scoped via `makePassStyleOf`) and outlives any single
   call. In Table 1 of Structure of Authority 2004 (the canonical
   source for [[security-as-extreme-modularity]]), "Avoid global
   variables → Forbid mutable static state" is the strict reading
   that capability discipline raises from best-practice to
   invariant. `passStyleMemo` is therefore exactly the kind of
   construct the discipline forbids — kept here only because the
   alternative is unworkable performance and because the value the
   map stores (a pass-style string label) is purely derived from
   the input. The comment's TODO is not idle: it asks whether the
   *observability* of the memo creates a communications channel
   even granting that the stored data is derived.

2. **Proxy observability.** A `WeakMap.get(proxy)` lookup is
   observable to the proxy's handler (the proxy receives no trap
   for it, but the implementation may have side effects in the
   property-access path of subsequent operations on the same
   proxy). A proxy that has been classified once by `passStyleOf`
   may be able to *detect* that classification, which is a *static
   communications channel* between any two parties that share a
   reference to the proxy. The TODO names this as unassessed; no
   work has yet established whether the channel is exploitable or
   how to close it short of removing the memo (and accepting the
   quadratic cost).

The hazard note is therefore a **deliberate breach** of Table 1's
"forbid mutable static state" row, recorded with an explicit
unresolved-question marker so future security review remembers
to address it.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L101-L144) at commit `e56bf00f`.

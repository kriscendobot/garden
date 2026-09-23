---
title: Why a Set, not a WeakSet
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

The comment names the choice explicitly: "Even when a WeakSet is
correct, when the set has a shorter lifetime than its keys, we
prefer a Set due to expected implementation tradeoffs." WeakSet
implementations carry per-entry overhead (the ephemeron table,
the GC interaction) that pays off only when the set outlives some
of its keys and the implementation can reclaim them. A set whose
lifetime is bounded by a single function call has no keys to
reclaim; the WeakSet's overhead is pure cost. A plain `Set` is
faster on construction and on add/delete/has, which dominates
because the cycle-detection set is exercised on every recursive
descent.

The same reasoning would apply to any short-lived collection in
marshal-adjacent code. The comment is local to `inProgress` but
the pattern (short-lived bookkeeping uses Set/Map; long-lived
weak-keyed bookkeeping uses WeakSet/WeakMap) is general enough to
inform reviews of other passable-traversing code.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L101-L144) at commit `e56bf00f`.

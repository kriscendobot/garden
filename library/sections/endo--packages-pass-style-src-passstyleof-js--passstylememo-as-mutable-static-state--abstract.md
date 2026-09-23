---
title: Abstract
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

`passStyleOf` does a *full recursive walk* of every pass-by-copy
structure it classifies, in order to validate acyclicity and reject
unfrozen / non-passable members. Without memoization, algorithms
that walk the same passable twice (and many do, since `passStyleOf`
is the entry point for marshal serialization, patterns matching,
exo argument validation, and ad-hoc isPassable checks) would be
O(N²) or worse on shared sub-structure. The `passStyleMemo`
`WeakMap` collapses that to amortized O(N) by caching the classified
pass style of every successfully-walked passable. The longform
comment surrounding the memo declaration is the canonical source
for three claims the surrounding code rests on: (1) the cache is
*purely* for performance (correctness does not depend on it), (2)
it is **mutable static state** in the sense Table 1 of Structure
of Authority forbids and therefore deserves a hazard note, and
(3) the per-call `inProgress` Set is the *correctness* mechanism
for cycle detection, kept separate from the memo precisely because
its lifetime is one classification call rather than the lifetime
of the realm.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L101-L144) at commit `e56bf00f`.

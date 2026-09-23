---
title: The comment as written
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

Lines 101-114 in the captured commit, on the `passStyleMemo`
declaration inside `makePassStyleOf`:

> Purely for performance. However it is mutable static state, and
> it does have some observability on proxies. TODO need to assess
> whether this creates a static communications channel.
>
> passStyleOf does a full recursive walk of pass-by-copy
> structures, in order to validate that they are acyclic. In addition
> it is used by other algorithms to recursively walk these pass-by-copy
> structures, so without this cache, these algorithms could be
> O(N**2) or worse.

Lines 121-124, on the `inProgress` Set inside the per-call closure:

> Even when a WeakSet is correct, when the set has a shorter lifetime
> than its keys, we prefer a Set due to expected implementation
> tradeoffs.

The two notes together name the three-mechanism design: a
realm-lifetime memo for performance, a call-lifetime set for cycle
detection, and a separation rationale (the call-lifetime set is a
Set rather than a WeakSet because its lifetime is bounded and
WeakSet performance for short-lived keys is a poor fit).

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L101-L144) at commit `e56bf00f`.

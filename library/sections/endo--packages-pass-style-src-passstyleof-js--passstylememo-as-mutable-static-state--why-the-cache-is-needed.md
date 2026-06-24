---
title: Why the cache is needed
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

`passStyleOf` is the most-called classifier in marshal-touching
code. Three call patterns drive the amortized cost:

- **`assertPassable(val)`** walks the entire value to throw on the
  first non-passable. Marshal calls this on every value crossing a
  serialization boundary.
- **`passStyleOf(val)` followed by a second walk** by patterns
  matching, `harden`-time validation, or exo argument coercion. Two
  walks of the same structure without a cache is the simplest path
  to quadratic cost when the structure shares sub-trees.
- **`isPassable(val)`** wraps `passStyleOf` in a try/catch. Code that
  guards with `isPassable` and then proceeds to use the value via
  another `passStyleOf`-using path pays for two walks of the same
  value.

The memo eliminates the second-walk cost in all three cases. A
classified passable is recognized on every subsequent walk in
O(1).

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L101-L144) at commit `e56bf00f`.

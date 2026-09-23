---
title: Implications
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

- **The static-channel TODO is real review material.** A future
  pass over the pass-style implementation should attempt to either
  (a) prove the channel is not exploitable given how
  `passStyleMemo` is encapsulated inside `makePassStyleOf` (the
  memo is not externally reachable; only the `passStyleOf`
  function holding it is), or (b) propose a closure (e.g., the
  classifier could refuse to memoize proxies, paying the
  quadratic cost only for the subset of inputs that pose the
  hazard). Either resolution would close one of Table 1's
  open forbidden-mutable-static-state breaches in the Endo
  codebase.
- **The cache's correctness depends on `passStyleOf` being
  deterministic.** A value's pass-style is computed from its
  properties; if those properties can change after classification
  (e.g., a proxy whose handler returns different values on
  successive accesses), the cache returns a stale answer. The
  invariant the code relies on is that *passable* values are
  frozen (`isFrozen` is checked on object branches), so legitimate
  passables cannot change. Proxies that pass the `isFrozen` check
  but mutate their handler-returned values are a known marshal
  hazard; the memo amplifies the consequence (one mis-classification
  is cached for the realm lifetime).
- **Reviewers of marshal changes should not assume the cache is
  invisible.** Adding a new pass style, or changing the helper
  table's classification order, must consider that values
  classified under the old order may already be in the memo of
  a long-running realm. The memo is *factory-scoped* (per
  `makePassStyleOf` invocation), which scopes the hazard to the
  lifetime of one marshal instance — typically a realm or
  compartment.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L101-L144) at commit `e56bf00f`.

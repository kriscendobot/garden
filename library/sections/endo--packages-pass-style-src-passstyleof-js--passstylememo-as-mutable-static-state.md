---
title: passStyleMemo as mutable static state — the cache, the cycle-detection guard, and the proxy-observability hazard
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
---

## Abstract

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

## The comment as written

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

## Why the cache is needed

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

## Why the comment flags it as a hazard

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

## The inProgress Set as the correctness companion

Without the memo, every recursive call of `passStyleOf` would
detect cycles by maintaining a "currently being walked" set on the
call stack. The memo's lifetime is too long for that role: a value
appearing in the memo means it was *successfully* classified, not
that it is *currently being* classified. The `inProgress` Set is
constructed fresh per `passStyleOf` call, populated during the
recursive descent, and reset to empty before the function returns.
Its semantics:

- On entry to `passStyleOfRecur(inner)`: if `inner` is non-primitive
  and already in `passStyleMemo`, return the cached style without
  recursing or marking `inProgress`.
- If `inner` is non-primitive and not in the memo: assert
  `!inProgress.has(inner)` (a cycle would put us back at a value
  we have already started but not finished classifying) and add
  `inner` to `inProgress` before descending.
- On return from `passStyleOfInternal(inner)`: write the style into
  `passStyleMemo` and delete `inner` from `inProgress`.

This separation is what lets the memo store only *successfully
classified* values. A cyclic structure caught mid-walk would
otherwise leave a half-classified entry in the memo, corrupting
future calls. The two-table arrangement (long-lived memo for
successful classifications, short-lived set for in-progress
detection) is the standard pattern for recursive memoization with
cycle detection.

## Why a Set, not a WeakSet

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

## Implications

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

## See also

- [[security-as-extreme-modularity]] — Structure of Authority's
  Table 1 names "forbid mutable static state" as the strict
  reading of "avoid global variables." `passStyleMemo` is a
  worked example of a *recorded* breach: the discipline names
  it, the comment surfaces the hazard, and a TODO marker
  ensures future review cannot forget the cost.
- [[principle-of-least-authority]] — the static-channel hazard
  is a POLA-at-the-temporal-dimension question. The memo's
  observability grants *any* party that holds a proxy reference
  the authority to detect prior classification, which is more
  authority than the classifier was asked to grant.
- [`endo--pkg-pass-style-readme--passstyleof`](endo--pkg-pass-style-readme--passstyleof.md)
  — the user-facing description of `passStyleOf`; this section
  is the internal data-structure rationale that the README
  intentionally hides.
- [`endo--pkg-pass-style-doc-copyrecord-guarantees--overview`](endo--pkg-pass-style-doc-copyrecord-guarantees--overview.md)
  — the frozen-and-string-keyed guarantees that make the
  memo's determinism assumption sound for legitimate passables.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L101-L144) at commit `e56bf00f`.

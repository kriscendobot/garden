---
title: How the hazard interacts with the memo
source: packages/pass-style/src/passStyleOf.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "219-245"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why pass-style exports the globalThis-installed passStyleOf when present (liveslots delegation), how the install-on-global gate stands in for explicit authorization, and the GC-detection hazard the delegated implementation must preserve determinism to avoid"
ingested: 2026-05-28
ingested_by: scholar
topics: [pass-style, marshal, capability-security, persistence]
status: current
parent: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism
---

The default `passStyleOf` returned by `makePassStyleOf` is the one
documented in [`endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state`](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state.md):
it carries a `passStyleMemo` `WeakMap` cache. A delegated
liveslots `passStyleOf` may or may not carry its own cache. The
determinism requirement is *separate* from the caching question:

- A non-caching deterministic classifier returns the same answer
  on repeated calls because its classification function is pure.
- A caching deterministic classifier returns the same answer
  *because* it remembered the first answer. The cache is a
  determinism mechanism rather than a hazard.
- A non-deterministic classifier (caching or not) leaks the
  determining state. The hazard.

The TODO on `passStyleMemo` (the static-channel question from the
sibling section) and this hazard on the delegated classifier are
*aligned*: both ask whether the classifier's observable behavior
is over-narrow relative to the input value. The pass-style
package's discipline is to make the classifier *purely a function
of the input value's properties*, and to require any substitute
classifier to honor the same discipline.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L219-L245) at commit `e56bf00f`.

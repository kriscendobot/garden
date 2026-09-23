---
title: §The `confirmCanBeValid` minimal check vs the `assertRestValid` thorough check
source-slug: endo--packages-pass-style-src-byteArray-js
section-slug: ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/byteArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/byteArray.js
source-author: Endo project (collective)
total-lines: 68
ingest-cycle: 260
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline
---

Lines 53–55:
```js
confirmCanBeValid: (candidate, reject) =>
  (candidate instanceof ArrayBuffer && candidate.immutable) ||
  (reject && reject`Immutable ArrayBuffer expected: ${candidate}`),
```

§The-PassStyleHelper-protocol's-two-phase-validation (per the cycle 249 sibling page on the helpers cluster):

- §**Phase-1 `confirmCanBeValid`** — *minimal* check: just enough to decide whether THIS helper is the right one for the candidate. The candidate is an `ArrayBuffer` and has `.immutable === true`. §the-minimal-check-uses-instanceof-not-strict-prototype-equality — because at this phase we're answering *"is this an ArrayBuffer at all, of any subclass?"* not *"does it satisfy our canonical-prototype rule?"*. §the-thorough-check-tightens-the-criteria-in-phase-2.
- §**Phase-2 `assertRestValid`** — *thorough* check: now that we've committed to this helper, validate the canonical-prototype rule, the immutability via captured getter, and the no-own-properties rule.

§Two-phase-progressive-tightening — §phase-1-uses-instanceof-as-a-loose-shape-question + §phase-2-uses-strict-equality-as-a-tight-canonical-question; §the-two-questions-have-different-purposes-so-different-strictness; §sibling pattern to the PassStyleHelper cluster's broader two-phase shape.

§The-`reject &&` short-circuit on line 55 — when `reject` is not passed (the helper is being asked "are you the right one?" without diagnostic ambition), the helper just returns true-or-false; when `reject` IS passed (the helper is being asked "and if not, tell us why"), it formats the rejection. §the-reject-callback-pattern-from-the-helpers-cluster.

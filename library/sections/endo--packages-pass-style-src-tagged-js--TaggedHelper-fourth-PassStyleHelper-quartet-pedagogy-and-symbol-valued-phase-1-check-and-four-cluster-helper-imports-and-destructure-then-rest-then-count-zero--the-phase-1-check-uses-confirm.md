---
title: §The phase-1 check uses confirmPassStyle — a symbol-marker check
source-slug: endo--packages-pass-style-src-tagged-js
section-slug: TaggedHelper-fourth-PassStyleHelper-quartet-pedagogy-and-symbol-valued-phase-1-check-and-four-cluster-helper-imports-and-destructure-then-rest-then-count-zero
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/tagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/tagged.js
source-author: Endo project (collective)
total-lines: 49
ingest-cycle: 268
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-tagged-js--TaggedHelper-fourth-PassStyleHelper-quartet-pedagogy-and-symbol-valued-phase-1-check-and-four-cluster-helper-imports-and-destructure-then-rest-then-count-zero
---

Line 24-25:
```js
confirmCanBeValid: (candidate, reject) =>
  confirmPassStyle(candidate, candidate[PASS_STYLE], 'tagged', reject),
```

§The-phase-1-tactic is §pass-the-candidate's-own-PASS_STYLE-value-and-the-expected-style-name. Three operands of `confirmPassStyle`:
1. **The candidate** — the value being validated.
2. **`candidate[PASS_STYLE]`** — what the candidate claims it is.
3. **`'tagged'`** — what we want it to be.

§The-symbol-marker-check is §the-helper-asks-"do-you-claim-to-be-tagged?" — §if-the-candidate-says-yes-AND-the-claim-is-honestly-`tagged`-not-some-other-style, §the-phase-1-passes; §otherwise-the-phase-1-fails-and-reject-fires.

§The-symbol-IS-the-marker — §sibling-pattern to JS's Symbol.toStringTag conventions; §the-PASS_STYLE-symbol-IS-not-the-same-symbol-as-Symbol.toStringTag-but-they-coexist-on-tagged-records.

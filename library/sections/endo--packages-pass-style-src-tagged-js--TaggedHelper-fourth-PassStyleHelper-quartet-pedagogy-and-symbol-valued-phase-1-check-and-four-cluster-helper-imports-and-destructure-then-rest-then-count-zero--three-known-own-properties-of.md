---
title: §Three known own properties of a tagged record
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

Lines 33-37 enumerate the three known properties:

1. **`PASS_STYLE` symbol** with value `'tagged'` — the cluster discriminator.
2. **`Symbol.toStringTag`** — the developer-visible string label (per JS conventions).
3. **`payload`** — the wrapped value (validated via `passStyleOfRecur` at line 45).

§First-explicit-observation in library: **§tagged-records-have-three-named-own-properties (PASS_STYLE + Symbol.toStringTag + payload) — §the-pattern-IS-canonical-for-extending-the-marshal-protocol-with-new-sub-styles**.

§Symbol.toStringTag IS the §developer-visible-string-label — §when-you-`console.log`-a-tagged-record, §its-Symbol.toStringTag-determines-the-prefix; §the-cluster-uses-this-for-runtime-debugging.

§The-`payload`-property-name-IS-canonical — §sibling-pattern to many wrapper-types in JS (e.g., `value`-properties on iterators); §the-tagged-helper-fixes-`payload`-as-the-wrapped-value-key.

---
title: §Three named exports — predicate + asserter + extended-asserter
source-slug: endo--packages-pass-style-src-string-js
section-slug: isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/string.js
source-repo: endojs/endo
source-path: packages/pass-style/src/string.js
source-author: Endo project (collective)
total-lines: 83
ingest-cycle: 272
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan
---

Lines 23, 52, 79 carry three exports:

1. **`isWellFormedString(str): str is string`** — the predicate (returns boolean; narrows type).
2. **`assertWellFormedString(str): asserts str is string`** — the asserter (throws if not).
3. **`assertPassableString(str): asserts str is string`** — the extended asserter (uses env-option to decide whether to check well-formed).

§First-explicit-observation in library: **§three-named-exports-as-predicate-asserter-extended-asserter — §the-cluster's-canonical-discipline-from-cycle-150's-typeGuards.js's-predicate-assertion-pairs (predicate + asserter); §here-extended-with-an-extended-asserter-that-uses-a-runtime-flag**.

§Sibling-pattern to cycle 150's typeGuards.js four-predicate-assertion-pairs; §the-cluster's-canonical-shape (predicate + asserter) extended here with §a-third-asserter-with-runtime-toggle.

§`asserts str is string` — TypeScript narrowing predicate via JSDoc. §sibling-pattern to many @endo/* asserters.

§All-three-exports-IS-`hideAndHardenFunction`-wrapped (lines 43, 55, 83) — §the-cluster's-canonical-wrap-discipline; §three-times-in-83-lines.

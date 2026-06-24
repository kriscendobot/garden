---
title: §Borrowable patterns
source-slug: endo--packages-promise-kit-src-is-promise-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/is-promise.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/is-promise.js
total-lines: 12
ingest-cycle: 252
ingest-date: 2026-06-09
lane: chat
parent: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines
---

**Tier-1 (highest borrowing value):**

- §`Promise.resolve(x) === x`-as-canonical-promise-detection.
- §The-`Promise.resolve`-trick-IS-the-defense-against-malicious-thenables.
- §Canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose (sibling to cycle 243's typed-array-aliasing for endianness detection).
- §`unknown`-plus-type-predicate-narrowing-as-detection-function-type-discipline.
- §`@returns {x is T}`-type-predicate-narrowing for runtime-checks bound to static-types.
- §`harden(exportName)`-immediately-after-declaration as named SES discipline.
- §`harden` imported from `@endo/harden` not from a global — package-portability discipline.
- §`maybe<TargetType>`-as-named-parameter-naming-convention-for-detection-functions.

**Tier-2 (file-shape patterns):**

- §Twelve-lines-as-a-complete-promise-detection-utility.
- §Single-export-named-the-same-as-the-purpose.
- §The-file-name-and-the-export-name-converge.
- §The-file-does-one-thing-exhaustively.

**Tier-3 (named comparisons):**

- §Two-cycles-with-canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose (243 + 252).
- §Two-cycles-with-named-defense-against-substrate-confusion-attacks (249 + 252).
- §Two-cycles-with-named-TypeScript-discipline-around-validation (249 + 252).
- §Two-cycles-with-named-identifier-encodes-the-discipline (247 + 252).

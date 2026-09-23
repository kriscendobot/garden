---
title: §The named criticism of `String.prototype.isWellFormed`
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

Lines 10-19:
> *Unfortunately, the [standard built-in `String.prototype.isWellFormed`](https://github.com/tc39/proposal-is-usv-string) does a ToString on its input, causing it to judge non-strings to be well-formed strings if they coerce to a well-formed strings. This recapitulates the mistake in having the global `isNaN` coerce its inputs, causing it to judge non-string to be NaN if they coerce to NaN.*
>
> *This `isWellFormedString` function only judges well-formed strings to be well-formed strings. For all non-strings it returns false.*

§First-explicit-observation in library: **§named-criticism-of-a-standard-method-as-design-justification — §the-design-explicitly-criticizes-the-standard-built-in-API-by-name + §names-a-named-sibling-mistake (the global `isNaN` coercing its inputs) + §the-criticism-IS-the-design-justification**.

§Two-named-sibling-mistakes-in-the-criticism:
1. **`String.prototype.isWellFormed`** — does ToString; judges non-strings as well-formed.
2. **Global `isNaN`** — judges non-strings as NaN if they coerce to NaN.

§First-explicit-observation in library: **§two-named-existing-API-mistakes-as-paired-design-justification — §the-design-doesn't-just-criticize-the-current-API + §it-names-a-second-API-that-makes-the-same-class-of-mistake + §the-pair-IS-the-rhetorical-force-of-the-criticism**.

§"Unfortunately, the standard built-in..." — §named-pejorative-as-design-tone; §the-author-acknowledges-the-API-IS-standard-AND-the-author-IS-unhappy-with-the-design; §sibling-pattern to many `@endo/*` files that criticize standard APIs (e.g., cycle 245's panic-cluster on `eval` shadowing).

§the-fix-IS-trivial-AND-rhetorically-amplified — `typeof str === 'string' && str.isWellFormed()` adds one type-check before the method call, but the design takes ten lines of prose to explain why this matters.

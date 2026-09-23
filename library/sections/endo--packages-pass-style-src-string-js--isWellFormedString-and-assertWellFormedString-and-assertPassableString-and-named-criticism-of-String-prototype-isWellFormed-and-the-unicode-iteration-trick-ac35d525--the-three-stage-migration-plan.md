---
title: §The three-stage migration plan named explicitly
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

Lines 62-74:
> *Currently, `ONLY_WELL_FORMED_STRINGS_PASSABLE` defaults to `'disabled'` because we do not yet know the performance impact. Later, if we decide we can afford it, we'll **first** change the default to `'enabled'` and **ultimately** remove the switch altogether. Be prepared for these changes.*
>
> *TODO once the switch is removed, simplify `assertPassableString` to simply be `assertWellFormedString`.*

§Three-stage-migration-plan:
1. **Stage 1 (current)** — default `disabled`; performance impact unknown; users can opt in.
2. **Stage 2 (future)** — default `enabled`; the switch still exists but is rarely changed.
3. **Stage 3 (eventual)** — switch removed; `assertPassableString` simplifies to `assertWellFormedString`.

§First-explicit-observation in library: **§the-three-stage-migration-plan-named-explicitly-in-prose-doc-comment — §the-author-names-the-three-stages-of-an-API-evolution-in-the-source-code + §the-stages-IS-temporal-not-spatial + §the-TODO-IS-anchored-to-the-final-stage**.

§"Be prepared for these changes" — §named-future-change-warning-in-prose-doc-comment; §the-warning-IS-explicit-not-implicit; §first-explicit-observation in library of §named-future-change-warning-as-design-tone.

§The-author-uses-"first... ultimately"-as-the-temporal-sequencing — §two-named-temporal-markers + §the-prose-encodes-the-migration-graph; §sibling-pattern to roadmap-as-prose conventions.

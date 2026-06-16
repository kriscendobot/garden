---
title: §The generic typedef encodes both tag and payload types
source-slug: endo--packages-pass-style-src-makeTagged-js
section-slug: the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/makeTagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/makeTagged.js
source-author: Endo project (collective)
total-lines: 31
ingest-cycle: 270
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
---

Lines 12-18 carry a parametric typedef:
```js
/**
 * @template {string} T
 * @template {Passable} P
 * @param {T} tag
 * @param {P} payload
 * @returns {CopyTagged<T,P>}
 */
```

§Two-template-parameters:
- **`T extends string`** — the tag's literal string type.
- **`P extends Passable`** — the payload's passable type.

§The-return-type-IS-`CopyTagged<T,P>` — §the-returned-type-encodes-BOTH-the-tag-and-the-payload + §the-TypeScript-narrowing-distinguishes `CopyTagged<'foo', number>` from `CopyTagged<'bar', string>`.

§First-explicit-observation in library: **§two-template-parameters-with-`Passable`-as-constraint-and-`CopyTagged<T,P>`-as-parameterized-return-type — §the-narrowed-return-type-encodes-both-the-tag's-literal-and-the-payload's-passable-shape**.

§sibling-pattern to cycle 264's `PassStyle` string-literal-union narrowing — §narrow-types-at-the-type-system-boundary-not-just-at-the-runtime-boundary.

---
title: §Two-typedef-via-`@import` at the file head
source-slug: endo--packages-pass-style-src-internal-types-js
section-slug: the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/internal-types.js
source-repo: endojs/endo
source-path: packages/pass-style/src/internal-types.js
source-author: Endo project (collective)
total-lines: 30
ingest-cycle: 266
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient
---

Lines 3-6:
```js
/**
 * @import {Rejector} from '@endo/errors/rejector.js';
 * @import {PassStyle} from './types.js';
 */
```

§The-`@import`-block-IS-the-types-only-imports-list (cycle 264 sibling). §two-cross-module-typedef-references:
- §`Rejector` from `@endo/errors/rejector.js` — the rejecter-callback type (sibling to cycle 264's same import).
- §`PassStyle` from `./types.js` — the public `PassStyle` string-literal-union (sibling-module).

§The-internal-types.js-file-imports-the-public-types.js — §the-internal-types-DEPEND-on-the-public-types-not-the-other-way-around; §the-public-types-ARE-stable + §the-internal-types-evolve-faster; §sibling-pattern to many internal-types.h conventions in C/C++ projects.

§First-explicit-observation in library: **§the-internal-types-file-depends-on-the-public-types-not-the-other-way-around — §when-a-package-has-both-internal-and-public-type-files, §the-public-IS-stable-and-the-internal-evolves-faster**.

---
title: §Imports + destructuring at the top
source-slug: endo--packages-pass-style-src-copyArray-js
section-slug: CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyArray.js
source-author: Endo project (collective)
total-lines: 38
ingest-cycle: 262
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
---

Lines 1-7:

```js
import harden from '@endo/harden';
import { Fail, X } from '@endo/errors';
import { confirmOwnDataDescriptor } from './passStyle-helpers.js';

const { getPrototypeOf } = Object;
const { ownKeys } = Reflect;
const { isArray, prototype: arrayPrototype } = Array;
```

§Three-named-import-styles in seven lines:

1. **§Default import** — `harden` from `@endo/harden` (cycle 254/258 sibling — the canonical lockdown vocabulary).
2. **§Named imports** — `{ Fail, X }` from `@endo/errors` (the structured-errors vocabulary).
3. **§Sibling-module import** — `confirmOwnDataDescriptor` from `./passStyle-helpers.js` (the cluster's shared helpers — referenced by name not by namespace).

§Three-named-destructurings of platform intrinsics:

- `const { getPrototypeOf } = Object;` — §canonical-prototype-walker (matches byteArray's line 8).
- `const { ownKeys } = Reflect;` — §all-own-keys-including-symbols-and-non-enumerable (matches byteArray's line 9).
- `const { isArray, prototype: arrayPrototype } = Array;` — §two-destructurings-from-one-source-with-rename — `Array.prototype` becomes `arrayPrototype` for readability + `Array.isArray` becomes `isArray` without rename.

§The-rename-of-`prototype`-to-`arrayPrototype` — §destructuring-with-rename-when-the-source-name-is-too-generic; §sibling-pattern to cycle 260's destructuring of Object/Reflect (those don't need rename because the source method names are specific); §the-rename-IS-the-readability-fix-for-a-source-name-too-generic-for-the-local-scope; §first-explicit-observation in library of §destructuring-with-rename-when-source-name-is-too-generic.

§Five-cycles-with-named-import-isolation-via-destructuring (242 elevator + 254 no-shim + 258 curated-re-export + 260 byteArray + 262 copyArray) — §discipline-now-canonical-across-five-cycles.

§Sibling-module-import-by-named-function — `confirmOwnDataDescriptor` is the cluster's §shared-helper-imported-by-name; §each-PassStyleHelper-can-call-into-shared-validation-logic-without-re-implementing-it; §first-explicit-observation in library of §shared-validation-helper-imported-by-name-into-each-PassStyleHelper.

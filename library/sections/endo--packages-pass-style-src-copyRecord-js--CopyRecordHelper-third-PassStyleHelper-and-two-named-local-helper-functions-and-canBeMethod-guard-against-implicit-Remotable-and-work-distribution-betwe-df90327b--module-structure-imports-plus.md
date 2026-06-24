---
title: §Module structure — imports plus two named local helper functions plus the helper export
source-slug: endo--packages-pass-style-src-copyRecord-js
section-slug: CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyRecord.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyRecord.js
source-author: Endo project (collective)
total-lines: 70
ingest-cycle: 264
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
---

Lines 1-12:
```js
import harden from '@endo/harden';
import { Fail } from '@endo/errors';
import { confirmOwnDataDescriptor } from './passStyle-helpers.js';
import { canBeMethod } from './remotable.js';

/**
 * @import {Rejector} from '@endo/errors/rejector.js';
 * @import {PassStyleHelper} from './internal-types.js';
 */

const { ownKeys } = Reflect;
const { getPrototypeOf, prototype: objectPrototype } = Object;
```

§The-three-concerns-template (cycle 260's named pattern) takes a new variation: lines 14-41 introduce **two named local helper functions** between the imports and the named-helper-export. The shape is now:

1. **§Imports + destructuring** (lines 1-12).
2. **§Two named local helper functions** (lines 14-41): `confirmObjectPrototype` + `confirmPropertyCanBeValid`.
3. **§Named-helper-export** (lines 43-70): `CopyRecordHelper`.

§First-explicit-observation in library: **§the-three-concerns-template-with-named-local-helpers-extracted — §when-confirmCanBeValid-needs-multiple-checks, §extract-each-check-into-a-named-local-function + §the-function-name-IS-the-check's-pass-style-discipline**.

§Sibling-pattern to cycle 142's pass-style helpers cluster: helpers cluster carries `confirmOwnDataDescriptor`; copyRecord carries `confirmObjectPrototype` and `confirmPropertyCanBeValid`. §the-`confirm`-prefix-IS-the-naming-convention for the predicate-with-rejecter shape; §all-three-named-local-helpers-share-the-prefix.

§Three-cycles-with-named-import-of-sibling-module-cluster-helper (260 + 262 + 264; each imports something from `./passStyle-helpers.js`); §the-discipline-is-canonical-across-the-cluster.

§Four-named-imports-in-copyRecord — `harden` (default) + `Fail` (named from @endo/errors) + `confirmOwnDataDescriptor` (named from sibling `./passStyle-helpers.js`) + `canBeMethod` (named from sibling `./remotable.js`); §the-fourth-import-is-the-cross-helper-cluster-disambiguation — copyRecord must consult the remotable cluster to know what a method looks like; §first-explicit-observation in library of §cross-helper-cluster-disambiguation-import-when-one-pass-style-must-distinguish-itself-from-another.

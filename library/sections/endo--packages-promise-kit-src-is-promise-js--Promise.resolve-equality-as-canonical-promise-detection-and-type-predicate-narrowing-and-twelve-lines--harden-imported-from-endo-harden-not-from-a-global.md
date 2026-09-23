---
title: §`harden` imported from `@endo/harden` not from a global
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

```js
import harden from '@endo/harden';
```

§The-`harden`-function-is-imported-as-a-default-from-`@endo/harden` + §not-relied-upon-as-a-global. §The-Endo-package-structure-IS-the-source-of-`harden` — §the-package-can-run-in-environments-where-SES-lockdown-hasn't-yet-installed-`harden`-as-a-global + §the-package's-tests-can-run-without-needing-SES.

§Sibling-pattern-to-cycle-242's-the-elevator-module — §two-cycles-with-explicit-platform-or-substrate-bridge-via-import: §cycle-242-platform-import-via-elevator-module + §cycle-252-`harden`-import-via-`@endo/harden`. §Two-different-shapes-of-explicit-import-rather-than-relying-on-the-ambient-global.

§First-explicit-observation in library of §`harden`-imported-from-`@endo/harden`-not-from-a-global as named package-portability discipline.

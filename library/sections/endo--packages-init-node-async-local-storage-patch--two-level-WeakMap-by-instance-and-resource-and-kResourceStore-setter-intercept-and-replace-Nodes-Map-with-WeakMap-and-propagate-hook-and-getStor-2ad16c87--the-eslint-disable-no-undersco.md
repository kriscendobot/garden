---
title: §The-eslint-disable-no-underscore-dangle
source-slug: endo--packages-init-node-async-local-storage-patch
section-id: two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStore-undefined-when-disabled
url: https://github.com/endojs/endo/blob/master/packages/init/src/node-async-local-storage-patch.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/init/src/node-async-local-storage-patch.js
total-lines: 98
status: shipping
ingest-cycle: 233
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStore-undefined-when-disabled
---

```js
/* eslint-disable no-underscore-dangle */
```

§File-level-disable for the `_propagate` + `_enable` underscore-prefixed names. §Borrowable-pattern: §when-a-design-must-honor-a-platform's-internal-API-naming, §disable-the-linter-rule-at-the-file-level + §the-comment-IS-the-justification.

§Sibling to cycle 223 @endo/module-source's §`__double-underscore__`-private-names-convention + §eslint-disable-no-underscore-dangle (cycle 223 uses double-underscores for SES compartment internal contract; cycle 233 honors Node's single-underscore convention).

§Three-cycles-with-underscore-prefix-naming-and-eslint-disable: cycle 217 @endo/errors' `__HIDE_` prefix + cycle 223 @endo/module-source's `__double-underscore__` SES contract + cycle 233 node-async-local-storage-patch's `_propagate`/`_enable` Node convention.

§Three-different-underscore-conventions:
- Cycle 217: §`__HIDE_<name>` (double-prefix marker).
- Cycle 223: §`__name__` (double-underscore-wrap, SES internal contract).
- Cycle 233: §`_name` (single-underscore-prefix, Node internal API).

§The-pattern: §each-substrate-has-its-own-underscore-convention-that-the-honoring-code-must-match.

---
title: §Three-cycles-with-underscore-prefix-naming-and-eslint-disable
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

| Cycle | Source | Convention |
|-------|--------|-----------|
| 217 | @endo/errors | §`__HIDE_<name>` (double-prefix marker for stack-trace censoring) |
| 223 | @endo/module-source | §`__name__` (double-underscore-wrap, SES Compartment internal contract) |
| 233 | @endo/init/node-async-local-storage-patch | §`_name` (single-underscore-prefix, Node internal API) |

§Three-different-underscore-conventions for §three-different-substrates. §The-pattern: §each-substrate-has-its-own-underscore-convention.

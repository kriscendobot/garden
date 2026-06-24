---
title: §Sixth-instance of Reflect.apply-as-the-defensive-uncurry
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

| Cycle | Source | Use |
|-------|--------|-----|
| 199 | trampoline-memoize-nat | `bind.bind(bind.call)` shape |
| 207 | env-options | Reflect.apply |
| 211 | @endo/common | `Function.prototype.call.bind` |
| 215 | @endo/hex | Reflect.apply for native intrinsic dispatch |
| 227 | pass-style/byteArray | Reflect.apply for immutableGetter |
| 233 | node-async-local-storage-patch | Reflect.apply for callback invocation |

§Six-different-instances of the same canonical defensive-uncurry discipline.

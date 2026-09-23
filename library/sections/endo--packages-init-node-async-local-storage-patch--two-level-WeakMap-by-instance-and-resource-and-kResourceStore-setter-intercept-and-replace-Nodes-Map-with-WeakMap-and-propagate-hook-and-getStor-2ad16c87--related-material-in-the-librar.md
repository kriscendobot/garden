---
title: Related material in the library
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

- **cycle 225 node-async_hooks.js**: §sibling-substrate-patch — both files patch Node's async-hooks layer; cycle 225 handles per-promise tracking symbols; cycle 233 handles the AsyncLocalStorage class.
- **cycle 219 @endo/ses-ava + cycle 225 node-async_hooks**: §three-cycles-with-pre-instantiation-or-pre-lockdown-property-installation (cycle 233 is the third).
- **cycle 215 @endo/hex + cycle 222 endoclaw-skill-registry + cycle 233**: §three-cycles-on-fast-path-when-input-matches-current-state.
- **cycle 231 encodeToCapData + cycle 233**: §two-cycles-on-`Object.is`-for-SameValue-semantics (cycle 231 normalizes `-0` to `0`; cycle 233 uses `Object.is` for store comparison).
- **cycle 217 @endo/errors + cycle 223 @endo/module-source + cycle 233**: §three-cycles-with-underscore-prefix-naming-and-eslint-disable; §three-different-underscore-conventions.
- **cycle 199 + 207 + 211 + 215 + 227 + 233**: §sixth-instance of §Reflect.apply-as-the-defensive-uncurry.
- **cycle 229 marshal-justin + cycle 231 encodeToCapData + cycle 233**: §three-cycles-with-try-finally-swap-and-restore for closure-state-mutation.

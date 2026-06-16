---
title: §Capture-Reflect.apply-once-at-module-load — the fourth canonical uncurry shape
source-slug: endo--packages-hex
section-id: ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic
url: https://github.com/endojs/endo/blob/master/packages/hex/src/
authors: [Endo contributors]
repo: endojs/endo
path: packages/hex/src/
status: shipping
ingest-cycle: 215
ingest-date: 2026-06-07
lane: chat
parent: endo--packages-hex--ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic
---

```js
const { apply } = Reflect;
// ...
bytes => apply(nativeToHex, bytes, [])
```

This adds a fourth concrete instance to the §three-canonical-uncurry-shapes-in-endo lineage:

| Cycle | Source | Shape |
| --- | --- | --- |
| 199 | trampoline-memoize-nat trio | `bind.bind(bind.call)` |
| 207 | env-options | `Reflect.apply` |
| 211 | @endo/common | `Function.prototype.call.bind` |
| 215 | @endo/hex | `Reflect.apply` (revisit) |

The comment is explicit about why `Reflect.apply` is preferred to `Function.prototype.call` here, even where `.call` is "assumed to be primordial":

> a tampered `Function.prototype.call` cannot redirect the dispatched native intrinsic invocation.

§Reflect.apply-as-the-defensive-uncurry-against-Function.prototype.call-tampering.

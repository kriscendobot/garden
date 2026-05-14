---
title: Vat Sources (buildRootObject + Liveslots + Remotables)
source: packages/SwingSet/README.md
source_repo: agoric/agoric-sdk
source_commit: 7d95438c0888b5f7e903e258013d30b66f2458cf
source_date: 2025-10-25
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, capability-security, exo]
status: current
notes: Liveslots is the standard high-level layer; the `enableSetup: true` + `managerType: "local"` escape hatch is for cases where Liveslots' lifecycle doesn't fit. The Root Object pattern (Remotable returned by `buildRootObject`) is the canonical entry-point convention for a Vat.
---

> Abstract: Each Vat source file (`vat-foo.js` / `vat-bar.js`) is the starting point of a bundling process that converts the Vat's source tree into a single string (so it can be evaluated in a SES realm). The source file exports a `buildRootObject` function returning a Vat "root object" managed by Liveslots — non-local imports are not yet allowed. Bypass option: `enableSetup: true` + `managerType: "local"` lets a Vat export a default `setup` function that receives `syscall` directly and returns `dispatch`. Liveslots provides `helpers.makeLiveSlots(syscall, state, buildRootObject, helpers.vatID)` to build `dispatch` from `syscall` for the standard case. The Root Object becomes available to the Bootstrap Vat.

## Vat Sources

Each Vat source file (like `vat-foo.js` or `vat-bar.js`) is treated as a starting point for a bundling process that converts the Vat's source tree into a single string (so it can be evaluated in a SES realm). This starting point can use `import` to reference shared local files. No non-local imports are allowed yet.

The source file is expected to export a `buildRootObject` function that returns a Vat "root object" managed by [Liveslots](../swingset-liveslots) with which other vats can interact. It is also possible to bypass the "Live Slots" layer when the vat options include `enableSetup: true` and are associated with a `managerType` that supports such bypass (currently limited to "local"), by exporting a default function named "setup" to be invoked with a `syscall` object and expected to return a `dispatch` object (see [BaseVatOptions](./src/types-external.js)).

The "Live Slots" layer provides a function to build `dispatch` out of `syscall`, as well as a way to register the root object. This requires a few lines of boilerplate in the `setup` function.

```js
function buildRootObject(E) {
  return harden({
    callRight(arg1, right) {
      console.log(`left.callRight ${arg1}`);
      E(right)
        .bar(2)
        .then(a => console.log(`left.then ${a}`));
      return 3;
    },
  });
}

export default function setup(syscall, state, helpers) {
  const dispatch = helpers.makeLiveSlots(syscall, state, buildRootObject, helpers.vatID);
  return dispatch;
}
```

### Exposed (pass-by-presence) Objects

The Live Slots system enables delivery of inbound messages to local "[Remotable](https://docs.agoric.com/guides/js-programming/far#pass-styles-and-harden)" objects.

### Root Objects

The "Root Object" is a Remotable object returned by `buildRootObject()`. It will be made available to the Bootstrap Vat.

Source: [packages/SwingSet/README.md](https://github.com/Agoric/agoric-sdk/blob/7d95438c0888b5f7e903e258013d30b66f2458cf/packages/SwingSet/README.md) at commit `7d95438c`.

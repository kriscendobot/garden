---
title: §virtualT-proxy via §defineProperty-with-getter-setter-delegation
source-slug: endo--packages-ses-ava
section-id: registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
url: https://github.com/endojs/endo/tree/master/packages/ses-ava
authors: [Endo contributors]
repo: endojs/endo
path: packages/ses-ava/src/{ses-ava-test.js, command.js, reexport-ava.js}
status: shipping
ingest-cycle: 219
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-ses-ava--registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
---

The §virtualT-proxy mirrors `originalT` but replaces `log` and `console` with the SES-aware variants:

```js
const virtualT = {
  log: causalConsole.error,
  console: causalConsole,
};
// Mirror properties from originalT and its prototype onto virtualT
const originalProto = getPrototypeOf(originalT);
const descs = {
  ...getOwnPropertyDescriptors(originalProto),
  ...getOwnPropertyDescriptors(originalT),
};
for (const [name, desc] of entries(descs)) {
  if (!(name in virtualT)) {
    if ('get' in desc) {
      defineProperty(virtualT, name, {
        ...desc,
        get() { return originalT[name]; },
        set(newVal) { originalT[name] = newVal; },
      });
    } else if (typeof desc.value === 'function') {
      defineProperty(virtualT, name, {
        ...desc,
        value(...args) { return originalT[name](...args); },
      });
    } else {
      defineProperty(virtualT, name, desc);
    }
  }
}
```

§Three-kinds-of-property-handling:
1. §Accessor-property (has `get`): forward both getter (read) and setter (write) to originalT.
2. §Function-value-property: forward the call to originalT (preserves §`this`-binding-via-forward-call).
3. §Data-property: copy descriptor directly (data properties don't need forwarding).

§Borrowable-pattern: §proxy-via-defineProperty-not-via-Proxy when §the-shape-of-the-original-is-known + §the-substitution-is-only-on-named-properties. §Cheaper-than-a-real-Proxy; §preserves-the-shape-of-the-original-with-named-substitutions.

§Spread-prototype-descriptors-first-so-own-properties-override is the §getOwnPropertyDescriptors(originalProto) before getOwnPropertyDescriptors(originalT) sequence in the `descs` construction. §Borrowable-pattern: §the-order-of-spread-determines-precedence (`{...A, ...B}` means B wins on collision).

§Skip-if-already-defined (`if (!(name in virtualT))`) preserves the §replaced-log-and-console.

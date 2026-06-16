---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §makeFar / makeNear via §makeRefMaker closure factory
parent: endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
---

```js
const makeRefMaker =
  refGetter =>
  async x => {
    lastNonce += 1;
    const myNonce = lastNonce;
    const val = await x;
    nonceToRef.set(myNonce, harden(val));
    return E(refGetter).getRef(myNonce);
  };

return {
  makeFar: makeRefMaker(farGetter),
  makeNear: makeRefMaker(nearGetter),
  // ...
};
```

The §two-callers-one-pattern-via-closure discipline:
`makeFar` and `makeNear` differ only in *which bootstrap they
ask*. `makeRefMaker` captures the bootstrap and returns the
per-call function.

The §uniform-async-shape: both `makeFar` and `makeNear` are
*async*, even though only `makeFar` truly *needs* to be (you
might think `makeNear` could be synchronous since it just
hands back its own ref). But the round-trip through `E(refGetter).
getRef(...)` is *eventual* in both cases — the §uniform-shape-
even-when-asymmetry-is-tempting discipline.

The §harden-the-value-before-set: `nonceToRef.set(myNonce,
harden(val))`. The value is hardened *immediately* on the
near side so the §far side cannot affect mutability across
the loopback (it shouldn't be able to anyway, but defense-in-
depth).

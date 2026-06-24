---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: Membrane via marshal with mirror converters and revocation by undefining the mineToYours WeakMap
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

> *// We use mineIf rather than mine so that mine is not
> accessible after revocation. This gives the correct error
> behavior, but may not actually enable mine to be gc'ed,
> depending on the JS engine.*
>
> — `packages/marshal/src/dot-membrane.js` §remotable case

`dot-membrane.js` (164 lines, Turadg Aleahmad-last-touched
2026-04-24 in commit `ec42cb7b`) is the *full membrane*
implementation that exports `makeDotMembraneKit(target) →
{proxy, revoke}`. The structural surprise: the membrane is
built by *running marshal twice* (once each direction). Marshal's
serialize / unserialize pair *is* the membrane-crossing
mechanism.

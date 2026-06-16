---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
title: The §three-types-copied-from-@agoric/internal TODO
parent: endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
---

The opening §JSDoc has *three* identical TODOs:

> *Currently copied from @agoric/internal utils.js.*
> *TODO Should migrate here and then, if needed, reexported
> there.*

Applied to three type definitions: `Simplify`, `Callable`,
`DeeplyAwaitedObject`. The §canonical-home-yet-to-be-resolved
discipline: the types are *currently duplicated*; the design
intent is to *move them here* and let agoric/internal re-export
them (the §upside-down-dependency observation that
@endo/pass-style is *more foundational* than
@agoric/internal).

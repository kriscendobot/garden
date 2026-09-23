---
section: legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
source: endo--packages-patterns-src-patterns-getGuardPayloads-js
topics: [patterns, exo]
status: current
title: Legacy guard-tolerance and payload extraction at three granularities with method-key introspection
parent: endo--packages-patterns-src-patterns-getGuardPayloads-js--legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
---

> *The get*GuardPayload functions exist to adapt to the worlds both
> before and after PR #1712. When given something that would be the
> expected guard in either world, it returns a *GuardPayload that is
> valid in the current world. Thus it helps new consumers of these
> guards cope with old code that would construct and send these
> guards.*
>
> — `packages/patterns/src/patterns/getGuardPayloads.js` lines 25-30

`getGuardPayloads.js` (300 lines, Turadg Aleahmad-last-touched
2026-03-26 in commit `ef97f83`) is the *legacy-guard-tolerance
adapter layer* that cycle 118's exo-tools.js defendPrototype
imports `getInterfaceGuardPayload` from. The whole file solves *one
problem at three granularities*: extract the typed payload from a
guard that might be in either the pre-1712 *`klass:`-discriminator
record* shape or the post-1712 *`payload:` envelope* shape.

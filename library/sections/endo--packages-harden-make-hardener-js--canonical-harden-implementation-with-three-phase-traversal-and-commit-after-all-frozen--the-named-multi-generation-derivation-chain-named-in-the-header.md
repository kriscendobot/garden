---
title: §the-named-multi-generation-derivation-chain-named-in-the-header
source: endo--packages-harden-make-hardener-js
url: https://github.com/endojs/endo/blob/master/packages/harden/make-hardener.js
authors: [Kris Kowal, Mark S. Miller, Google Caja contributors, Agoric contributors]
repo: endojs/endo
path: packages/harden/make-hardener.js
total-lines: 471
ingest-cycle: 338
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-canonical-harden-implementation
  - the-named-three-phase-traversal-with-named-commit-after-all-frozen
  - the-named-enqueue-dequeue-commit-algorithm
  - the-named-mark-hardened-only-after-all-frozen-discipline
  - the-named-transactional-harden-discipline
  - the-named-multi-generation-derivation-chain-named-in-the-header
  - the-named-four-stage-attribution-chain
  - the-named-FERAL-prefix-naming-convention
  - the-named-feral-error-with-named-reason
  - the-named-V8-error-own-stack-accessor-repair
  - the-named-platform-specific-repair-with-named-error-code
  - the-named-platform-detection-at-factory-time-not-per-call
  - the-named-platform-conditional-fast-path-vs-slow-path
  - the-named-acknowledged-and-bounded-hazard
  - the-named-triple-duplication-with-named-layering-constraint
  - the-named-bulk-destructure-of-globalThis
  - the-named-Safari-bug-workaround-with-named-tracking-URL
  - the-named-error-code-as-stable-URL-anchor
  - the-named-link-rot-acknowledgment-with-archive-URL
  - the-named-fallback-URL-when-canonical-dies
  - the-named-uncurry-this-canonical-idiom
  - the-named-hasOwn-shim-with-named-issue-link
  - the-named-substrate-of-substrates-zero-endo-imports
  - the-named-freezeTypedArray-with-tc39-spec-citation
  - the-named-freeze-before-traversal-defends-against-reactive-objects
  - the-named-getOwnPropertyDescriptors-defends-against-Object.prototype-poisoning
  - the-named-traversePrototypes-as-named-option
  - the-named-canonical-Endo-idiom-named-function-via-object-destructure
  - the-named-streak-resumes-with-ninth-instance
  - twenty-nine-cycles-with-named-pivot-domain-stay
  - sixty-two-citation-arc-closures-in-pivot-now
parent: endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen
---

Lines 1-21:

```
// Adapted from SES/Caja - Copyright (C) 2011 Google Inc.
// Copyright (C) 2018 Agoric

// Licensed under the Apache License, Version 2.0 (the "License");
// ...

// based upon:
// https://github.com/google/caja/blob/master/src/com/google/caja/ses/startSES.js
// https://github.com/google/caja/blob/master/src/com/google/caja/ses/repairES5.js
// then copied from proposal-frozen-realms deep-freeze.js
// then copied from SES/src/bundle/deepFreeze.js
```

**§the-named-multi-generation-derivation-chain-named-in-the-header** — first-explicit-observation as a tier-3 meta-pattern. The header NAMES the four-stage derivation chain:

1. **Stage 1**: Google Caja's `startSES.js` (2011)
2. **Stage 2**: Google Caja's `repairES5.js`
3. **Stage 3**: TC39's `proposal-frozen-realms` `deep-freeze.js`
4. **Stage 4**: SES's `src/bundle/deepFreeze.js`
5. **Stage 5 (current)**: @endo/harden's `make-hardener.js`

**§the-named-four-stage-attribution-chain** — first-explicit-observation. The attribution is not just *"based on prior work"* but enumerates each generation with a clickable URL. Each generation preserved enough of the prior to be cite-able.

**§the-named-attribution-as-historical-record** — first-explicit-observation as a tier-3 meta-pattern. Compare to:
- Cycle 336 memo-race.js's §the-named-public-domain-license-header-preserved-verbatim (Brian Kim 2017 nodejs/node#17469 dedication preserved)
- Cycle 338 make-hardener.js's four-stage attribution chain (Google 2011 → TC39 → SES → @endo)

**§two-shapes-of-attribution-discipline** — verbatim-preserved-dedication (cycle 336) + multi-generation-chain-named-in-header (cycle 338). First-explicit-observation as a tier-3 meta-pattern.

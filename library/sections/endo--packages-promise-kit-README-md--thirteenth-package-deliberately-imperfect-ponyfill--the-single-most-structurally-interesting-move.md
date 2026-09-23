---
title: The single most structurally interesting move
source: endo--packages-promise-kit-README-md
url: https://github.com/endojs/endo/blob/master/packages/promise-kit/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/promise-kit/README.md
total-lines: 71
ingest-cycle: 335
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-deliberately-imperfect-ponyfill
  - the-named-ponyfill-with-named-deliberate-divergence
  - the-named-makePromiseKit-IS-named-canonical-promise-deferred
  - the-named-eventual-send-pipelining-IS-named-accommodation
  - the-named-example-with-both-branches
  - the-named-three-named-returns
  - the-named-multiple-promise-kits-example-shows-composability
  - the-named-License-section-Apache-2.0
  - the-named-six-section-README-shape
  - the-named-Agoric-smart-contract-OR-JavaScript-program
  - twenty-six-cycles-with-named-pivot-domain-stay
  - thirteen-named-packages-in-the-pivot-cluster
  - forty-nine-citation-arc-closures-in-pivot-now
  - two-cycles-with-named-ponyfill-vs-polyfill-distinction
parent: endo--packages-promise-kit-README-md--thirteenth-package-deliberately-imperfect-ponyfill
---

**§the-named-deliberately-imperfect-ponyfill** — line 4 of the README:

> Note that this serves as a "ponyfill" for `Promise.withResolvers`, making certain accommodations to ensure that the resulting promises can pipeline messages through `@endo/eventual-send`.

A *ponyfill* (terminology from cycle 317 @endo/hex README) usually means a *faithful* shim for a not-yet-available native API: exports a function that doesn't mutate globals, providing the same surface as the native version. Cycle 335 introduces a structural variant: **the ponyfill is deliberately imperfect**.

The README acknowledges both:
1. **Identity** — *"serves as a 'ponyfill' for `Promise.withResolvers`"*
2. **Divergence** — *"making certain accommodations to ensure that the resulting promises can pipeline messages through `@endo/eventual-send`"*

**§the-named-ponyfill-with-named-deliberate-divergence** — first-explicit-observation. The pattern is transferable: when a package is *almost* a ponyfill for a standard API but needs behavioral differences, name BOTH the shim relationship AND the divergence. Don't pretend the ponyfill is faithful when it isn't; don't hide the relationship to the standard either.

This is sibling to cycle 317 @endo/hex README's **§the-named-ponyfill-IS-named-precise-over-polyfill** (ponyfill = no global mutation = SES-compatible) but with the *named imperfection* twist added. **§two-cycles-with-named-ponyfill-vs-polyfill-distinction** (317 + 335). The discipline now has two shapes:
- **Faithful ponyfill** (cycle 317 @endo/hex): the ponyfill matches the spec exactly
- **Deliberately imperfect ponyfill** (cycle 335 @endo/promise-kit): the ponyfill deviates from the spec for named integration reasons

§the-named-two-shapes-of-ponyfill-discipline (faithful vs deliberately-imperfect) — first-explicit-observation as a tier-3 meta-pattern.

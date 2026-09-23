---
title: §Pre-lockdown-freeze-as-replacement-for-harden
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

```js
// Successful instantiation of this module must be possible before `lockdown`
// allows `harden(wrapTest)` to function, but `freeze` is a suitable replacement
// because all objects reachable from the result are intrinsics hardened by
// lockdown.
freeze(wrapTest);
```

§The-package-must-load-before-SES-lockdown; §harden-isn't-functional-yet at instantiation; §freeze-is-a-substitute because §all-reachable-objects-are-intrinsics-already-hardened-by-lockdown.

§The-comment-makes-the-load-bearing-invariant-explicit: §why-freeze-is-OK-here — not just "we couldn't harden so we settled" but §a-correctness-argument-about-reachability.

§Borrowable-pattern: §when-instantiation-must-precede-lockdown, §use-`freeze`-with-an-explicit-correctness-argument. §The-correctness-argument-names-which-objects-are-reachable + §why-they-don't-need-additional-hardening (because they'll be hardened by lockdown when lockdown runs).

§Five-cycles-now-using-freeze-not-harden-with-named-correctness-argument:
| Cycle | Source | Reason |
| --- | --- | --- |
| 132 | local.js | eventual-send evaluates before SES lockdown completes |
| 146 | E.js | `freeze` but not `harden` the proxy target so it remains trapping (stabilize-discipline) |
| 154 | trap.js | same as E.js (verbatim-comment-shared-across-derived-files) |
| 199 | trampoline | classic-uncurry-this with pre-lockdown capture |
| 219 | ses-ava | instantiation must precede lockdown; reachable objects are intrinsics |

§Five-different-reasons-for-the-same-mechanism: the §freeze-not-harden-discipline is honored across the library, but the §why differs each time. §This-is-the-honest-shape-of-load-order-constraints — §the-name-of-the-discipline-is-shared, §the-specific-reason-is-source-dependent.

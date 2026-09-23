---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
title: How this file fits the @endo/promise-kit cluster
parent: endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
---

`memo-race.js` is one of four files in `packages/promise-kit/
src/`:

- `is-promise.js` (12 lines) — promise detection.
- `memo-race.js` (this file) — memory-safe race.
- `promise-executor-kit.js` (55 lines) — `makePromiseKit()` /
  `racePromises()` factory pair.
- `types.js` (138 lines) — JSDoc typedefs for ERef, etc.

The package surfaces `makePromiseKit` (cycle 138's safe-
promise.js consumes this) + `memoRace` + `isPromise`. This
file is the *only* one with substantial structural cleverness;
the others are thin.

§Related-but-distinct from cycle 66's `handled-promise.js`:
HandledPromise is the *eventual-send* substrate; memoRace is
*memory hygiene*. Both share the §promise-as-substrate
worldview but operate at different layers.

---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
title: The §load-bearing-bug — §native-Promise.race-memory-leak
parent: endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
---

The §load-bearing observation is named in the JSDoc:

> *Unlike `Promise.race` it cleans up after itself so a
> non-resolved value doesn't hold onto the result promise.*

The §native-Promise.race-memory-leak: when `Promise.race(P1,
P2, P3, ...)` is called, the engine internally attaches
`.then(resolve, reject)` to *every* `Pi`. If `P1` settles
first and `P2`, `P3`, ..., `Pn` *never settle*, then their
attached resolve/reject handlers — which retain references to
the race-result-promise — are *never released*. The
race-result-promise stays alive as long as *any* unresolved
input promise stays alive.

In a long-running session this leaks: every `Promise.race`
ever called pins its result for the lifetime of the longest-
lived input. The §long-lived-promise-pins-races problem.

The fix is to *clean up* — after the race settles, *remove*
the deferred from the still-pending inputs so they no longer
hold the result promise.

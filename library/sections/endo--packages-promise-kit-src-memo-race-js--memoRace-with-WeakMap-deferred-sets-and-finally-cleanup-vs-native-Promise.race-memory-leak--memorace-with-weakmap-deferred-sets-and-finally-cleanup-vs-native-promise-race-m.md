---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
title: "`memoRace` with WeakMap deferred-sets and finally-cleanup vs native `Promise.race` memory leak"
parent: endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
---

> *Unlike `Promise.race` it cleans up after itself so a
> non-resolved value doesn't hold onto the result promise.*
>
> — `packages/promise-kit/src/memo-race.js` line 128

`memo-race.js` (170 lines, single export `memoRace`) is the
@endo/promise-kit *memory-safe-race* primitive. The file's
opening header credits **Brian Kim** ([nodejs/node#17469
comment](https://github.com/nodejs/node/issues/17469#issuecomment-685216777),
2017) and dedicates the code to the public domain via the
**Unlicense**. Last-touched 2025-10-09 by Kris Kowal in cycle
108's coordinated-update commit `e56bf00f` (the @endo/harden
migration). Prior touches: Mark S. Miller 2025-06-23
(faster-isObject refactor), Turadg Aleahmad 2024-08-19 / 2022-
09-30 (TypeScript), Mark S. Miller 2022-07-27 (more-hardens).

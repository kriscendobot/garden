---
title: §The TrapGuest / TrapHost callback pair
source-slug: endo--packages-captp-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/captp/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/captp/src/types.js
total-lines: 49
ingest-cycle: 249
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async
---

```js
/**
 * @callback TrapGuest Use out-of-band communications to synchronously return a TrapCompletion
 * @param {TrapRequest} req
 * @returns {TrapCompletion}
 */

/**
 * @callback TrapHost start the process of transferring the Trap request's results
 * @param {TrapCompletion} completion
 * @returns {AsyncIterator<void, void, any> | undefined}
 */
```

§Two-named-callbacks: §TrapGuest (sync return) + §TrapHost (async-iterator return). §The-asymmetry-encodes-the-sync-over-async-mechanism: §the-guest-blocks-waiting-for-the-sync-result + §the-host-streams-the-result-back-via-the-async-iterator + §the-out-of-band-channel-bridges-the-async-host-side-to-the-sync-guest-side.

§First-explicit-observation in library of §out-of-band-communications-as-named-sync-over-async-mechanism. §The-typedef-explicitly-says-`Use out-of-band communications`-IS-the-named-mechanism.

§Two-different-return-types-encode-the-asymmetry: §sync-return-from-TrapGuest + §async-iterator-return-from-TrapHost. §When-a-sync-result-must-be-delivered-from-an-async-source, §encode-the-async-side-as-an-AsyncIterator + §encode-the-sync-side-as-a-synchronous-callback + §the-out-of-band-channel-IS-the-bridge.

§Sibling-pattern-to-cycle-241's-postponed-handler-pattern — §two-different-shapes-of-deferred-resolution: §cycle-241-defers-async-until-a-callback (no-out-of-band) + §cycle-249-makes-an-async-target-look-sync-via-out-of-band (sync-over-async). §Two-cycles-with-deferred-or-sync-bridge-patterns.

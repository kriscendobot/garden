---
title: §TrapCompletion as discriminator-payload tuple
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
 * @typedef {[boolean, import('@endo/marshal').CapData<CapTPSlot>]} TrapCompletion
 *   The head of the pair is the `isRejected` value indicating whether the sync call was an exception,
 *   and tail of the pair is the serialized fulfillment value or rejection reason.
 *   (The fulfillment value is a non-thenable. The rejection reason is normally an error.)
 */
```

§Two-tuple-with-discriminator-and-payload: §`[isRejected, CapData]`. §The-`isRejected`-boolean-IS-the-discriminator + §the-`CapData`-IS-the-serialized-payload. §When-a-sync-result-can-be-either-fulfillment-or-rejection, §encode-it-as-a-discriminated-tuple-not-a-throwing-function-call.

§Why-not-just-throw: §the-discriminator-tuple-can-be-serialized-and-passed-through-an-out-of-band-channel + §throws-can't-cross-the-out-of-band-boundary. §When-the-channel-is-not-a-call-stack, §encode-rejections-as-discriminator-tuples-not-thrown-exceptions.

§Two-named-explicit-constraints: §the-fulfillment-value-is-a-non-thenable + §the-rejection-reason-is-normally-an-error. §The-non-thenable-constraint-IS-the-sync-guarantee — §a-thenable-fulfillment-would-imply-async-resolution-which-Trap-doesn't-support.

§First-explicit-observation in library of §discriminator-payload-tuple as named-sync-result-encoding. §Sibling-pattern-to-cycle-238's-controller-client-cap-split — §two-different-shapes-of-pair-encoding: §two-tuple-of-`[discriminator, payload]` (cycle 249) + §two-tuple-of-`[controller, client]` (cycle 238 mint). §The-pair-shape-IS-the-API + §each-pair-has-a-different-semantic.

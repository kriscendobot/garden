Done. All three deliverables are complete.

## Completion report

**Job:** Answer erights' inline review question on endojs/endo-but-for-bots PR #475 — the `toHex` param annotation (`@param {ArrayBufferView | ArrayBufferLike}`) in `packages/ocapn/src/client/util.js`.

**Re-derived state on clean start:** A prior attempt had already committed `f83e8813d` (narrowing `decodeSwissnum` to `SwissNum`) but had **not** touched `toHex` and had **not** replied in the thread. So the core ask was still open.

**Design decision:** The union was a pre-narrowing leftover. `toHex` is internal to `@endo/ocapn` with no external callers; every value reaching it (session ids, gift ids, peer public-key ids, swissnums) is a branded `Uint8Array` at runtime once byteArray is a plain frozen `Uint8Array`. No caller passes a bare `ArrayBuffer`, so the wide arm bought nothing → narrowed to `Uint8Array`. (Contrast `bytesFromImmutable`, an exported cross-version `@endo/bytes` API that legitimately keeps its `ArrayBufferLike` arm — I left that untouched.)

**Verification-driven scope:** Narrowing `toHex` made `tsc` fail on two `giftId` call sites, so I traced the giftId chain — `randomGiftId` returns a `Uint8Array`; wire giftIds decode as byteArrays (Uint8Array) — and tightened the four annotations that feed `toHex`: `HandoffGive.giftId`, `makeHandoffGiveDescriptor`, `Cryptography.makeSignedHandoffGive`, and the `deposit-gift` param. Also fixed two stale `util.js` comments that still read "SwissNum is ArrayBufferLike at runtime" (it's `Uint8Array` now).

**Changed (all JSDoc annotations/comments, zero runtime change):** `client/util.js`, `client/ocapn.js`, `codecs/descriptors.js`, `cryptography.js` (7 insertions, 7 deletions).

**Verification:** `yarn lint` green — `tsc` exit 0; `eslint` 0 errors (19 pre-existing `no-use-before-define` warnings, present on the base commit, unchanged by this diff). Test leg not run (`ses-ava` is sandbox-blocked here) but is unaffected — the diff is comment/annotation-only.

**Committed & pushed:** `267e98f1d` on `feat/narrow-bytearray-to-uint8` (CAS rebase-push, succeeded).

**Replied to erights** in-thread (reply id `3809460172`, threaded under root `3450553660`, comment id `3807376129`): stated the union was obsoleted by the narrowing, what was narrowed, and why no backward-compat arm is needed here.

**Follow-ups:** none required. Wider `ArrayBufferView | ArrayBufferLike` unions remain on genuinely external-facing public-key-bytes params (`makeOcapnPublicKey`, `remotePublicKeyBytes`, `peerPublicKeyBytes`) — deliberately left, as those accept caller-supplied buffers and are outside this question's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-util-bytearray-view-type.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s) (5 unmetered)
- Input: 82 tokens (2767307 cached reads)
- Output: 23514 tokens
- Cost: $2.6678335 (5 engagement(s) unpriced)
- Wall-clock: 499s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->

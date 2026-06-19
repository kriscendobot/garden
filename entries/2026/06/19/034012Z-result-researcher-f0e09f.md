---
ts: 2026-06-19T03:40:12Z
kind: result
role: researcher
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/19/034012Z-result-researcher-f0e09f.md
---

Cross-org code search for uses of emulated immutable ArrayBuffer that rely on the `byteArray` pass-style. The question came from @erights on PR #473 (endojs/endo-but-for-bots), which extends the byteArray brand check to also accept a `Uint8Array` wrapper on an immutable `ArrayBuffer`.

## Active repos checked

Cutoff: repos pushed within 12 months (after 2025-06-17).

endojs org (8 active repos): endo-but-for-bots, endo, proposal-module-global, ocapn-test-suite, hardenedjs.org, Jessie, playground, proposal-import-hook.

Agoric org (17 active repos): agoric-sdk, agoric-3-proposals, instagoric, dapp-agoric-basics, documentation, xsnap-worker-binaries, mergify-experiements, ui-kit, dapp-econ-gov, clarity-lens, dapp-offer-up, agoric-dev-mcp, agoric-hello-world, dapp-agoric-simple-dao, testnet-load-generator, agoric-subql, causeway.

## Findings

### Yes -- relies on byteArray pass-style

**endojs/endo-but-for-bots** (and identically endojs/endo):

- `packages/pass-style/src/byteArray.js`: the byteArray PassStyleHelper itself -- the brand check, the brand label, and the entry in the helpers array that passStyleOf dispatches through.
- `packages/pass-style/src/passStyleOf.js`: registers the byteArray helper and dispatches to it.
- `packages/pass-style/src/typeGuards.js`: `isByteArray` type guard that checks `passStyleOf(x) === 'byteArray'`.
- `packages/pass-style/src/deeplyFulfilled.js`: handles `byteArray` case (returns as-is, already deeply fulfilled).
- `packages/pass-style/tools/arb-passable.js`: arbitrary-byteArray generator for fast-check tests.
- `packages/marshal/src/encodeToCapData.js`: switch `case 'byteArray'` -- throws "not yet implemented".
- `packages/marshal/src/encodeToSmallcaps.js`: switch `case 'byteArray'` -- throws "not yet implemented".
- `packages/marshal/src/encodePassable.js`: `case 'byteArray'` -- calls `encodeByteArray` (throws not yet implemented).
- `packages/marshal/src/rankOrder.js`: `case 'byteArray'` -- rank ordering implemented.
- `packages/patterns/src/patterns/patternMatchers.js`: `matchByteArrayHelper`, `M.byteArray()` pattern, `getPassStyleCover('byteArray')`.
- `packages/patterns/src/keys/compareKeys.js`: `case 'byteArray'` -- comparison implemented.
- `packages/ocapn/src/codecs/passable.js`: maps `byteArray` passStyle to `BytestringCodec` for OCap-N encoding.
- `packages/ocapn/src/syrup/compare.js`: byteArray comparison for syrup ordering.

**endojs/endo-but-for-bots only** (not yet landed in endojs/endo main):

- `packages/bytes/src/to-immutable.js`: `bytesToImmutable()` wraps a `Uint8Array`'s content in an immutable `ArrayBuffer` via `sliceToImmutable`; the JSDoc explicitly states the result carries the `byteArray` passStyle and is safe to share across vat boundaries. This is an active API used in production paths in the same repo.
- `packages/ocapn/src/netlayers/websocket.js`: uses `bytesToImmutable()` to produce byteArray-passable values for payload, public key, challenge, and message byte sequences (4 call sites).
- `packages/ocapn/src/client/util.js`: uses `bytesToImmutable()` for Swiss-number encoding and raw bytes (2 call sites).
- `packages/ocapn/src/syrup/decode.js`: uses `bytesToImmutable()` when decoding bytestring tokens from the wire.
- `packages/ocapn/src/cryptography.js`: uses `bytesToImmutable()` for hash digests and public key bytes.
- `packages/bytes/src/concat-immutables.js`: `concatImmutables()` combines byteArray-passable buffers.

**Agoric/agoric-sdk**:

- `packages/portfolio-contract/src/evm-wallet-handler.exo.ts` line 165: `case 'byteArray':` in a `passStyleOf` switch -- explicitly treats a byteArray as an atom (PureData) alongside bigint, boolean, null, etc. This is active code on agoric-sdk's master branch as of 2026-06-19. This is a real cross-org caller that relies on byteArray having passStyle `'byteArray'` and being PureData-compatible.

### Touches IAB but does not rely on byteArray pass-style

- `endojs/endo` / `endojs/endo-but-for-bots`, `packages/immutable-arraybuffer/*`: defines the shim/pony for creating immutable ArrayBuffers, but does not call `passStyleOf` or check for `byteArray` style. The IAB package is a lower-level primitive that the pass-style layer builds on.
- `endojs/endo`, `packages/ses/src/permits.js`: permits `transferToImmutable` on `ArrayBuffer.prototype` but does not reference the byteArray passStyle.

### No current usages in Agoric org (beyond agoric-sdk hit above)

No other Agoric repos reference `byteArray` passStyle or `transferToImmutable`.

## Answer to erights's question

Yes, there are current uses. The most significant ones:

1. The entire `@endo/pass-style`, `@endo/marshal`, `@endo/patterns`, and `@endo/ocapn` packages in both endojs/endo and endojs/endo-but-for-bots have active `case 'byteArray'` dispatch, ordering, matching, and encoding paths. These are the canonical in-org consumers.

2. `packages/bytes/src/to-immutable.js` and its call sites in `@endo/ocapn` (endo-but-for-bots only, not yet in endo main) actively produce byteArray-passable values and pass them across boundaries.

3. `Agoric/agoric-sdk`, `packages/portfolio-contract/src/evm-wallet-handler.exo.ts:165`, has a live `case 'byteArray':` arm in a passStyleOf switch that treats byteArray as PureData. This is cross-org, active, and relies on the byteArray passStyle name being stable.

Self-improvement: nothing this time.

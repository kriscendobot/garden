# Design + build a tiered `@endo/hex` codec in endo-but-for-bots

**Repo:** **endojs/endo-but-for-bots** (the bot's Endo fork; bot has direct push).
**HARD SCOPE LINE:** NEVER touch upstream **endojs/endo** — no upstream PR/issue
links, comments, or pushes. All artifacts base+head on the bot fork.

## Motivation

kriscendobot/agoric-sdk#7 carries an XS-safe hex codec in
`packages/internal/src/hex.js` (bounded-loop 484-entry decode table replacing a
`flatMap`+large-array-spread that overflowed the XS metered value stack) plus
Bufferish-vs-portable validation parity. Richard Gibson's review (applied to #7
as feedback) is that **agoric-sdk should need none of this**: the hex codec
belongs in `@endo/hex`, and agoric-sdk should consume it.

## The ask

Create a new `@endo/hex` package in endo-but-for-bots implementing hex
encode/decode with a **tiered implementation strategy**, fastest-available first:

1. **Native `Uint8Array.fromHex` / `Uint8Array.prototype.toHex`** when present
   (the TC39 Uint8Array-base64/hex proposal; already in recent V8/XS). Prefer
   this tier.
2. **`Buffer`** fallback (older Node.js without the native methods).
3. **"map [char-pair]" table** fallback (a per-byte char-pair lookup; this is the
   approach #7 found fastest on XS and is the portable floor). Build the table
   with a **bounded loop**, NOT `flatMap` + large-array spread — that is the
   exact XS metered-value-stack overflow #7 exists to fix
   (`reference_xs_flatmap_spreads_onto_value_stack`; engine fix shipped in
   garden#17 / kriscendobot/moddable#1, but the codec must not rely on it).

Carry #7's correctness pins: odd-length and non-hex input must throw a uniform
error across all tiers (no silent truncation), with cross-tier agreement +
round-trip tests, and uppercase/lowercase/mixed-case acceptance. Validate XS
behavior with the inquisitor / xsnap repro path
(`reference_xsnap_xs_repro_without_agoric_build`).

## Granularity / sequencing

Use judgment — likely a **design** pass first (package shape, the tier-selection
predicate, the public API: `encodeHex`/`decodeHex` or Uint8Array-first), then a
**build**. Once `@endo/hex` exists and is consumable, a follow-on slims
agoric-sdk #7 to depend on it and drop the in-tree `hex.js` codec body (that
slim-down is a separate agoric-sdk-fork job, not part of this one).

Refs: kriscendobot/agoric-sdk#7, kriskowal/garden#9.

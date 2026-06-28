# Benchmark @endo/hex vs the Agoric-internal hex Map accelerator decode (Node.js + XS); report on PR #7

Map: **build** (benchmark + report) on **kriscendobot/agoric-sdk** (BOT FORK — in scope;
this is the maintainer-named concrete target that resolves the earlier "Agoric internal hex"
scope question). NO upstream agoric-sdk action. Work on the fork's PR #7 branch. COMMUNICATE
ON THE PR: post the report as a comment on PR #7
(https://github.com/kriscendobot/agoric-sdk/pull/7), NOT the maintainer inbox (issue/PR comms
directive).

## The claim to test (commit 47b701c, PR #7)
`packages/internal/src/hex.js` builds a **484-entry `decodings` Map** keyed by the hex string
(all four lower/UPPER case permutations of each of 256 bytes) as an "accelerator table" for
"fast lookups when decoding hex strings." Commit 47b701c rebuilt that table with a bounded
`for` loop instead of `encodings.flatMap(...) → new Map(...)` for XS stack safety, but kept the
SAME Map approach. **Empirically test whether the large Map accelerator is actually faster than
the Endo arithmetic approach — on Node and, crucially, on XS.**

## The two approaches
- **Agoric internal:** `packages/internal/src/hex.js` `decodeHex` — Map lookup by 2-char hex
  string key (484 entries; hashing a short string per byte).
- **Endo:** `@endo/hex` — `jsDecodeHex` (in `packages/hex/src/decode.js`) is pure `charCodeAt`
  nibble ARITHMETIC in a bounded `for` loop, NO Map/table. Benchmark `jsDecodeHex` as the
  apples-to-apples JS comparison. Separately NOTE @endo/hex's `decodeHex`, which prefers a
  native `Uint8Array.fromHex` when present (likely on Node, NOT on XS) — report it as a third
  data point where available, but the core comparison is Map vs arithmetic.

## Run on BOTH engines
- **Node.js (V8, JIT):** a proper harness — warmup, many iterations, several input sizes
  (short / medium / large hex strings), and **mixed-case inputs** (lower, UPPER, mixed) to
  actually exercise the Map's 4-permutation reason-for-existing vs Endo's case handling. Report
  ns/op or ops/sec per approach per size.
- **XS (interpreted, metered, no JIT):** run the SAME bench under XS via xsnap. Use the
  prebuilt-xsnap + netstring-driver approach (see memory
  reference_xsnap_xs_repro_without_agoric_build — prebuilt xsnap-worker, ~120-line netstring
  driver, SES via bundle-source endoScript of @endo/init if hardening is needed; no full agoric
  build required). On XS, **report BOTH wall-clock AND the XS metered compute per decode** — on
  the consensus engine the accelerator's value is a METERING question, not just speed, and a big
  string-keyed Map may cost more metered compute (per-lookup string hashing + table footprint)
  than nibble arithmetic.

## Hard constraints
- **AVOID `flatMap` anywhere in the benchmark/harness** — it is the XS metered-stack-overflow
  hazard PR #7 itself fixed. Build any tables/input corpora with bounded `for` loops.
- Fair comparison: identical inputs, identical warmup, time only the decode call; construct the
  input corpus and (for the Agoric path) the Map OUTSIDE the timed loop; account for the Map's
  one-time build cost separately from per-call lookup cost.
- Pin correctness first: assert both approaches decode identically (incl. mixed case) before
  timing, so a "faster" number isn't from a broken decode.

## Deliverable
A committed benchmark on the fork (under an appropriate bench path) + a **report comment on
PR #7** stating, per engine: which approach wins on Node wall-clock, which wins on XS
wall-clock, the **XS metered-cost** comparison, the table build-cost, and a recommendation on
whether the 484-entry Map accelerator is justified — especially on XS (consensus engine) where
arithmetic may beat it on both speed and metered cost. Use the benchmark-comparative-report /
ci-runtime-comparison skills for the report shape (comparative table + methodology + verdict).

---
claim:
  host: endolinbot
  gardener: 37
  claimed_at: 2026-06-28T06:27:03Z

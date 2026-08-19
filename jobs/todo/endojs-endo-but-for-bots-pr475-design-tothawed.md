---
role: designer
dispatch: automatic
posted_by: endojs-endo-but-for-bots-pr475-6bff44d0
tier: mentor
fallback-tier: minion
---
# design the shared `toThawed` byte-thawing helper + benchmark decision (endojs/endo-but-for-bots PR #475)

Maintainer directive (kriskowal), PR #475 comment
https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5334566218 —
answering @kriscendobot's offer to "land the `toMutableUint8` extraction
(concat + to-string) plus the shared predicate." Treat the linked comment body
as the authoritative design intent; re-fetch it if needed.

## What the maintainer decided / asked

1. **Name:** the shared thaw helper is `toThawed` (supersedes the proposed
   `toMutableUint8`). Confirm whether an existing `toThawed`/`thaw` primitive is
   intended to live in `@endo/immutable-arraybuffer` and be imported, or be a new
   small helper in `@endo/bytes/src/`. (As of PR head `2d1200239` no `toThawed`
   symbol exists anywhere in the repo — grep is clean — so this is greenfield
   naming that all the byte packages will share.)
2. **Composition:** `@endo/bytes`, `@endo/hex`, `@endo/base64`, &c should use
   `ArrayBuffer.isView` **and** `toThawed` *in concert* to handle an emulated
   immutable `ArrayBuffer` — allocating a defensive mutable copy only if
   absolutely necessary. `ArrayBuffer.isView` is already the committed
   genuine-vs-emulated discriminator (see `packages/bytes/src/compare.js`).
3. **Benchmark-driven decision (the gating unknown):** for read paths, decide
   between reading in place via `view.at(index)` on the emulated wrapper vs. a
   `toThawed` defensive copy + indexed get, **based on benchmarks that reveal a
   platform difference.** Maintainer's own analysis to honor:
   - **XS:** has *native* immutable ArrayBuffer *and* a native base64 codec, so
     no shim path runs there — the choice is immaterial on XS.
   - **Node.js:** measure `view.at(index)` vs `toThawed`+indexed-get; the winner
     "will likely depend on the size of the subject." base64 in particular
     benefits from the native codec.

## Deliverable (DESIGN + BENCHMARK EVIDENCE — do NOT edit the fix files)

- A Node.js micro-benchmark (in a scratch checkout, or as a committable bench
  under the relevant package if that fits repo convention) comparing
  `view.at(index)` in-place reads against `toThawed` copy + indexed reads across
  a range of subject sizes (small keys → large buffers). Report the crossover.
- A short design note that records: the `toThawed` API (name, home package,
  signature, copy-only-when-necessary contract), the `ArrayBuffer.isView` +
  `toThawed` composition pattern, and a per-site recommendation for the byte ops
  that touch emulated buffers: `@endo/bytes` (`equals`/`compare`/`concat`/
  `to-string`), `@endo/hex` (`encode`), `@endo/base64` (`encode`). State plainly
  where the benchmark says "index in place" and where it says "thaw and copy,"
  and that XS needs no shim path.
- Post the design note as a PR comment addressed to @kriskowal (reply under the
  directive comment), so the decision is on the record.

## Coordination — avoid a concurrent-edit collision

Sibling job `endojs-endo-but-for-bots-pr475-9885f3d8` is **concurrently
implementing** the concrete fixes for `bytesEqual`, `@endo/base64` `encode.js`,
and `@endo/ocapn` `diagnosticEquals` (directive comment 5334510251), and those
fixes reference `toThawed`. This job is **design-only**: produce the naming +
benchmark decision that those fixes and the concat/to-string dedup should adopt.
**Do not edit** `equals.js`, `base64/src/encode.js`, or `ocapn` diagnostic files
— 9885f3d8 owns the PR-head branch for them. If your design implies changes to
the actual helper, recommend a single follow-up build (or a hand-off note to
9885f3d8) rather than racing the same branch. The concat + to-string
`toMutableChunk`/`toDecodable` dedup into `toThawed` is the implementation that
follows this design.

## Definition of done

The benchmark exists and has been run on Node.js with numbers reported; the
`view.at` vs `toThawed` decision is stated with evidence; the `toThawed` API and
the isView+toThawed composition are specified for each byte package; the design
note is posted to PR #475. If implementation is warranted, name the follow-up
explicitly (posted job base or a hand-off to 9885f3d8) rather than leaving a
loose "someone should build this."

<!-- garden-reaped: 2 -->

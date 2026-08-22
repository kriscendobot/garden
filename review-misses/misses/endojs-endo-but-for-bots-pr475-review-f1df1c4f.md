---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-f1df1c4f
verdict: miss
category: test-gap
pr: 475
cluster: type-representation-matrix-coverage
cluster_pattern: A PR that introduces or narrows a value type with multiple representations (frozen/thawed, mutable/immutable, native/emulated) ships without panel-required tests exercising the full representation matrix against the platform APIs/consumers that flow through the type; the corner-prober/coverage seats do not enumerate the intersection, so the maintainer must ask for the missing matrix.
review_at: 2026-08-18T19:47:37Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4965138406
identity: endojs/endo-but-for-bots#475:review:4965138406
producing_role: builder
producing_job: endo-byte-array-press (byteArray-narrowing campaign; decodeSwissnum in packages/ocapn/src/client/util.js)
missed_by: corner-prober (enumerate the emulated-vs-genuine immutable-ArrayBuffer x platform-text-decoder cell on XS); secondarily engine-realist (V8-vs-XS reality — whether the platform text decoder accepts a genuine immutable ArrayBuffer backing, not only an emulated one)
severity: minor
grounds: |
  In a June 22 PR thread reply the bot asserted, as settled runtime fact, that
  the platform text decoder "rejects immutable ArrayBuffer backing," and used
  that premise to justify a defensive copy of the immutable-backed byteArray into
  a fresh mutable Uint8Array before decoding (decodeSwissnum / bytesFromImmutable
  in packages/ocapn/src/client/util.js). In review 4965138406 the maintainer
  (erights) corrected the premise: the decoder rejects only EMULATED immutable
  ArrayBuffers, not GENUINE ones, and asked the bot to verify that XS's decoder
  accepts genuine immutable ArrayBuffers. This is the same emulated/genuine x
  platform-text-codec intersection that PR #475 has already been dinged for twice
  in this cluster (1011c1c5: TextEncoder/TextDecoder x frozen/thawed x
  mutable/immutable matrix; 5aae699b: emulated/genuine x shim/hardener
  capture-order matrix). The unenumerated cell here is genuine-immutable-ArrayBuffer
  through the text decoder on XS; had the corner-prober enumerated that boundary
  (its brief already charters "for every claimed contract the PR modifies,
  enumerate the boundary set ... cases the PR's tests do NOT exercise," with
  mutable-vs-immutable and native-vs-emulated the exact axes this PR introduces)
  or the engine-realist walked its V8-vs-XS-reality axis over the immutable
  ArrayBuffer the PR narrows byteArray to, the genuine-on-XS behavior would have
  been verified and the bot would not have shipped an unverified runtime-behavior
  claim for the maintainer to correct. It is a miss, not new direction: the axis
  is not first-stated here — it is already in the corpus and chartered by standing
  seat briefs. The "clarified in later commits" texture is not exculpatory; this
  cluster's own precedent (5aae699b) minted a miss under the identical
  later-clarification shape because the seat brief already charters the axis.
  Severity minor: at worst an unnecessary per-call memcopy (a perf pessimization
  under the shim), no shipped correctness bug, caught pre-merge. Surface note: the
  corrected claim lived in a discussion-thread reply the panel does not read, but
  the root gap is the same untested/unverified representation-matrix cell the
  cluster is about, so it joins rather than mints. Discrepancy flag for the primary
  loop: the primary job (f1df1c4f) is still parked in jobs/plan/ and the only
  public reply on this review (2026-08-19) addressed the SIBLING comment
  (narrowing the ArrayBufferView|ArrayBufferLike union to SwissNum, commit
  f83e8813d) while explicitly DEFERRING the XS genuine-immutable verification erights
  asked for as "a separate, broader direction" — so that verification is genuinely
  still open, not resolved.
---

Maintainer review (paraphrased): the bot had claimed the platform text decoder
rejects immutable ArrayBuffer backing and copied the immutable-backed byteArray to
a fresh mutable Uint8Array before decoding. The maintainer corrected that the
decoder rejects only EMULATED immutable ArrayBuffers, not GENUINE ones, and asked
the bot to verify that XS's decoder accepts genuine immutable ArrayBuffers.

The review miss: no garden panel enumerated or verified the genuine-immutable
-ArrayBuffer-through-the-platform-text-decoder-on-XS cell of the representation
matrix, though the corner-prober's boundary-enumeration brief and the
engine-realist's V8-vs-XS reality lens both already cover that surface. The bot
therefore shipped an unverified runtime-behavior claim the maintainer had to
correct. See comment_url to re-fetch the verbatim (untrusted) text.

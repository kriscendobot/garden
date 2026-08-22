---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-9885f3d8
verdict: miss
category: correctness-bug
pr: 475
cluster: incomplete-sibling-transformation
cluster_pattern: A commit that generalizes an operation across a family of sibling call sites (read-only byte ops, twin packages, a shared helper shape) converts some sites but silently skips others; no panel lens enumerates every sibling of the generalized operation and verifies each was converted, so a skipped sibling carrying a live latent bug reaches the maintainer.
review_at: 2026-08-18T21:53:05Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5334510251
identity: endojs/endo-but-for-bots#475:comment:5334510251
producing_role: builder
producing_job: endo-byte-array-press (campaign)
missed_by: byteArray correctness/adversarial panel lens (breaker/corner-prober/decomplector); no gauntlet enumerated the sibling call sites before the maintainer did
severity: moderate
grounds: |
  Commit 53caf95d (2026-08-13, "generalize read-only byte ops to accept frozen
  byteArray passables") converted three of the four read-only byte ops in
  @endo/bytes (compareBytes, concatBytes, bytesToText) plus @endo/hex to sense
  genuine-vs-emulated inputs and copy an immutable-backed input before
  integer-indexing, but silently skipped the fourth sibling (equals.js
  bytesEqual), the twin package (@endo/base64 encode.js, the exact analogue of
  the hex change made in the same commit), and the identical shape in
  @endo/ocapn diagnosticEquals. The maintainer enumerated all three skipped
  siblings by hand on 2026-08-18. Grounded in the review history: between the
  introducing commit (08-13) and the maintainer's comment (08-18) only reviewer
  comment jobs touched the PR — no garden panel or gauntlet reviewed the
  increment; the only garden gauntlet (endojs-endo-but-for-bots-pr475-gauntlet-20260819)
  ran on 08-19, after the fix (c33a5845c, 08-18) had already landed, so its
  correctness lens correctly observed "every reader thaws emulated wrappers
  before indexing" only because the fix was in. The panel demonstrably can
  reason about this whole-family property; the gap is that no seat performs the
  sibling enumeration ("this commit generalizes op X; here are all N call sites
  of X's shape; each must be converted"). The skipped bytesEqual is a real
  latent correctness bug (distinct equal-length emulated byteArrays compare
  equal on the shim leg via undefined !== undefined; a live import in @endo/cbor)
  and base64 silently emits all-zero output for a passable on the current Node
  JS path — real bugs, but caught pre-merge with no production impact, hence
  severity moderate rather than major. No standing rule (seat brief, skill, or
  COMMON norm) currently requires enumerating sibling call sites when a change
  generalizes an operation, so this is a sense-and-create gap, not a
  standing-rule-that-did-not-bind failure.
---

The maintainer's PR #475 comment (paraphrased): a prior commit that generalized
the read-only byte operations to accept frozen byteArray passables was applied
inconsistently. Three of the four read-only byte ops and @endo/hex were
converted to copy/thaw an immutable-backed input before integer-indexing, but
the fourth op (bytesEqual), the twin package (@endo/base64 encode), and the
matching shape in @endo/ocapn's diagnostic-equals helper were left indexing
their arguments directly — a live latent bug in each. The maintainer asked that
all three be brought up to speed using ArrayBuffer.isView to sense
genuine-vs-emulated inputs.

The review miss: no garden panel enumerated the sibling call sites of the
generalized operation before the change reached the maintainer. See
`comment_url` to re-fetch the verbatim text.

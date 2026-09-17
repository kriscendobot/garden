---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1099-review-6694e2d7
verdict: miss
category: correctness-bug
pr: 1099
cluster: incomplete-sibling-transformation
cluster_pattern: A commit that generalizes an operation across a family of sibling call sites (read-only byte ops, twin packages, a shared helper shape) converts some sites but silently skips others; no panel lens enumerates every sibling of the generalized operation and verifies each was converted, so a skipped sibling carrying a live latent bug reaches the maintainer.
review_at: 2026-09-02T23:29:39Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1099#pullrequestreview-5096138036
identity: endojs/endo-but-for-bots#1099:review:5096138036
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr1099 (byteArray-narrowing / immutable-arraybuffer campaign)
missed_by: byteArray/passable correctness lens (breaker/prover/corner-prober); no gauntlet enumerated the sibling sites that must share the emulated-vs-genuine dispatch pattern (hex vs base64 encode dispatch; harden vs ses make-hardener)
severity: moderate
grounds: |
  PR #1099 ("narrow byteArray to a frozen Uint8Array", kriscendobot, breaking
  feat!) is a second, distinct PR in the same immutable-arraybuffer / byteArray
  campaign as #475, and the maintainer's CHANGES_REQUESTED review
  (pullrequestreview-5096138036) is the incomplete-sibling-transformation shape
  again — twice within one review. (1) packages/hex/src/encode.js gated the native
  `toHex` fast path on `bytes.buffer.immutable !== true`, wrongly routing GENUINE
  immutable views to the polyfill; the committed-correct sibling
  packages/base64/src/encode.js already dispatches on `ArrayBuffer.isView(bytes)`
  (the correct emulated-vs-genuine discriminator, fixed under issue #573). The
  generalization that landed on base64 was not carried to its hex sibling, so hex
  reached the maintainer carrying a live latent correctness bug; the maintainer
  named it "a broad misunderstanding" and asked to "search this pull request for
  every occurrence." The fix (garden commit 331dfdfae2) replaced the gate with
  `ArrayBuffer.isView` to match base64 and confirmed hex was the sole remaining
  src occurrence. (2) packages/harden/make-hardener.js was refactored so the
  freeze carve-out calls a new `isMutableTypedArray`, but its sibling copy
  ses/src/make-hardener.js still gates `freezeTypedArray` on the old
  `isTypedArray` and kept the now-stale comment — the maintainer's "scan this PR
  for this kind of inconsistency" surfaced the un-converted twin (a real
  behavioral divergence flagged to the maintainer for a design call). Both are the
  cluster's exact pattern: an operation generalized across a family of sibling
  sites converts some and silently skips others, and no gauntlet seat enumerates
  "here are all N sibling sites that must share dispatch/invariant X; verify each
  was converted," so the skipped sibling reaches the maintainer. Grounded in the
  world, not the primary report: I re-fetched the PR (still draft, kriscendobot,
  no gauntlet/panel job exists for #1099 in journal/jobs/tada/), read all four
  inline comments, and confirmed the fix job (fix-review-5096138036) landed real
  commits (331dfdfae2, 37542dc47a, c88c7e0f91) with resolved threads — so the
  primary's directive deliverable genuinely exists; there is no false-peer no-op
  to report. Severity moderate: genuine correctness fragility in code destined for
  the upstream ferry, but caught in review before merge (PR still draft) with no
  shipped impact. No standing rule (seat brief, skill, or COMMON norm) requires
  sibling-site enumeration on a family-generalizing change, so this is a
  sense-and-create gap, not a standing-rule-that-did-not-bind failure.
---

The maintainer's PR #1099 review (paraphrased): the hex encoder was checking
buffer immutability to pick the native-vs-polyfill path when it should dispatch on
whether the argument is a view at all — the same discriminator its committed base64
sibling already uses — so genuine immutable views were wrongly sent to the
polyfill; he called it a broad misunderstanding and asked to sweep the whole PR for
every occurrence and to make tests sensitive to emulated-vs-genuine under
hardened262. Separately, a make-hardener comment no longer matched its (correct)
implementation, and he asked to scan the PR for the same kind of inconsistency —
which surfaced the sibling ses/ hardener copy still gating on the old predicate.

The review miss: two of the four asks are the same shape — a pattern/fix present in
one sibling site (base64 encode; harden make-hardener) but not carried to its twin
(hex encode; ses make-hardener), with no garden panel lens enumerating the sibling
sites of a family-generalizing change and verifying each was converted, so the
skipped siblings reached the maintainer. This is the first instance of the
incomplete-sibling-transformation pattern on a PR other than #475. See
`comment_url` to re-fetch the verbatim text.

---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-f66ed689
verdict: miss
category: correctness-bug
pr: 475
cluster: incomplete-sibling-transformation
cluster_pattern: A commit that generalizes an operation across a family of sibling call sites (read-only byte ops, twin packages, a shared helper shape) converts some sites but silently skips others; no panel lens enumerates every sibling of the generalized operation and verifies each was converted, so a skipped sibling carrying a live latent bug reaches the maintainer.
review_at: 2026-08-22T00:47:23Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3834611293
identity: endojs/endo-but-for-bots#475:review:4998406945
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr475 (immutable-arraybuffer campaign)
missed_by: byteArray/passable correctness lens (breaker/prover/corner-prober); no gauntlet enumerated both sibling constructors that maintain the bidirectional buffer-map invariant
severity: moderate
grounds: |
  In packages/immutable-arraybuffer/src/lib.js the immutable-buffer machinery
  keeps a bidirectional pair of weak maps (buffer -> genuineBuffer in `buffers`,
  genuineBuffer -> buffer in `reverseBuffers`). Immutable-buffer creation
  installed only the forward direction; the reverse direction was installed
  separately, and identically, by BOTH the DataView constructor and the
  TypedArray-emulation constructor. The maintainer first probed the DataView
  site (parent comment 3834592560: "is this line redundant, or a bug?"), then in
  review 4998406945 asked the sibling question directly — "does the TypeArray
  emulation have the same problem?" The bot's own reply (comment 3834924079)
  confirms it did: the split meant the "redundant" reverse-map write was NOT
  actually redundant, so the TypedArray sibling carried the same latent invariant
  gap. The fix (4dbe5ffff, "pair buffer maps at creation") installs both
  directions together at creation and removes the now-truly-redundant writes from
  BOTH the DataView and TypedArray constructors. This is the same shape as the
  cluster's existing member 9885f3d8: an operation (maintaining the reverse-map
  invariant) is spread across a family of sibling call sites, one sibling is
  examined while the twin is left unverified, and the maintainer — not a panel —
  enumerates the sibling. The panel demonstrably can reason about the whole-family
  invariant, but no seat performs the sibling enumeration ("here are all N sites
  that maintain invariant X; each must be consistent"), so the twin reached the
  maintainer. Real latent fragility (a naive "remove the redundant line" edit
  would have broken the reverse lookup) but caught in review with no shipped
  impact, hence moderate. No standing rule (seat brief, skill, or COMMON norm)
  requires sibling-site enumeration on an invariant-maintenance change, so this is
  a sense-and-create gap, not a standing-rule-that-did-not-bind failure.
---

The maintainer's PR #475 review (paraphrased): having questioned whether a
reverse-map write in the DataView constructor was redundant, he asked whether the
TypedArray emulation had the same problem. It did: the bidirectional buffer-map
invariant was installed forward-only at buffer creation and reverse-only,
separately, in each of the two sibling constructors (DataView and TypedArray), so
neither reverse write was safe to treat as redundant and the TypedArray sibling
shared the gap. The fix pairs both map directions at creation and drops the
redundant writes from both constructors.

The review miss: no garden panel enumerated the sibling call sites that jointly
maintain the buffer-map invariant, so the twin (TypedArray) reached the maintainer
unverified. See `comment_url` to re-fetch the verbatim text.

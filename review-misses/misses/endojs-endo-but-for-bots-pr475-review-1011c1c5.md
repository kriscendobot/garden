---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-1011c1c5
verdict: miss
category: test-gap
pr: 475
cluster: type-representation-matrix-coverage
cluster_pattern: A PR that introduces or narrows a value type with multiple representations (frozen/thawed, mutable/immutable, native/emulated) ships without panel-required tests exercising the full representation matrix against the platform APIs/consumers that flow through the type; the corner-prober/coverage seats do not enumerate the intersection, so the maintainer must ask for the missing matrix.
review_at: 2026-08-21T22:54:46Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4997883402
identity: endojs/endo-but-for-bots#475:review:4997883402
producing_role: builder
producing_job: endo-byte-array-press (byteArray-narrowing campaign)
missed_by: corner-prober (boundary enumeration of the new type's intersection with the platform text codecs); secondarily coverage-auditor / engine-realist
severity: minor
grounds: |
  PR #475 narrows byteArray to a hardened, whole-buffer-spanning Uint8Array
  backed by an immutable ArrayBuffer. TextEncoder/TextDecoder are the canonical
  text-to-bytes codecs and @endo/bytes exposes bytesToText/textToBytes on top of
  them, so the new type flows through the Encoding API by construction. The
  maintainer (kriskowal, CHANGES_REQUESTED review 4997883402) asked the bot to
  add hardened test262 (Hardened262) cases validating TextEncoder/TextDecoder
  intersection semantics across the frozen/thawed Uint8Array and mutable/immutable
  ArrayBuffer matrix. This is a miss, not new direction: the corner-prober seat
  brief (roles/jurors/corner-prober/AGENT.md) already charters exactly this work,
  "for every public function, exported invariant, or claimed contract the PR
  introduces or modifies, enumerate the boundary set ... cases the PR's tests do
  NOT exercise," and frozen-vs-thawed, mutable-vs-immutable are the precise axes
  this PR introduces. A standing seat brief that existed did not bind: no garden
  panel enumerated the new type's intersection with the platform codecs, and the
  maintainer had to ask. The specific delivery form (extend the packages/hardened262
  conformance suite) is maintainer preference layered atop an anticipatable
  coverage gap; the gap itself (untested type-x-codec representation matrix) is the
  miss. Adjacent to but distinct from the two prior PR #475 test misses: 54294cd3
  (cross-platform-test-coverage) was emulated-only assertions unvalidated under
  native/XS, and 9885f3d8 (incomplete-sibling-transformation) was a source-side
  generalization skipping sibling call sites; this is a test-side gap in exercising
  the new type's full representation matrix against its platform consumers, so it
  mints its own cluster. Severity minor: test-only, latent, caught pre-merge with
  no shipped runtime defect, and the primary job delivered the requested matrix
  (commit 580afb0b added packages/hardened262/test/ArrayBuffer/view-behavior-matrix.js
  plus the immutableArrayBufferViewMatrix harness and baselines; all 27 PR checks
  pass). Held below dispatch this round: single member, single PR, does not meet
  the K >= 3 across >= 2 PRs floor.
---

The maintainer's PR #475 review (paraphrased): add hardened conformance-suite
(Hardened262) test cases that validate TextEncoder and TextDecoder intersection
semantics for the newly narrowed byteArray type, across the frozen-vs-thawed
Uint8Array and mutable-vs-immutable ArrayBuffer matrix.

The review miss: no garden panel required tests exercising the new immutable/frozen
byteArray type through its platform text codecs across that representation matrix,
though the corner-prober seat's boundary-enumeration brief already covers exactly
this surface. See comment_url to re-fetch the verbatim (untrusted) text.

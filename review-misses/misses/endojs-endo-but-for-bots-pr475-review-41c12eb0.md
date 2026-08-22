---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-41c12eb0
verdict: miss
category: docs-drift
pr: 475
cluster: docs-claim-contradicts-code-semantics
cluster_pattern: A doc asserts an API-semantics/brand-check claim that contradicts the repo's own authoritative reference code, because review checks prose for clarity but does not cross-verify definite technical claims against the implementation they describe.
review_at: 2026-08-18T00:02:20Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4955643812
identity: endojs/endo-but-for-bots#475:review:4955643812
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr475 (#449 freezable-emulation build, commit a93262fd47)
missed_by: scribe
severity: minor
---

Fleet-authored prose in `packages/immutable-arraybuffer/README.md` recommended
the `immutable` accessor on a view's `.buffer` as "the canonical brand check"
for telling an emulated immutable view from a genuine one. That claim is false:
the `immutable` axis answers only mutable-vs-immutable; both an emulated wrapper
and a future-native genuine view report `.buffer.immutable === true`, so it
cannot discriminate provenance. The repo's own reference implementation already
documented the correct semantics — `@endo/pass-style` `byteArray.js` states in a
code comment that the immutable axis "is not the emulated-vs-genuine
discriminator" and that the finer distinction is drawn separately (by own
integer-indexed-key count). The wrong paragraph was introduced by this PR's own
build commit, so a panel reviewing the diff had the change in front of it.

**Grounds for a miss:** the defect is a definite, checkable technical claim in
documentation that contradicts an authoritative statement living in the same
monorepo. It is catchable in principle by cross-referencing the doc's
brand-check claim against the code it describes — a docs/spec review lens — not
purely a matter of taste or a requirement first stated in the comment. It is
recorded as a miss rather than a dismissal on that ground. It is not
`evaluator-gaming`: the work was not shaped to satisfy a rubric; a prose
paragraph was simply wrong.

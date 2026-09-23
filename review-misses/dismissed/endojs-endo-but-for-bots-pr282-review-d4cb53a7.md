---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr282-review-d4cb53a7
verdict: not-a-miss
category: new-direction
review_at: 2026-08-19T05:19:25Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/282#pullrequestreview-4968656739
identity: endojs/endo-but-for-bots#282:review:4968656739:retro
---

Maintainer roadmap directive on PR #282: open a job to ratchet the set of
exercised fixtures upward until endor reaches parity with node, noting the
fixtures' dedicated harnesses must be emulated or refactored away for both
runtimes. This is new direction — the maintainer sequencing the next phase of
parity work — not a defect the panel could have anticipated. Grounds: the PR's
fixture-parity substrate (the `compartment_mapper_fixture_parity.rs` manifest
classifying 40 fixtures as 7 Exercise / 33 Exclude with a drift safeguard) had
already landed via the earlier `endojs-endo-but-for-bots-pr282-fixture-parity`
job; this review, filed after that, asks for a driven ratchet campaign on top of
the substrate — a scope/roadmap call, no seat or gate owns it. Consistent with
the prior pr282 dismissal (148f5c93), an operational pipeline directive. Primary
resolution verified real, not a false no-op: the primary posted
`design-endor-fixture-parity-ratchet`, which reached `jobs/tada/` and spawned the
`endor-fixture-parity-ratchet-campaign` follow-up.

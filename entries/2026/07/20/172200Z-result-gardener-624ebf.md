---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-20T17:22:02Z
---
---
kind: result
role: prosecutor
refs:
  - kriscendobot-agoric-sdk-pr15-review-aad444c1-retro
  - kriscendobot/agoric-sdk#15:review:4726738933:retro
---

# Retro: PR #15 review 4726738933 — dismissed (comment-hygiene)

Second-loop retrospective on dckc's inline review of `portfolio.exo.ts:258`.
Verdict: **not-a-miss** (`new-direction`). The review asks the interface-guard
rationale comment be made more concise, questions whether the constraints belong
in tests rather than a separate comment, and affirms one non-testable point is
worth keeping — reviewer taste about prose verbosity and comment-vs-test vehicle,
not a documented convention the panel knew and failed to bind.

Grounded in the PR's review history: this is the same comment-hygiene theme
already dismissed on #15 (review 4726462863, `-2bf0daa3`), expressly held outside
the substantive `exo-guard-matches-static-type` cluster. That cluster (the
guard-tightness misses 396a141c / 63f630f8 / 9a12af5e / ccb767b7) is already
`closed`, improved by 8ec780c5ac. This review touches the guards only via their
comment, not their tightness, so there is nothing for the improved spec-keeper
probe to fire on and nothing new to prevent.

Recorded via `review-miss-record.sh record` →
`review-misses/dismissed/kriscendobot-agoric-sdk-pr15-review-aad444c1.md`. No
cluster minted, no threshold evaluation (dismissal), no improvement job.

Self-improvement: nothing this time — the discriminator and store worked as
intended; the prior sibling dismissal made the comment-hygiene-vs-guard-tightness
boundary unambiguous.

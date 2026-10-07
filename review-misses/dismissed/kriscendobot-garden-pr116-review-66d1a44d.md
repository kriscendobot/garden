---
kind: review-miss-dismissed
primary_job: kriscendobot-garden-pr116-review-66d1a44d
verdict: not-a-miss
category: new-direction
pr: 116
repo: kriscendobot/garden
identity: kriscendobot/garden#116:review:5432482973
comment_url: https://github.com/kriscendobot/garden/pull/116#pullrequestreview-5432482973
review_at: 2026-10-06T17:54:37Z
severity: minor
grounds: |
  Maintainer decisions on declared open questions, not a review-process miss.
  PR #116 is a garden design PR opened under the open-questions carve-out
  (body carries the garden-design-open-questions marker): the design was
  already on main2 (98db6149401) and the PR existed solely as the maintainer's
  answer surface for six listed open questions (per-subscription vs global,
  curve shape, computed-on-read vs ticked, no-window fallback, override expiry,
  manual-reset re-anchoring). Review 5432482973 (APPROVED, kriskowal) answers
  those questions inline — per subscription, linear, compute-on-read, a 0.95
  fallback, honor an until gate on overrides, track resets per subscription
  with Claude manual resets not shifting phase while Codex resets do — and
  directs the fleet to conduct, build, and deploy without further review.
  Every point is a choice among options the design itself surfaced as
  undecided, i.e. requirements first fixed in this review; no seat brief,
  skill, or standing rule could have decided them. Per CLAUDE.md the marker
  deliberately suppresses a design panel for such PRs, so the absence of a
  gauntlet in jobs/tada for #116 is the documented path, not avoidance-shaped
  evaluator gaming.

  World check (not just the primary's report): the PR is MERGED; the decisions
  are present on main2 in designs/standing-token-backoff-ramp.md (fixup
  eb6b9c13b6a: 0.95 fallback, --until gate, per-subscription reset tracking);
  the primary handed off to orch-standing-token-backoff-ramp-delivery, and
  build-standing-token-backoff-ramp and release-standing-token-backoff-ramp
  are both in jobs/tada (2026-10-06). No discrepancy with the primary's claims.
---

Maintainer approved the open-questions design PR and answered its six declared
questions inline (per-subscription, linear, compute-on-read, 0.95 fallback,
honor until-gated overrides, per-subscription reset tracking), then directed
conduct/build/deploy. New direction resolving surfaced forks; dismissed.

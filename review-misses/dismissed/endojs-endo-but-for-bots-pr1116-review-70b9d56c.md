---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1116-review-70b9d56c
verdict: not-a-miss
category: new-direction
pr: 1116
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1116:review:5360612317
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1116#pullrequestreview-5360612317
review_at: 2026-09-30T02:17:55Z
producing_role: designer
producing_job: endo-guest-invite-accept-design
severity: minor
grounds: |
  Maintainer answers to the design's own open questions, plus new direction and
  drift that happened after the gauntlet finished. PR #1116 is a DRAFT design PR
  (designs/guest-native-invitations.md). It ran the full design gauntlet
  (journal/jobs/tada/2026/09/02-04: gauntlet-clean, panel-1..6, fix-1..6), so the
  evaluator was not skipped. The PR body lists open questions for the maintainer:
  host-path convergence, the vestigial @pins/guest-* mint, mid-accept recovery
  ordering, prior-incarnation revocation, and peer-registration bounding. Review
  5360612317 (CHANGES_REQUESTED, kriskowal) resolves them one by one in
  paraphrase. Any agent, host or guest, can accept, and a new user gets a guest
  auto-provisioned. The pin mint goes, because per-agent pins now cover it. The
  review points to CapTP-style tie-breaking by formula-identifier comparison.
  Invitation state must be durable in the formula store. Unreachable formulas
  should be collected promptly. A minion.town guest-coupon rate-limit scheme is
  to be posted as a follow-up and is explicitly not needed for this design. The
  top-level ask is to reconcile with implementation work that landed or started
  after the Sept 2-4 gauntlet (#1305, #1306, #1310, #1277, #399, per the primary's
  reply). The panel could not have anticipated that drift. Every other item is a
  decision the design properly left to the maintainer: the vestigial pin mint was
  itself flagged as an open question, not hardened unquestioned, so the
  vestigial-mechanism-unquestioned pattern does not apply. No seat brief, skill,
  or standing rule encodes these choices. The feedback is first-stated direction,
  not a review-process miss. Primary deliverable verified in the world: commit
  f7b82cba0 plus a bot reply on the PR at 2026-09-30T05:11Z.
---

Maintainer resolved the design's surfaced open questions (who may accept, removing the pin mint, tie-breaking, durability, GC promptness), asked for a follow-up rate-limiting job, and asked for reconciliation with implementation work that landed after the design gauntlet. That is new direction, not a review miss.

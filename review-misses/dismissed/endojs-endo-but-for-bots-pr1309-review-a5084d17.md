---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1309-review-a5084d17
verdict: not-a-miss
category: new-direction
pr: 1309
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1309:review:5271637936
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1309#pullrequestreview-5271637936
review_at: 2026-09-21T20:41:43Z
producing_role: fixer
producing_job: fix-endo-daemon-test-process-leak-20260919
severity: minor
grounds: |
  Tuning preference first stated in the review, not a review-process miss.
  PR #1309 (fix daemon test process leak) was opened as a DRAFT by
  fix-endo-daemon-test-process-leak-20260919 and, per the manual-gauntlet-trigger
  regime, awaited an explicit "run the gauntlet #1309"; journal/jobs/tada/ holds
  no clean/panel/fix-loop job for pr1309 — the maintainer reviewed and APPROVED
  it directly (review 5271637936), so the gauntlet not running was a maintainer
  choice under the current regime, not a skipped evaluator (not `process`, not
  `evaluator-gaming` avoidance). The approving review's one inline note (comment
  4066237599 on packages/daemon/src/shutdown-signals.js) asked that the new
  orphan-watch polling interval (hardcoded 1000ms) be made configurable and
  polled less often by default; the review body's other asks (respond, retcon,
  conduct) are workflow directives. No juror seat brief, skill, or standing
  instruction encodes a rule about configurable/infrequent polling intervals or
  default timer cadence (grep of roles/jurors/* finds none), and a 1s poll gated
  behind an opt-in test-only env flag is not a bug or convention violation —
  the chosen default is a maintainer taste call on idle-daemon cost. The primary
  deliverable exists: the merged diff (PR merged 2026-09-22T01:04:59Z) carries
  `orphanCheckMs` / `ENDO_ORPHAN_CHECK_MS` defaulting to 5000ms, and the inline
  thread has bot replies confirming it.
---

Maintainer approved #1309 with one inline note asking that the daemon's orphan
watch poll interval be configurable and less frequent by default. Addressed by
the primary (orphanCheckMs / ENDO_ORPHAN_CHECK_MS, default 5000ms) before merge.
Dismissed as new-direction: a default-tuning preference no standing rule encodes.

---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1306-review-3ed76637
verdict: not-a-miss
category: new-direction
pr: 1306
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1306:review:5253000171
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1306#pullrequestreview-5253000171
review_at: 2026-09-18T21:57:14Z
severity: minor
grounds: |
  Forward design direction, explicitly scoped out of this change. Review
  5253000171 (APPROVED, kriskowal) on PR #1306 (slice 2/3 of the #1125 split,
  caller-elected pins/networks/names for new agents) asks the bot to conduct
  (merge), and adds a note on the longer-term shape of the daemon's
  id-for-reference facility: it should eventually resolve for any
  formula-produced object while remaining a host-held power not handed to
  guests, and wrapping formula identifiers in ephemeral objects to hide them
  from the host is not a goal. The maintainer states the migration need not
  happen in this PR. The diff does not introduce any such wrapper (it calls the
  existing getIdForRef), so there is no defect in the change for a seat to have
  caught; the note is a first-stated architectural preference, not a bug, spec
  violation, or convention encoded in any seat brief, skill, or standing
  instruction. The review process ran: the #1125 lineage carries six
  gauntlet panel/fix rounds in journal/jobs/tada (2026-09-12/13), and the split
  stack was gated by the split-pr1125-stack-gauntlets orchestration. Not
  evaluator-gaming: the PR was approved and merged (2026-09-19) after review,
  no gate was routed around. The primary (3ed76637) did not no-op
  unverified: I confirmed PR #1306 is MERGED (so "conduct" is satisfied in the
  world) and the forward note was captured as designer job
  design-endo-idforref-host-held-migration, which exists in journal tada
  (2026-09-26). No discrepancy to report.
---

Maintainer approval review 5253000171 on PR #1306 requests merge and records a
forward preference about the daemon's id-for-reference power (broader coverage,
host-held, no ephemeral-wrapper indirection), expressly deferred out of this
change. New direction, not a review-process miss. The PR merged; the direction
was carried into design job design-endo-idforref-host-held-migration. Re-fetch
the verbatim review body at comment_url.

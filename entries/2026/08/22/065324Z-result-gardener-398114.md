---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-22T06:53:26Z
---
Prosecutor retro on endojs/endo-but-for-bots#475, erights review 4965245381
(endojs/endo-but-for-bots#475:review:4965245381:retro).

Verdict: NOT-A-MISS (category new-direction). The review indicts the fleet's
comment-POSTING machinery — a shell backtick command-substitution bug that
silently ate inline-code spans from an outgoing kriscendobot reply — not the
review of #475's code. The corrupted artifact is a reply to the reviewer, not a
hunk in #475's diff; no juror seat or gauntlet stage reviews outgoing bot comment
bodies, so the review process could not and should not have caught it. This is the
mentor loop's domain (machinery misbehaved), not the prosecutor's. Verified against
the world: review is COMMENTED/empty-body with lone inline comment 3807489882, and
the primary's deterministic prevention (scripts/jobs/comment-body-guard.sh at the
gh chokepoint, commit c7a979c618) already exists on main2 — the exact durable check
a review-improve job would add already landed. No cluster, no threshold, no
improvement dispatch.

Recorded: review-misses/dismissed/endojs-endo-but-for-bots-pr475-review-f55c1aef.md.

Self-improvement: none needed; the loop's idempotency pre-check, world-grounding
(re-fetched review + verified c7a979c618 on main2 rather than trusting the primary
report), and the mentor/prosecutor boundary rule all applied cleanly.

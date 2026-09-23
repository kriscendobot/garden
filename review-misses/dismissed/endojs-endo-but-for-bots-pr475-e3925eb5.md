---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-e3925eb5
verdict: not-a-miss
category: new-direction
review_at: 2026-08-18T19:28:52Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5333026938
identity: endojs/endo-but-for-bots#475:comment:5333026938:retro
---

Behavioral/etiquette directive on PR #475: the reviewer asks `@kriscendobot` to
unresolve every review conversation the bot had resolved, to leave human-resolved
conversations resolved, and to stop resolving conversations on this PR going
forward — explicitly deferring to the other maintainer on whether the "humans
resolve conversations, bots do not" rule should become general policy ("My request
is specific to this PR").

Grounds: this is a first-stated governance/etiquette preference, the textbook
new-direction shape, not an indictment of #475's review. Three grounded reasons.
(1) It targets no work product. The comment identifies no bug, spec violation,
missed edge case, or violated convention in the PR's code; it objects to a
*GitHub-thread-management behavior* of the bot (auto-resolving review threads),
which is machinery interaction, not a defect a code panel or juror seat is
positioned to catch. Under the loop's own boundary rule, "the work was wrong and
review missed it" is the prosecutor's; "the machinery misbehaved" is the mentor's
— this is the latter. (2) No standing rule bound. A sweep of `roles/COMMON.md`,
the PR-followup skills (`pr-review-thread-replies`, `review-feedback-followup-commits`,
`chained-followup`), and the juror seat briefs finds no instruction that either
requires or forbids the bot resolving conversations; the behavior emerged from the
review-feedback automation with no written convention either way, so there was no
seat brief, skill, or standing instruction the panel demonstrably knew and failed
to bind. A severity-bypass dispatch requires "a standing rule that already existed
and did not bind," and none existed. (3) The maintainer himself frames it as an
unsettled policy, deferring the general case to `@kriskowal` — a requirement
crystallized in the comment itself, which nobody in the #475 gauntlet could have
anticipated. No evaluator-gaming shape applies: #475 is a live, heavily-reviewed PR
(dozens of `review-*`/gauntlet jobs in `journal/jobs/tada/`), so no evaluator was
routed around or met in letter-only fashion; the objection is orthogonal to the
review of the code.

Verified against the world, not the primary report: the primary (e3925eb5) was not
a false-peer no-op — it did real work, confirmed via GraphQL. Its confirmation
comment 5333072818 exists (kriscendobot, 2026-08-18T19:33:10Z), and the current
review-thread state on #475 shows every resolved thread is human-resolved
(erights and kriskowal only) with zero threads still bot-resolved — so the 47
unresolutions genuinely happened and the stop-resolving commitment has held. The
primary also relayed the fleet-wide policy question to the maintainer inbox
(message 20260818T193320Z-8ce7fd) for `@kriskowal` to decide, which is the correct
channel for the systemic automation-behavior question — it belongs to the mentor
loop (change the review-feedback automation), not a review-improve cluster. There
is thus no closed-as-no-op discrepancy to report.

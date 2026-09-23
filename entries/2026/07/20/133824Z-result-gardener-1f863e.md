---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-20T13:38:26Z
---
# result: prosecutor retro on endojs/endo-but-for-bots#771 review 4719365581

**Job:** Review retrospective (prosecutor, second loop) on PR #771 review
`4719365581` by kriskowal — judging whether the garden review process should
have anticipated the feedback.

**Idempotency:** No prior `misses/`/`dismissed/` record for primary base
`endojs-endo-but-for-bots-pr771-review-c92c5d14`; ran a fresh judgment.

**Verdict: not-a-miss (new-direction).** The two-part review body (untrusted,
paraphrased) asked to (1) pin the drifting base to a frozen `master-xxx` and
rebase to germane commits only, and (2) do the yarn→npm migration properly —
there is no `npm.lock`, the analogous lockfile is `package-lock.json`, a blind
global text replace won't suffice.

**Grounds (from the PR's own history):** #771 is a deliberately-DRAFT fleet
npm-migration *experiment* (`isDraft=True`, authored by kriscendobot). No build,
clean, panel, or gauntlet job for #771 exists in `journal/jobs/tada/` — the
auto-gauntlet invariant is for mergeable-feature builds, not probes, so an
experiment PR legitimately never invokes the panel. There was thus no
review-process instance to "miss" these items; the maintainer's review is the
intended review-of-record for an experiment. Directive 1 is branch maintenance
(base drifted under the branch → 17 phantom commits), matching the recorded
`pr19-review-af733b76` dismissal and the frozen-base-branch/rebase family.
Directive 2 is first-stated domain guidance on a novel yarn→npm migration that no
garden seat/skill/gate encodes; the `npm.lock` gap surfacing is a probe's designed
output. Severity-bypass absent — nothing reviewed-and-wrong, no standing rule
bound and failed.

**What changed:**
- Recorded a durable dismissal:
  `review-misses/dismissed/endojs-endo-but-for-bots-pr771-review-c92c5d14.md`
  (via `review-miss-record.sh`; comment paraphrased, never pasted). No cluster
  minted, no threshold, no improvement job.
- This `result` journal entry.

No `main2` garden-library changes were needed. Inbox was empty. The primary loop
already addressed the feedback and is unchanged.

**Follow-ups:** None. If an npm migration is later promoted from draft experiment
to a mergeable build that runs the panel, a recurrence of the `npm.lock`-class
error at that stage would be a different, reviewable event.

Self-improvement: no friction worth encoding this run; the pr19 base-drift
dismissal precedent made the discrimination fast and well-grounded.

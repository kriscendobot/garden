---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr660-review-62ee5cda
verdict: not-a-miss
category: new-direction
pr: 660
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/660#pullrequestreview-4676445052
identity: endojs/endo-but-for-bots#660:review:4676445052:retro
producing_role: builder
severity: minor
grounds: >
  This retro judges whether the garden REVIEW PROCESS should have anticipated
  erights's review 4676445052 on #660 and concludes it should not: it is not a
  work-product defect at all but the maintainer managing his own approval state.
  #660 is a cross-package re-export refactor PR (marshal/captp/patterns slices),
  authored by the builder/gardener fleet. The review (paraphrased) carries a
  single sentence — cancelling a just-granted approval to buy himself time to
  answer the author's open scope questions — and zero inline comments: the
  primary loop (jobs/tada/endojs-endo-but-for-bots-pr660-review-62ee5cda.md)
  enumerated the inline comments tied to pull_request_review_id 4676445052 and
  found NONE, and reconstructed the sequence from the GitHub timeline: erights
  APPROVED ("LGTM, thanks!") at 04:09:05, then 52s later un-approved with this
  review body to give himself room to answer the three re-export-scope questions
  the PR author had deliberately flagged in the PR description ("Questions for
  @erights — uncertain scope, flagged not acted on"). The review indicts nothing
  the panel could have caught: it names no bug, no style or spec violation, no
  missed edge case, no convention. It is pure approval-workflow management by the
  maintainer, and the actual substantive answers arrived seconds later as a
  SEPARATE conversation comment (issuecomment 4942288215), which already has its
  own dedicated attention job (endojs-endo-but-for-bots-pr660-7dd088b1, since
  completed) that landed the one in-this-PR change and routed the other two to
  separate PRs. No standing garden rule bound and failed to fire — there is no
  instruction, seat brief, or skill that could or should predict a reviewer
  parking an approval. The severity-bypass precondition (a standing rule that
  existed and did not bind) is absent. Recorded as a durable dismissal so the
  same review is never re-litigated. No cluster minted; no threshold; no
  improvement dispatched.
---

# Dismissal: endo-but-for-bots #660 review 4676445052 (retro)

erights's review on #660 (the cross-package re-export refactor PR) is a bare
approval-cancellation: he had APPROVED the PR, then 52 seconds later un-approved
with a one-sentence body saying he was cancelling the approval until he could
answer the author's open questions. The review carries zero inline comments and
zero code directives. Not a garden review-process miss — it is the maintainer
managing his own approval state, not a defect the work shipped with. Nothing the
panel or gauntlet could have anticipated: the review names no bug, style/spec
violation, edge case, or convention, and no standing garden rule bound and failed
to fire (no rule can or should predict a reviewer parking an approval). The
maintainer's actual substantive answers came seconds later as a separate
conversation comment (issuecomment 4942288215), which was handled by its own
dedicated peer job. New direction / process, not a miss. No cluster, no
threshold, no improvement dispatched. See comment_url for the verbatim text.

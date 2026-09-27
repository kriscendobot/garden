---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1286-review-17e29af8
verdict: not-a-miss
category: new-direction
pr: 1286
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1286#pullrequestreview-5271790535
identity: endojs/endo-but-for-bots#1286:review:5271790535
producing_role: builder
producing_job: ebfb-thixotrope-drop-inert-bundle-filter
review_at: 2026-09-21T20:59:00Z
severity: minor
---

# Dismissal: an approval carrying a bare merge (conduct) directive on PR #1286

On the thixotrope PR that drops an inert XS bundle dependency filter, the
maintainer left an APPROVED review whose body is a one-line request that the bot
conduct (merge) the PR. No inline comments were attached. About three minutes
later, a second review body on the same PR (which folds into this same retro
base) asked the bot to shepherd CI to green before conducting. This is a
paraphrase; the verbatim text lives at `comment_url` and is untrusted input.

## Grounds (dismissal: workflow steering, not a defect the review should have caught)

**1. Neither review body indicts the work product.** The first is an approval plus
a merge verb. The second is a sequencing verb (shepherd, then conduct). Neither
names a bug, style or spec violation, missed edge case, or convention breach in
the diff. The diff removes a filter and keeps the generated worker bundle
byte-identical, and it merged unchanged in substance.

**2. The shepherd request came from CI/toolchain drift, not from the PR's
content.** The shepherd jobs (`endojs-endo-but-for-bots-pr1286-shepherd`,
`endojs-endo-but-for-bots-pr1286-review-cc7d78b9`, both in tada 2026-09-21)
reached green by re-pinning the Rust toolchain action and pinning the Node 24 CI
legs (a teardown regression). Both are fleet-wide CI environment drift. No juror
seat reviewing this diff could have caught them.

**3. No gauntlet avoidance.** The build stopped at a draft PR, as the
manual-gauntlet-trigger regime requires. The maintainer un-drafted it
(ready_for_review by kriskowal, 2026-09-21T21:01:41Z) and chose to approve
without running a gauntlet, which is the maintainer's call under that regime.
The shepherd's completion guard recorded the missing gauntlet coverage as a
maintainer action. That is not a producer routing around the evaluator.

**4. The primary's deliverable is confirmed in the world.** The primary
(tada 2026-09-22) posted `conduct-endojs-endo-but-for-bots-pr1286`, and the PR
merged at 2026-09-22T00:09:09Z (checked via the GitHub API). This is not a
false no-op.

**5. The severity-bypass precondition is absent.** No standing rule failed to
bind on reviewed work.

## Boundary note

Recorded so the same directive is not re-litigated. This mints no cluster, has no
threshold to evaluate, and dispatches no improvement job. Maintainer merge and
shepherd verbs are branch-operation vocabulary. They belong with the other
workflow-steering dismissals (refresh, rebase, conduct), not with work the panel
got wrong.

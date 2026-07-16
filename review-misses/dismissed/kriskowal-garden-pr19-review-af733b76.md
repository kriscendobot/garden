---
kind: review-miss-dismissed
primary_job: kriskowal-garden-pr19-review-af733b76
verdict: not-a-miss
category: new-direction
pr: 19
repo: kriskowal/garden
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriskowal/garden/pull/19#pullrequestreview-4700828780
identity: kriskowal/garden#19:review:4700828780
producing_role: builder
producing_job: build-bid-accept-market-phase0-1
severity: minor
---

# Dismissal: refresh PR #19 because the base branch advanced beneath it

On the bid/accept-market Phase 0/1 build PR, the maintainer left a
CHANGES_REQUESTED review with a one-line request to refresh the branch because
changes had landed on the base beneath it. No inline/line comments accompanied
the review (zero review comments on the API). This is a paraphrase; the verbatim
one-sentence request lives at `comment_url` and is untrusted input.

## Grounds (dismissal — new direction, nothing for the panel to have anticipated)

**1. A refresh request from base-branch drift is an operational/temporal event,
not a defect a review could have caught.** The review says only "please refresh —
things moved beneath this." It indicts no bug, style violation, spec breach,
missed edge case, or violated convention in the reviewed work product; it asks for
a mechanical rebase because `main2` advanced after the PR was created. No juror
seat, pre-push gate, or standing instruction could have "caught" that the base
branch would move under the branch later — that is normal, expected branch
maintenance, the branch-op verb `refresh` in the orchestrator vocabulary, and the
subject of the `rebase-before-followup` / `frozen-base-branch` skills. It is the
canonical `new-direction` case: a requirement first arising after review, elected
by the maintainer, not a review miss.

**2. The reviewed work in fact ran its gauntlet and had no surviving defect.**
PR #19 came through `build-bid-accept-market-phase0-1`, which ran the build
gauntlet and adversarial panel self-review (28/28 hermetic tests, seven risk areas
cleared) before un-drafting. The refresh directive is orthogonal to that review:
when the primary loop (`kriskowal-garden-pr19-review-af733b76`) refreshed to
current `main2`, the sole build commit was already superseded upstream, the
resulting PR was empty, and GitHub auto-closed it. There was no reviewed defect to
re-catch — the branch had simply been overtaken by other work on the base.

**3. Severity-bypass precondition absent.** The bypass requires a `major` miss
whose grounds cite a standing rule that bound on a reviewed work product and did
not fire. Nothing here was reviewed-and-wrong and no rule was violated; the request
is workflow steering (refresh/rebase), not sense-and-correct on a defect.

## Boundary note (auditable calibration)

Recorded so a future retro on this same directive is not re-litigated. Mints no
cluster; no threshold to evaluate; no improvement job. A maintainer asking to
rebase a branch whose base advanced is pure branch maintenance — it clusters
conceptually with the fleet's other maintainer-steering / workflow dismissals
(the "how to slice and land in-progress work" family), never with "work the panel
got wrong."

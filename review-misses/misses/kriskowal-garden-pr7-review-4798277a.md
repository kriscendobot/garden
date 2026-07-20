---
kind: review-miss
primary_job: kriskowal-garden-pr7-review-4798277a
verdict: miss
category: process
pr: 7
cluster: garden-design-pr-gauntlet-bypass
cluster_pattern: A garden-owned design PR is opened as an exceptional review surface but reaches maintainer review without the required design-panel gauntlet, leaving substantive design assumptions and rollout constraints for the maintainer to discover.
repo: kriskowal/garden
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriskowal/garden/pull/7#pullrequestreview-4719529711
identity: kriskowal/garden#7:review:4719529711:retro
producing_role: researcher-designer
producing_job: investigate-systemd-run-vs-gardener-loops
missed_by: design-panel gauntlet, especially critic and skeptic
severity: minor
---

# Miss: exceptional garden design PR bypassed the design-panel gauntlet

The maintainer's review required the proposal to establish gentler polling,
centralize dispatch ownership, consult historical evidence, and reduce the pilot
to one non-disruptive lane. This paraphrase deliberately omits the untrusted
review text, which remains available only at `comment_url`. The primary loop
revised the design and pilot staging in `625b1233`; this record concerns the
earlier review gap.

## Grounds

This is a review-process miss, not merely new direction. The PR was a
design-only draft, and the documented design-only route requires the design
panel and its fixer loop before the PR is made ready for maintainer review.
The journal has the originating investigation job and this review-response job,
but no completed gauntlet or panel job and no formal garden panel review for PR
7. The PR's exceptional permission to use the garden's own repository as a
reviewable design surface did not waive that design-panel route.

The absent panel had standing coverage for the feedback's reviewable parts.
The critic is charged with testing the proposed approach, its constraints, and
its rejected alternatives. The skeptic must attack upstream-interface assumptions
and the completeness of the proposed test and evidence plan. Those lenses should
have required evidence for the polling premise, challenged a broad dispatcher
rollout, and asked for a staged, non-disruptive experiment before maintainer
review. Some rollout choices remain maintainer direction, but the missing panel
removed the existing mechanism that could have surfaced their risks.

## Threshold call

This mints `garden-design-pr-gauntlet-bypass` at count=1 and prs={7}, below the
default floor of three misses across two PRs. Hold: severity is minor and no
standing rule was shown to have bound and failed at a completed panel stage; the
failure was that the stage never ran. No improvement job is dispatched. A future
matching miss should test both prevention (enforce the exceptional garden-design
route) and sensing (a durable check that a design PR has a formal panel verdict
before it enters maintainer review).

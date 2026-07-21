---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr809-review-581b1021
verdict: miss
category: process
pr: 809
cluster: garden-design-pr-gauntlet-bypass
cluster_pattern: A garden-authored design PR reaches maintainer review without the required design-panel gauntlet, leaving substantive interface and rollout assumptions for the maintainer to discover.
review_at: 2026-07-21T04:37:20Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/809#pullrequestreview-4741289297
identity: endojs/endo-but-for-bots#809:review:4741289297:retro
producing_role: gardener
producing_job: issue-kriskowal-garden-59
missed_by: design-panel gauntlet
severity: minor
---

# Miss: design PR bypassed the design-panel gauntlet

The maintainer review at `comment_url` required the persistent-store design to
specify its human-facing command vocabulary and safe representation of arbitrary
passable keys. This paraphrase omits the untrusted review text. The primary loop
added the missing design material; this record concerns the earlier review gap.

## Grounds

This is a review-process miss, not new direction. The originating completion for
`issue-kriskowal-garden-59` explicitly required the design PR to run the
gauntlet. The journal contains the design-creation job, the maintainer review,
and the primary review-response job, but contains no completed gauntlet or panel
job for PR 809 and no panel PR comment. Consequently, the established design
review step never tested whether a proposal for public persistent collections
defined coherent CLI and WUI operations or a non-evaluating encoding boundary
for passable keys before maintainer review.

This joins `garden-design-pr-gauntlet-bypass`: like its existing member, a
garden-authored design surface reached the maintainer without the required panel.
The absent design-panel lenses could have challenged the completeness of the
interface proposal and required the operational boundary to be made explicit.

## Threshold call

This is the second member and supplies a second PR to
`garden-design-pr-gauntlet-bypass` (count=2, prs={7,809}), still below the
default floor of three misses. Hold. Severity is minor, so the standing-rule
bypass does not apply. No improvement job is dispatched. A next matching bypass
must re-evaluate prevention of skipped design gauntlets together with a durable
check that a reviewable design PR has a formal panel verdict before maintainer
review.

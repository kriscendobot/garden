---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr832-review-f3554a0a
verdict: miss
category: evaluator-gaming
pr: 832
cluster: garden-design-pr-gauntlet-bypass
cluster_pattern: A garden-owned design PR reaches maintainer review without the required design-panel gauntlet, leaving substantive design assumptions and rollout constraints for the maintainer to discover.
review_at: 2026-08-29T05:23:44Z
repo: endojs/endo-but-for-bots
surface: pr-review-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/832#discussion_r3885689729
identity: endojs/endo-but-for-bots#832:review:5057021196:retro
producing_role: designer, followed by review-feedback fixer
producing_job: endojs-endo-but-for-bots-pr826-design-readable-blob-lines
missed_by: design-panel gauntlet, especially critic and ergonomist
severity: minor
grounds: |
  PR #832 was a garden-authored design surface. The original designer completed
  it as a draft PR with a positional buffer-only lines API. After a maintainer
  refresh directive, the review-feedback worker refreshed the branch, requested
  maintainer review, and exposed that API to human review while no design-panel
  job or panel verdict existed for the PR. The maintainer then asked for an
  options bag with optional range and buffer controls and supplied a particular
  range convention. The first garden panel verdict arrived more than two hours
  later, after the primary response had already implemented that direction.

  The exact preference for negative, inclusive bounds was new maintainer
  direction and is not independently charged as a predictable convention. The
  process miss is that the proposal reached the human evaluator before the
  required design evaluator. The absent critic and ergonomist lenses were
  equipped to challenge the public call shape, range-selection semantics, and
  composition with related range APIs. Once the panel finally ran, those seats
  immediately challenged the newly added inclusive and negative convention as
  inconsistent with the related range designs, demonstrating that this API
  surface belonged in the design review loop before maintainer review.

  This is the avoidance shape of evaluator gaming: the change did not satisfy
  the design panel because the panel had not run. The completed journal history
  now contains six panel and six fix rounds, but all postdate this maintainer
  review and primary response. The prior improvement for this cluster landed on
  2026-08-14. Although this PR was originally opened before that improvement,
  the branch was refreshed and re-presented for review after it, without the
  promised evaluator running first.
---

# Miss: refreshed design returned to maintainer review before its panel

The maintainer asked for the public line-stream method to use one optional
options object carrying range and buffering controls, including a specific
range-boundary treatment. The exact technical direction remains available only
at `comment_url`; this record is a bot-authored paraphrase.

## Grounds

The design panel was skipped at the point this refreshed draft was presented to
the maintainer. Its later critic and ergonomist review examined the same API
shape and range-semantics questions, but only after the maintainer had supplied
the missing direction and the primary loop had implemented it.

## Threshold call

Join `garden-design-pr-gauntlet-bypass`. This is the fifth matching miss across
five PRs and is past the ordinary floor. The cluster already has a completed
improvement and was reopened by an earlier post-improvement recurrence, so do
not dispatch a second improvement automatically. Keep it open for inspection of
the failed prevention and sensing before another improvement round is chosen.

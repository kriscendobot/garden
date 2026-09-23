---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr658-review-97e5a186
verdict: miss
category: process
pr: 658
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/658#pullrequestreview-4689484656
identity: endojs/endo-but-for-bots#658:review:4689484656:retro
producing_role: gardener
producing_job: gauntlet-endo-but-for-bots-pr658-mount-cli-path-verbs
missed_by: code-panel scope (no existing-surface equivalence check)
severity: moderate
cluster: existing-cli-surface-equivalence
cluster_pattern: A code-panel approves a new CLI verb or path-specific branch without tracing the existing command's equivalent virtual-filesystem route, so redundant public surface reaches maintainer review.
---

# Miss: redundant mount-path reader branches on #658

The maintainer review at `comment_url` identifies that the added mount-specific
reader paths duplicate behavior already reachable through the CLI's ordinary
slash-path traversal. The primary review job confirmed that diagnosis by tracing
the current directory and mount lookup path: ordinary `cat` and `ls` already
descend through a mounted name hub. It also separated the independent write-path
question, where no existing CLI route reaches the mount writer.

## Grounds (miss)

This is a review-process miss, not new direction. The gauntlet report records a
completed code panel and its formal PR review approved the exact head. That
review asserted that the three named mount-path verbs matched the phase design
and that existing reader behavior was unchanged, but it did not test whether
the proposed reader branches were already equivalent to the pre-existing
virtual-filesystem path form. The later review and the primary job's code trace
establish that the two reader branches were redundant and the PR was ultimately
closed rather than reshaped in place.

The gap is in panel process rather than a skipped gauntlet: the panel ran, but
has no durable existing-surface equivalence check for an additive CLI branch.
The feedback was thus foreseeable by tracing the existing command before
approving the new route. The write-path rationale is not included in this miss,
because the primary job found it was a genuine missing surface.

## Threshold call

This record mints `existing-cli-surface-equivalence` at count=1 on PR 658.
Hold below the default floor: it has neither three recorded misses nor two
distinct PRs. The severity bypass does not apply. No standing seat brief, gate,
or skill is shown to require this equivalence trace, so this is a prevention and
sensing gap to accumulate rather than a major failure of a rule that already
bound. A later similar panelled redundant-surface finding should join this
cluster and be re-evaluated for an improvement that teaches the relevant panel
seat to compare added CLI routes with existing routes and supplies a durable
review-cycle trigger.

---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr658-8df22a40
verdict: not-a-miss
category: new-direction
pr: 658
repo: endojs/endo-but-for-bots
surface: pr-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/658#issuecomment-4977137707
identity: endojs/endo-but-for-bots#658:comment:4977137707:retro
---

# Dismissal: orthogonal follow-up design requests and a close on #658

The maintainer comment at `comment_url` does three things: it asks for a
follow-up **design** job to improve an existing, unrelated CLI reader mode
(the JSON listing output), asks for a second follow-up **design** job to move a
write capability off the mount-specific hub and onto the ordinary directory
abstraction, and directs the PR closed. It indicts nothing the panel shipped; it
sets forward direction and hands off two new, explicitly orthogonal work items.

## Grounds (not a miss)

This is new direction, not a review-process miss. Both requests are forward
design tasks, one of which the maintainer explicitly labels orthogonal to the
PR's scope, and neither is a bug, spec violation, missed edge case, or violated
convention the panel demonstrably knew.

The gauntlet for this PR ran a full four-seat code panel that approved the head
with no in-scope must-fix and already documented the mount-UX rough edges as
out-of-scope follow-ups; the maintainer's comment does not fault any of that
work. The first request is a quality improvement to a pre-existing reader mode
that is not what this PR changed. The second is an architectural steer — that the
write method should live on the ordinary directory abstraction rather than be
treated as special to mounts — first stated in this comment as a follow-up design
direction; no seat brief, skill, or standing instruction encodes a rule the panel
could have applied to anticipate a maintainer's future placement preference for a
not-yet-generalized capability. The accompanying "close this" is a scope handoff,
not a defect report.

Note for calibration: a separate, earlier review body on this same PR
(`endojs-endo-but-for-bots-pr658-review-97e5a186`) *was* recorded as a genuine
miss (redundant mount-path reader branches vs. the existing virtual-filesystem
route → cluster `existing-cli-surface-equivalence`). This dismissal is scoped
strictly to the later directive-attention comment `4977137707`, which raises only
new forward-looking design work and does not re-raise that redundancy finding.

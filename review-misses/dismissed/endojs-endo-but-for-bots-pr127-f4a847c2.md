---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr127-f4a847c2
verdict: not-a-miss
category: new-direction
pr: 127
repo: endojs/endo-but-for-bots
surface: pr-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/127#issuecomment-4951438710
identity: endojs/endo-but-for-bots#127:comment:4951438710
producing_role: gardener
producing_job: endojs-endo-but-for-bots-pr127-f4a847c2
severity: minor
---

# Dismissal: append a fused `glorp(glob, grep)` search primitive to the mount-extensions stack

On the long-lived `feat/mount-extensions` stack, the maintainer directed the fleet to add a new
`glorp(glob, grep)` function that composes glob and grep into a single operation shaped so a
native filesystem layer can push it down and fuse the two patterns into one enumerate-and-scan
pass (rather than round-tripping a glob result set through JS the way `grep(pattern, { glob })`
does). This is a paraphrase; the verbatim one-sentence request at `comment_url` is untrusted input.

## Grounds (dismissal — new direction, nothing for the panel to have anticipated)

**1. The directive is a first-stated feature request, not a correction of a defect the review
missed.** The maintainer is asking for net-new API surface — a two-required-positional
composition primitive designed for a specific native push-down property — that did not exist in
any form the panel could have flagged for absence. Adding a new function to a feature stack on
request is the textbook `new-direction` category: taste-and-scope work the maintainer elected to
add, never work a juror seat, gate, or standing instruction "should have caught." There is no
convention, spec, or edge case the review let through here; there was no `glorp` to review.

**2. PR #127 is a re-opened, long-lived feature branch that never ran — and was not due to run —
the garden's code panel.** No gauntlet or panel job for #127 exists anywhere on the board
(`jobs/tada/` holds only the two directive-response primaries and their retros; no `*-gauntlet*`
or `*-panel*` job was ever created). The maintainer's comment *is* the review surface, and the
primary loop responded exactly as intended: a gardener implemented `glorp` on `feat/mount-extensions`
(commit `6ad77bf88`) with interface guard, types, help entries, and a mount test. There was no
earlier panel run to indict.

**3. Same shape as the prior #127 dismissal and the mount-extensions family.** This clusters
conceptually with the PR's earlier `new-direction` dismissal
(`endojs-endo-but-for-bots-pr127-review-8526a0a6`, the reconstruct-and-split review) and the
repo's other maintainer-steering dismissals (#632, #614, #611): the maintainer directing *which
correctly-shaped work to do next* on an in-progress stack, never *work the panel got wrong*. The
severity-bypass precondition (a major miss whose grounds cite a standing rule that bound on a
reviewed work product and did not fire) is absent — nothing was reviewed and no rule was violated.

## Boundary note (auditable calibration)

Recorded so a future retro on this same directive is not re-litigated. Mints no cluster; no
threshold to evaluate; no improvement job. The taxonomy sheds this cheaply: a forward feature
directive on a never-panelled feature stack is the canonical dismissal.

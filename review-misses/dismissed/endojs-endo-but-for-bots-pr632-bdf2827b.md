---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr632-bdf2827b
verdict: not-a-miss
category: new-direction
pr: 632
repo: endojs/endo-but-for-bots
surface: issue-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/issues/632#issuecomment-4910941910
identity: endojs/endo-but-for-bots#632:comment:4910941910:retro
producing_role: gardener
producing_job: endojs-endo-but-for-bots-632-bdf2827b
severity: minor
---

The maintainer directed the bot to apply the standing text-reuse permission that
@erights had just granted in issue #632 to two specific draft PRs (#631 and
#630), thanked the granting author, and affirmed that continuing to cite the
originals on erights.org remains appropriate (paraphrase; verbatim at
`comment_url`). It is a forward coordination/permissions directive — carry a
newly-granted external permission into named PRs — not a defect the review
failed to catch.

**Grounds (dismissal — new direction, nothing to anticipate).** Issue #632 is
the thread in which a third party (Mark S. Miller, @erights) granted
@kriscendobot standing permission to reuse/adapt/derive-from his public texts on
the sole condition that adaptations stay marked as *derived from*, not *the*,
original. The maintainer's comment is the act of *electing to apply* that fresh
grant to #630 (the Grant Matcher Puzzle translation) and #631 (the
thesis-translation design), both of which were drafts explicitly gated on
exactly this author permission. This requirement did not exist until @erights
granted it in this thread and the maintainer chose, in this comment, to extend
it to these two PRs — it is a first-stated instruction, the textbook
new-direction dismissal category. No juror seat, gate, or standing instruction
could have "caught" it earlier: there is no work product with a defect here, and
no panel runs against a maintainer's decision to route a just-granted external
permission into specific draft PRs. The garden's own posture was already
correct — the standing-permission record had landed on main2 (`7aa0b6b21`) and
the primary job (`endojs-endo-but-for-bots-632-bdf2827b`) applied the grant to
both PRs, retained the erights.org citations per the maintainer's note, and
correctly *declined* to un-draft either (each still carries independent
unresolved draft reasons). Review sensing had no gap to close; the directive was
addressed as written in the (unchanged) first loop.

**Boundary note (auditable calibration, not a miss).** This is the boundary
case the taxonomy is built to shed cheaply: a permissions/scope coordination
message that names PRs but indicts no work. It clusters with the other
new-direction dismissals on this repo (e.g. #614's "please action the
already-surfaced follow-ups") — the maintainer steering *which already-correct
work to do next*, never *work the panel got wrong*. Recorded so a future retro
on the same shape (maintainer relaying/applying an external permission grant) is
not re-litigated. No cluster minted; no threshold to evaluate; no improvement
job.

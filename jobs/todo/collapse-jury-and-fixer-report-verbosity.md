---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Collapse verbose aggregated reports behind `<details>` disclosure triangles

GitHub comment bodies render `<details><summary>...</summary>...</details>`
natively as a collapsed, expandable disclosure triangle. Apply this, going
forward, to two report shapes that have grown genuinely hard to scan — this
session's SES PR (endojs/endo-but-for-bots#1281) panel round 6 comment is a
concrete example: the top-level verdict summary is a handful of lines, but
the full per-seat detail below it runs many hundreds of lines in one
undifferentiated block.

## 1. Aggregated jury (panel) reports

`scripts/jobs/gardening/panel.sh` assembles the review body per seat, in
seat order, into an aggregate file (`$agg`) — see the per-seat loop around
where each `### $seat` header, block content, and
`seat_provenance_footnote` are appended (search `seat_provenance_footnote`
in that file as your anchor). Above that per-seat detail, a decider-composed
header currently reads like:

```
## Panel verdict — round N · disposition: **must-fix**
<bucketed summary bullets>
Full per-seat verdicts (with provenance) below.
---
### assessor
<full block>
### typist
<full block>
...
```

Change: wrap **each seat's full block** (everything currently under its
`### $seat` heading, including its provenance footnote) in a `<details>`,
with the `<summary>` carrying enough to scan without expanding — at minimum
the seat name and its verdict (approve / request-changes / comment-only),
e.g. `<summary><b>assessor</b> — request-changes</summary>`. The **top-level
summary** (the "## Panel verdict — round N" header, disposition, and the
bucketed "Request-changes findings this round" bullets the decider already
composes) stays fully visible, unwrapped — that's the part a reviewer scans
first and must not require expanding anything to see. Find wherever this
header is composed (the decider's own output, or a template panel.sh
prepends — trace `decide_disposition` and whatever assembles the final `gh
pr review`/`gh api .../reviews` body) and leave it untouched; only the
per-seat detail beneath it gets wrapped.

Verify GitHub actually renders this correctly inside a `gh pr review --body`
(some Markdown-in-HTML contexts need a blank line after `<summary>` before
Markdown content renders instead of showing as literal text inside the
`<details>` block — test this empirically against a real PR, don't assume).
Keep the per-section provenance footnote **inside** the seat's collapsed
block (immediately after its content, as today), not moved outside it.

## 2. Fixer reports (`pr-completion-summary-comment`)

Same treatment, with one deliberate exception the maintainer was explicit
about: **do not hide the loop-status signal.**

The required top-level PR summary comment
([pr-completion-summary-comment](../../skills/pr-completion-summary-comment/SKILL.md))
already aims to be scannable (head SHA, what changed, what was declined,
verification status). Where it grows long — a bulleted item-to-SHA map with
many entries, full command output, a long diff excerpt, detailed
per-item reasoning — wrap that bulk in `<details>`. But keep VISIBLE,
outside any collapsed section, clear evidence of whether the feedback loop
is **continuing or quiescing**: at minimum, the round/iteration number when
this is a gauntlet fix stage (`gauntlet_iteration` in the job frontmatter is
already tracked — surface it in the comment, e.g. "Fix round 6"), CI status
(green/red/pending), and whether another panel pass is expected next or the
loop has converged (approved / un-drafted / merged). A maintainer skimming
the PR thread should be able to tell "is this still churning or is it done"
without expanding a single `<details>` block.

Update the skill doc (`skills/pr-completion-summary-comment/SKILL.md`) to
document this shape (the floor is now: visible loop-status line + scannable
summary, with bulk detail collapsible) and `skills/panel-review/SKILL.md`
similarly for the jury-report shape. Regression-test what's testable
(e.g. a unit test asserting the loop-status line is NOT inside a `<details>`
tag in a generated comment body, if there's a script-level composer to test
rather than pure LLM-authored prose).

This is a going-forward formatting change only — do not retroactively edit
already-posted comments.

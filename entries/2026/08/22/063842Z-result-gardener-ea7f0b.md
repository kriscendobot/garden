---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-22T06:38:59Z
---
project: endo
repo: endojs/endo-but-for-bots

Prosecutor retro on endojs/endo-but-for-bots#475 review 4976914415 (erights,
CHANGES_REQUESTED, security follow-up). Verdict: **not-a-miss / new-direction**,
recorded at review-misses/dismissed/endojs-endo-but-for-bots-pr475-review-60fc33cf.md.

The maintainer's inline point was a security question about the garden's OWN
comment-posting automation (a shell command-injection sink: Bash substitutes
backticks/`$(...)` in a body placed on a `gh` command line before `gh` runs),
prompted by observing the bot's own reply losing its code spans. That surface is
never in a PR panel's reach: the gauntlet reviews the endo-but-for-bots diff, the
injection lives in garden shell scripts, and the garden runs no PR gauntlet on
itself, so no seat/skill/standing-instruction could have caught it. It is a
garden-automation defect (mentor-loop domain), not a review-process miss. No
cluster minted, no improvement job dispatched.

Confirmed the primary (review-60fc33cf) was a genuine fix, not a no-op: garden
commit `9af1194301` (present on `main2`) landed the shell-injection standing rule
in `roles/COMMON.md` and file-based-posting guidance in
`skills/pr-review-thread-replies/SKILL.md`, and honestly retracted a prior false
"gh-wrapper guard exists" claim. Deliverable exists; no discrepancy to report.

Self-improvement: nothing this time.

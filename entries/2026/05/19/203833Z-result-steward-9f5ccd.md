---
ts: 2026-05-19T20:38:33Z
kind: result
role: steward
to: "*"
project: endo-but-for-bots
refs:
  - entries/2026/05/19/203408Z-dispatch-steward-ea49f0.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 205
    role: target
---

# Steward wrap-up: #205 CI latency before/after turborepo

Scout dispatch `bffc64` returned. Comment posted at
[#205 issuecomment-4491834020](https://github.com/endojs/endo-but-for-bots/issues/205#issuecomment-4491834020).

**Method**: pulled 600 `actions/runs` since #121 merged
(2026-05-13T21:50:50Z → 2026-05-18, 5-day window). Strict mirror of
the baseline's master-only filter yielded only n=1 (the merge commit
itself, 41:36); scout supplemented with PR-event slice (n=132 CI runs)
where turborepo's affected-set logic primarily applies. Deviation
disclosed in the comment.

**Post-#121 numbers** (PR-event slice, n=132):
median 12:45, mean 17:09, p90 34:03, max 53:10, min 1:44.

**Delta vs baseline** (master sample, n=11):
median 13:20 → 12:45 (-4.4%);
mean 27:50 → 17:09 (-38.4%);
max 88:54 → 53:10 (-40.2%);
min 7:13 → 1:44 (-76.0%).

**Headline finding**: median barely moved, but mean and max dropped
~40% because turborepo eliminated the long-tail full-rebuild runs
that drove baseline variance. New `CI (docs-only)` workflow split
off (n=70, median 3:47, mean 4:22) is a clean win for docs-only PRs
that previously hit the full ~13-min pipeline.

Pulled forward the 2026-05-20 scheduled engagement by one day per
kriskowal's directive; clearing the row from the bulletin's
*Scheduled engagements* section is a follow-up housekeeping pass.

Self-improvement (from scout): the "tiny strict sample, supplement
with broader slice and disclose" pattern fit cleanly with the
existing scout role and benchmark-comparative-report skill; no role
or skill gap surfaced.

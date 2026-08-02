---
gate: orchestrated
orchestrated_by: garden-budget-attribution
priority: normal
role: assayer
posted_by: producer
posted_at: 2026-08-02T21:05:35Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800

# Budget 3/5 — aggregate session cost up to merged pull requests

Third child of orchestration `garden-budget-attribution`. Runs after
`garden-budget-ledger` and **depends on its output** — read that job's `tada/`
report first. If the ledger did not land, or landed with coverage too low to
aggregate meaningfully, say so and stop rather than producing a number you cannot
defend.

## Goal

Roll per-session cost up to the **merged pull request** — the maintainer calls
this the *Gimix escrow oracle*: the unit of delivered value the garden should be
able to price.

## The join is the hard part — do not regex the prose

A liaison sampled 600 `jobs/tada/*.md` reports and found only **16%** cite a PR
URL anywhere in their body (95 reports, 111 distinct PRs). Report prose is not a
reliable join key. Build a real one. Candidate spine, in rough order of
reliability:

- job base → per-job worktree (`scripts/jobs/ensure-project-worktree.sh`, keyed
  by job base) → branch → PR
- the job body's `pr:` frontmatter and the gauntlet stage fields
  (`gauntlet`, `gauntlet_stage`, `pr:`) — present on staged jobs
- `journal/pr-mirrors/` and `journal/panel-runs/` — both already key by PR
- the comment/CI watchers' directive identity (`jobs/index/<hash>`), which maps a
  GitHub comment to the job it minted

Measure and report join coverage. A PR whose cost is assembled from 3 of its 9
contributing jobs must be labelled as such, not published as the PR's cost.

## Also

Many jobs legitimately map to **no** PR (scholar cycles, presses, watchdogs,
garden-internal builds). Those are real cost against the same budget. Decide how
they are represented — an "unattributed" bucket is acceptable and honest; silently
dropping them is not, because the per-PR figures would then understate the true
cost of running the garden.

## Definition of done

A deterministic job→PR join with a measured coverage figure; per-merged-PR cost
aggregation on the true-cost basis from child 1; an explicit unattributed bucket;
a `tada/` report showing the top PRs by cost and stating join coverage plainly.

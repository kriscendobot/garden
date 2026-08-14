---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Produce a progress report covering all garden development activity in the last
month: 2026-07-14T00:00:00Z through 2026-08-14 (now).

Follow the journalism skill (skills/journalism/SKILL.md) and the
daily-progress-summary method (roles/journalist/AGENT.md § Daily progress
summaries) as your method, but produce ONE consolidated report spanning the
whole window rather than a per-day periodical.

## Data sources

- For 2026-07-14 through 2026-07-31: daily periodicals already exist at
  journal/periodicals/2026/07/{14..31}.md — synthesize from those rather than
  re-scanning raw entries for that span.
- For 2026-08-01 through 2026-08-14: NO periodicals exist. All 23 recurring
  schedules (including daily-progress-summary) were paused 2026-08-01T16:34:11Z
  (maintainer directive: token spend too fast) — see journal2 commit
  41ba8b4eb0. For this span, scan journal/entries/2026/08/{01..14}/ directly
  (progress, result, tick, dispatch, message, worktree entries) plus board
  transitions (jobs/{todo,doin,tada} git history) per the daily-progress-summary
  method. State the schedule-pause explicitly in the report as the reason
  August's coverage is reconstructed from raw entries rather than periodicals,
  so the reader doesn't misread thinner periodical coverage as reduced
  development activity.

## Scope

Every project (partition by `project:` slug) plus garden-meta activity, same
partitioning as the daily-progress-summary. Write an abstract first: a few
paragraphs giving the maintainer the headline picture of what shipped, landed,
or materially progressed over the month. Then body sections by project,
covering major PRs/features landed, notable blockers or halts and how they
resolved, and any standing issues still open at window's end. Cite source
entries and periodicals by relative path; paraphrase, do not copy. House style
(em-dash-style, relative-paths, no-latin-shorthand) applies throughout.

## Output

Write the report to
journal/reports/monthly-progress-2026-07-14-to-2026-08-14.md, committed and
pushed to journal2 through the usual CAS.

## On completion

Post a maintainer-facing digest via `message-user.sh` (`GARDEN_SENDER` should
identify you, e.g. `gardener:<this-job-base>`): the report's relative path, a
two-to-three sentence headline of the month's biggest developments, and a note
that this was requested in a liaison conversation on 2026-08-14 (tag
`reply_to` this job's base).

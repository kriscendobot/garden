---
ts: 2026-05-13T00:47:53Z
kind: message
role: steward
project: endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/13/000020Z-message-steward-afa436.md
---

# CI latency baseline for #205

The maintainer asked at endojs/endo-but-for-bots#205 (2026-05-11T00:43Z)
for a CI latency report, intended to run periodically so #121
(turborepo) can be evaluated for improvement once it lands. PR #121
is still OPEN and `CONFLICTING`, so this is a pre-#121 baseline.

**Scope of this snapshot.**

- Repository: `endojs/endo-but-for-bots`.
- Branch: `master`.
- Window: the 100 most recent runs on master (the full visible page),
  which covers 2026-04-23 through 2026-05-12 (about three weeks).
- Method: top-level workflow run latency only
  (`updated_at - run_started_at`); the per-job breakdown the prior
  steward's brief mentioned is left for a future report when a job-
  level comparison against #121 is wanted. The top-level number is
  what the maintainer experiences as "time from push to green/red".
- Source query (read-only):
  `gh api 'repos/endojs/endo-but-for-bots/actions/runs?branch=master&per_page=100&page=1'`.

## Per-workflow stats (all master-branch runs, 2026-04-23 → 2026-05-12)

| Workflow | Runs | OK | Fail | Min | Median | Mean | Max |
|---|---|---|---|---|---|---|---|
| Browser Tests | 11 | 11 | 0 | 1:51 | 2:09 | 3:59 | 14:08 |
| **CI** | **11** | **9** | **2** | **7:13** | **13:20** | **27:50** | **88:54** |
| Deploy TypeDoc site with GitHub Pages | 11 | 0 | 11 | 0:10 | 0:23 | 0:36 | 1:53 |
| Release | 11 | 0 | 11 | 0:06 | 0:26 | 0:34 | 1:42 |
| Test project mutual dependency versions | 11 | 11 | 0 | 0:20 | 0:31 | 0:48 | 1:59 |

Times are `m:ss`. The headline is the **CI** workflow, the only one
that runs the test suite proper. Median 13m, mean 28m, max 89m. The
spread is large; the variance is the interesting signal.

## Weekly trend for the CI workflow

| Week starting | Runs | OK | Fail | Median | Mean | Max |
|---|---|---|---|---|---|---|
| 2026-04-23 | 4 | 3 | 1 | 8:00 | 9:03 | 13:20 |
| 2026-04-30 | 4 | 3 | 1 | 61:33 | 48:58 | 88:54 |
| 2026-05-07 | 3 | 3 | 0 | 21:43 | 24:40 | 39:29 |

The 2026-04-30 week is a clear outlier; one or more runs ran near the
6-hour GitHub Actions soft cap. The 2026-05-07 week pulled the median
back to ~22m, still ~2.7x the pre-spike baseline. With pre-#121 data
this noisy, the maintainer should expect that the meaningful signal
once #121 lands is a 3–4 week running median, not a single-week
delta.

## Side-finding (not in the original ask)

Two workflows are 100% failing across the window: **Deploy TypeDoc
site with GitHub Pages** (11/11 failures) and **Release** (11/11
failures). Latencies are all sub-2-minute, so these are early-step
failures (auth, configuration), not real workloads. This is a
separate bug class from CI latency; surfacing it here because it
showed up in the same query and the maintainer may not have noticed
both at 100%. A fix here does not affect CI latency, but a green
Release workflow is presumably the desired steady state.

## Authority gap

The steward cannot post this report to issue #205 as a comment: the
garden's external-repo etiquette (in `roles/COMMON.md`) forbids the
steward from originating cross-repo comment authorization, and the
prior garden's role files referenced here (e.g., `scout`,
`researcher`) are not in this garden's active library. Two ways out:

1. **The maintainer copies the report onto #205** from this journal
   entry. Lowest friction.
2. **Liaison authorizes a one-shot comment** on #205, with the body
   sourced from this entry. The steward forwards the authorization
   into a future dispatch (a monitor subagent can act as the courier
   once explicitly authorized, since "post this exact text on this
   exact issue" is bounded enough to satisfy the dispatch contract).

Either path is the liaison's or maintainer's to choose. The body
above is the deliverable; this entry is the steward's part of the
work on #205.

## Recurrence

The prior steward's brief said this report should run periodically.
Without a watchman-schedule or major-general-style date-keyed
trigger, the steward will not pick this up on its own. A
**Scheduled engagements** bulletin row is the cheapest surface:

- Add a row `2026-05-20 — refresh #205 CI latency report (steward)`
  to `journal/README.md` § Scheduled engagements.

I am adding that row in this cycle. The next cycle on or after
2026-05-20 will pick it up.

## Self-improvement

`gh api '...?per_page=100&page=1'` returns the most recent 100
runs of any state; filtering to `success|failure` after the fetch
gives a clean baseline window. The per-job breakdown the prior
steward's brief mentioned would require an additional API hit per
run (`/actions/runs/<id>/jobs`), pushing the report from one query
to ~50 queries. Worth deferring until the comparison against #121
needs the granularity. Captured for the next CI-latency engagement.

Self-improvement: nothing for the role file.

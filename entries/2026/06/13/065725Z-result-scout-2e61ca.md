---
ts: 2026-06-13T06:57:25Z
kind: result
role: scout
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/13/061900Z-dispatch-scout-b4dfca.md
  - https://github.com/endojs/endo-but-for-bots/issues/205
  - https://github.com/endojs/endo-but-for-bots/issues/205#issuecomment-4697721784
  - https://github.com/endojs/endo-but-for-bots/issues/205#issuecomment-4491834020
  - https://github.com/endojs/endo-but-for-bots/issues/205#issuecomment-4697802743
---

# result: scout, 3-week CI-duration trend check-in on issue #205

Per `garden/skills/ci-runtime-comparison/SKILL.md`. Retry 3 of the dispatch (prior 2 scouts timed out or rate-limited); this run completed.

## Prior check-ins

- **Pre-#121 baseline** (`#issuecomment-4445486163`, 2026-05-13): master, 2026-04-23 to 2026-05-12, n=11. Median 13:20, mean 27:50, min 7:13, max 88:54.
- **Post-#121 first check-in** (`#issuecomment-4491834020`, 2026-05-19): master n=1 (41:36 single point), PR-event supplementary n=132 (median 12:45, mean 17:09, p90 34:03, max 53:10), docs-only n=70 (median 3:47, mean 4:22, max 13:49).

## Window and method

- Window: 2026-05-23T06:51:59Z to 2026-06-13T06:48:08Z (21 days).
- Query: `gh api 'repos/endojs/endo-but-for-bots/actions/runs?per_page=100&page=N'`, paginated through 22 pages until `created_at < 2026-05-23T06:51:59Z`. 2062 unique runs in window.
- Per-run elapsed: `updated_at - run_started_at` (same as baseline).
- Master-branch filter: `?branch=master&per_page=100`, 2 pages, 139 runs total, 42 in 21-day window (7 per workflow x 6 workflows).

## Aggregations

Master CI (push event, n=7) vs pre-#121 baseline (n=11):

| Metric | pre-#121 | current | Delta |
|---|---|---|---|
| Min | 7:13 | 5:47 | -19.9% |
| Median | 13:20 | 7:12 | -46.0% |
| Mean | 27:50 | 11:11 | -59.8% |
| Max | 88:54 | 24:13 | -72.8% |

CI pull_request (n=426) vs prior check-in (n=132):

| Metric | prior | current | Delta |
|---|---|---|---|
| Min | 1:44 | 0:10 | -90.4% |
| Median | 12:45 | 12:55 | +1.3% |
| Mean | 17:09 | 15:23 | -10.3% |
| p90 | 34:03 | 27:25 | -19.5% |
| Max | 53:10 | 66:29 | +25.0% |

CI (docs-only) (n=229) vs prior check-in (n=70):

| Metric | prior | current | Delta |
|---|---|---|---|
| Median | 3:47 | 4:37 | +22.0% |
| Mean | 4:22 | 4:44 | +8.4% |
| Max | 13:49 | 11:41 | -15.4% |

## Anomalies surfaced

1. **PR-event CI max climbed to 66:29 (+25%)**: long-tail run is longer than three weeks ago. Median and p90 both improved, so this reads as a single pathological PR rather than broad regression.
2. **Master CI failure rate 3 of 7 (43%)** in window: runs `26615929293` (2026-05-29), `26659588758` (2026-05-29), `26849769829` (2026-06-02) failed; green stretch from `26857880654` (2026-06-03) onward.
3. **Standing infrastructure failures on master**: Browser Tests 7/7 cancelled, Deploy TypeDoc 7/7 failure, Release 7/7 failure. Surfaced for completeness but these read as long-running standing issues rather than 21-day trend regressions; did not include in the posted comment.

## Sample run IDs

- Master CI (push): `26615929293` (11:13, failure), `26659588758` (17:05, failure), `26849769829` (7:12, failure), `26857880654` (24:13, success), `26921024520` (6:35, success), `27052742748` (6:15, success), `27065459399` (5:47, success).
- Recent PR CI: `27459503460` (in flight), `27458613522` (6:28, failure), `27435000181` (20:24, success), `27420012264` (21:08, success), `27419260085` (14:52, cancelled).

## Posted

- Comment: https://github.com/endojs/endo-but-for-bots/issues/205#issuecomment-4697802743
- At-mentions: `@kriskowal` per dispatch instruction.

Self-improvement: nothing this time. The skill and dispatch instructions covered the task end to end; pagination through 22 pages of `actions/runs` was the only operational detail not stated, and that is inherent to the API rather than a documentation gap.

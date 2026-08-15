The daily progress-summary periodical for 2026-08-14 (Pacific) is written and committed to `journal2`.

## What I did

Re-derived the job from a clean start (prior attempt left no committed periodical: `journal/periodicals/2026/08/14.md` did not exist). Ran the container guard (clean), then:

- **Read the window** `[2026-08-14T07:00:00Z, 2026-08-15T07:00:00Z)`: all in-window entries across `entries/2026/08/14/` and `entries/2026/08/15/` (filtered by `at:`, excluding the three pre-07:00 entries already covered by 13.md), plus every `jobs/tada/` landing in the window from `git log`.
- **Wrote** an abstract-first periodical partitioned by project (endo-but-for-bots, ironhorse, minion.town) plus a garden-meta section, each subdivided by activity kind, sources cited by relative path, house style applied (no em-dashes, no Latin shorthand).
- **Committed and pushed** the single file to `journal2` via a fresh staging clone outside the garden root (never ran git in the deployed root), CAS push succeeded first try.

## What changed

- New file `journal/periodicals/2026/08/14.md`, on `journal2` at commit `6a526505`.

## Coverage highlights captured

endo-but-for-bots merges (#124 slot-machine wire protocol, #976, #986 lal search parity) and its gauntlet juror findings; ironhorse resume-6 launch and the interim full-suite refresh (coverage 9.10% → 45.21%, signalled orchestration-failed mid-flight); minion.town #28/#41/#44; and the overnight fleet degradation (exit-0-unsatisfying / deadline-overrun / wedge escalations) with the self-heal and archive-collision fixes plus the monthly report and scholar ingests it prompted.

No board writes, no upstream actions. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/daily-progress-summary-20260815-070501.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (3 unmetered)
- Input: 34 tokens (1402761 cached reads)
- Output: 19805 tokens
- Cost: $2.1871875 (3 engagement(s) unpriced)
- Wall-clock: 310s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->

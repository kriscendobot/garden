
# Daily midnight Pacific progress summary

A periodical that fires every day at 00:00 America/Los_Angeles (DST-aware),
dispatched into a [journalist](../../roles/journalist/AGENT.md) subagent. The
journalist reads journal entries from the prior 24 hours, summarizes progress
across every project (not just one), and writes the summary as a periodical.

Scope is intentionally everything: dispatches, results, ticks, messages,
worktree-lifecycle entries. The journalist's `daily-progress-summary` purpose
handles partitioning the input by project and by activity kind.

Recurrence anchors to local midnight Pacific: the next fire is always computed
forward from the *intended* schedule, so a late firing does not shift the daily
anchor, even across DST transitions.

---
Translated from v1 `schedule/garden/20260513T070000Z--5a93f9.md`
(recurrence `daily-at-00:00-America/Los_Angeles`, dispatch `journalist` /
`daily-progress-summary`, window "prior 24 hours", scope all projects).
The v1 trigger/short-id/fired machinery is dropped: v2 schedules are recurring
specs keyed by cadence, not pre-computed per-fire event files. The v1 periodicals
output tree is archived under `legacy/v1/periodicals/`. The v1 original is
retained on `journal-v1` and `origin/journal`.

---
claim:
  host: endolinbot2
  gardener: 3
  claimed_at: 2026-07-04T03:05:09Z

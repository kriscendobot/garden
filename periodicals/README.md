---
created: 2026-06-27
updated: 2026-06-27
author: journalist
---

# Periodicals

The garden's scheduled periodical reports. Each periodical is a curated summary of
journal activity over a defined window, written by a role on a scheduled cadence.
In v2 the `garden-scheduler` service fires each schedule under
`../schedules/<name>.md`, posting a job that a gardener claims and runs.

The default periodical is the **daily progress summary**: every day at 00:00
America/Los_Angeles (DST-aware) the scheduler posts a `daily-progress-summary` job
(schedule: [`../schedules/daily-progress-summary.md`](../schedules/daily-progress-summary.md)).
The claiming gardener reads the prior 24 hours of journal entries and board
transitions (every project, every activity kind), summarizes progress, and writes
the result here at `<YYYY>/<MM>/<DD>.md`.

## Layout

```
periodicals/
  README.md                # this index
  <YYYY>/<MM>/<DD>.md       # one daily progress summary per day
```

Each daily file's filename is the **local Pacific date** of the window the summary
covers, not the UTC date of the trigger.

## Kinds

- **Daily progress summary** (`<YYYY>/<MM>/<DD>.md`): author role journalist;
  cadence daily, 00:00 America/Los_Angeles; window the prior 24 hours ending at the
  trigger; source every journal entry and board transition inside the window.

## Notes

- The v1 periodicals output tree is archived under `../legacy/v1/periodicals/`;
  this is the live v2 tree, restarted 2026-06-27 with the first v2 daily summary.

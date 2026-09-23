---
ts: 2026-06-13T06:19:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: scout
dispatch_root: /home/kris/dispatches/scout--b4dfca
refs:
  - https://github.com/endojs/endo-but-for-bots/issues/205
  - https://github.com/endojs/endo-but-for-bots/issues/205#issuecomment-4697721784
---

# dispatch: scout — 3-week CI-duration trend check-in on issue #205

Maintainer at-mention on issue #205 (kriskowal at
2026-06-13T06:18:49Z, issue comment `4697721784`):

> @kriscendobot It's been three weeks. Let's check in again
> on trends in CI duration.

👀 reactji posted on the directive
(`reactions/369547156`).

Issue #205 is the standing CI-duration tracking thread.

## Task

Per `garden/skills/ci-runtime-comparison/SKILL.md` (read it
first).

In your `project/` worktree at endo-but-for-bots master:

1. **Read** `garden/skills/ci-runtime-comparison/SKILL.md` for
   the procedure.
2. **Find the prior check-in** on issue #205: read recent
   issue comments to find the previous report (per the
   maintainer's "again" framing, there have been prior
   check-ins). Note its baseline date + the prior data
   shape so you can match.
3. **Pull CI duration data** for the past 21 days from
   GitHub Actions:
   - `gh run list --workflow ci.yml --created >=2026-05-23
     --limit 200 --json databaseId,createdAt,status,
     conclusion,workflowName --repo endojs/endo-but-for-bots`
   - Per-job durations: for each run, query the jobs
     endpoint.
   - Aggregate by job name + matrix cell (e.g., `test (22.x,
     ubuntu-latest)`); compute median, p90, max over the
     window.
4. **Compare to prior baseline**: per-job delta vs the prior
   check-in's reported numbers. Highlight notable trends
   (growing, shrinking, new flakes appearing).
5. **Compose the check-in comment**:
   - Lead with the headline: which jobs are getting longer,
     which are getting shorter, any flagged anomalies.
   - Per-job table or list with current median + delta
     from prior baseline.
   - Any net total change (full CI wall-clock).
   - Sample run IDs that anchor the data.
6. **Post the comment** on issue #205 at-mentioning
   `@kriskowal`.

## Authorizations (per-action, forwarded by liaison)

- **Read** GitHub Actions API for run + job data.
- **Post a comment** on issue #205 with the trend report.
  Standing `endo-but-for-bots` broad-comment authorization.

## Out of scope

- Do NOT propose actions on the trends (the maintainer asks
  for the data; they make the call).
- Do NOT push code.
- Do NOT touch the source tree.

## Deliverable

A `result` entry under `journal/entries/2026/06/13/` naming:

- The prior check-in reference (date + comment URL or run
  baseline).
- The 21-day window's run count + sample IDs.
- The aggregation methodology + per-job deltas.
- Any anomalies surfaced.
- The posted-comment URL.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.

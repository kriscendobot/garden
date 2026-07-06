Scheduled dispatch context (computed by the scheduler at fire time):

- window_start: 2026-07-05T07:00:00Z (UTC, inclusive)
- window_end: 2026-07-06T07:00:00Z (UTC, exclusive)
- pacific_date: 2026-07-05 (the Pacific day this periodical covers)
- output: journal/periodicals/2026/07/05.md

---


# Daily midnight Pacific progress summary

Act as the [journalist](../../roles/journalist/AGENT.md) with purpose
`daily-progress-summary` (see that role's § Daily progress summaries). Write one
daily progress-summary periodical covering the prior 24 hours across every project,
then commit it to `journal2`.

1. **Window.** If the scheduler prepended a "Scheduled dispatch context" block
   above (it does under the anchored `daily-at-00:00-America/Los_Angeles`
   cadence), use its `window_start`, `window_end`, `pacific_date`, and `output`
   verbatim. Otherwise fall back to the Pacific day that most recently closed:
   window `[<pacific_date> 00:00, next-day 00:00)` in America/Los_Angeles, and
   `output = journal/periodicals/<YYYY>/<MM>/<DD>.md` keyed by that `pacific_date`.
2. **Read.** Every entry under `journal/entries/<YYYY>/<MM>/<DD>/` whose `ts:` is
   in `[window_start, window_end)` (a UTC window can straddle two day-directories;
   scan both and filter by `ts:`), plus the board transitions in the window
   (`jobs/{todo,doin,tada}` moves from `git -C journal log --since=... --until=...`).
   Scope is intentionally everything: dispatches, results, ticks, messages, and
   worktree-lifecycle entries alike.
3. **Write.** One abstract-first periodical at `output`, partitioned by project
   (the `project:` slug; one section per project with any entry, plus a garden-meta
   section for untagged entries) and, within each, by activity kind. Do not skip a
   project for having only a couple of entries. Cite sources by relative path;
   paraphrase, do not copy. House style applies (no em-dashes in prose, no Latin
   shorthand, relative paths). Commit and push the one file with the usual CAS; if
   the file already exists for that Pacific date, overwrite it (the periodical is a
   function of the window, so a re-run is idempotent).

Deliverable: the periodical file committed to `journal2`, or (empty window) a
one-line periodical saying nothing moved. No board writes, no upstream actions.

---
Translated from v1 `schedule/garden/20260513T070000Z--5a93f9.md`
(recurrence `daily-at-00:00-America/Los_Angeles`, dispatch `journalist` /
`daily-progress-summary`, window "prior 24 hours", scope all projects).
The v1 trigger/short-id/fired machinery is dropped: v2 schedules are recurring
specs keyed by cadence, not pre-computed per-fire event files. The v1 periodicals
output tree is archived under `legacy/v1/periodicals/`. The v1 original is
retained on `journal-v1` and `origin/journal`.

The cadence is the anchored, DST-aware `daily-at-00:00-America/Los_Angeles` (which
the scheduler learned on main2 commit 85a1cd8e6): due-ness is decided against the
most recent Pacific-midnight anchor at-or-before now and `last_dispatched` is
stamped to that anchor, so the fire never drifts off local midnight and a 23h/25h
DST day is spanned correctly. It was flipped from the earlier fixed-interval
`daily` (which drifted, firing at each actual dispatch time rather than at local
midnight) once the anchored scheduler landed on the leader host; do not revert it
to `daily` while any leader host still runs a pre-anchor scheduler, or that
scheduler would treat the token as its weekly default.

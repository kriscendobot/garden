---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
token-budget: 500000
---
# Report: per-host job disposition, for maintainer/operator socialization

Produce a report on the garden's job disposition over the recent window,
organized **by host**, so a maintainer or a host's operator can see at a
glance how healthy and productive that host has been. This is a REPORT job:
gather and present data, do not fix anything you find (surface it — a bad
number is a finding, not a task to resolve in this job).

## Why this is being asked for now

Two real host-health incidents this weekend (2026-09-27/28) were each found
by hand-running ad hoc `git log` queries against `journal2` — oros-studio's
stale Claude Code CLI (52 claims / 2 completions / 49 killed in 6h) and
endolin-garden2's expired credentials (178 claims / 65 completions / 109
non-transient failures in 24h). Both would have been visibly abnormal on a
report like this one from the start. Build something a maintainer can
actually reuse, not a one-off.

## What to compute, per host

For each host with any activity in the window (discover them from
`hosts/<host>` files or from claim authorship — don't hardcode a host list),
over the last 24h AND the last 7d (report both; a short window catches a
fresh incident, a longer one shows a trend the short window would miss):

- **Claims**: total jobs claimed, broken down by worker kind (monk/cleric/
  etc. — `claim(<base>) <host>/<kind>-<id>` commits name this).
- **Completions**: `tada(<base>) done <host>/<kind>-<id>` count — "for good."
- **Terminal failures**: `terminal-failure: hint ... by <host>` count — a
  non-transient/deterministic failure, "for ill," usually a content or
  environment defect worth investigating.
- **Transient kills**: `reap-now: hint ... by <host> (transient handler
  kill)` count — external kill/blip, also "for ill" but a different failure
  class (host/environment health, not necessarily job content).
- **Completion rate**: completions / claims, as a percentage — the single
  headline number per host.
- Note any claim whose disposition is still open (claimed, not yet
  completed/failed/doomed) as "in flight," not as a gap in the count.

The exact `git -C journal log --oneline --since=<window> ...` grep patterns
you need (verify these still hold; the commit-message shapes are the source
of truth, don't guess):
- `claim(<base>) <host>/<kind>-<id>` — filter `-F --grep="<host>"` then match
  `^\w+ claim(`.
- `tada(<base>) done <host>/<kind>-<id>` — same shape, `^\w+ tada(`.
- `terminal-failure: hint jobs/doin/<base>.md by <host>`
- `reap-now: hint jobs/doin/<base>.md by <host> (transient handler kill)`

## Presentation

One markdown table per window (24h, 7d), columns: host | claims | completions
| terminal failures | transient kills | in-flight | completion rate. Below
the tables, a short **Notable** section calling out any host whose
completion rate is materially below the fleet average, or whose
terminal/transient split suggests a specific failure mode (mirror how the
oros-studio and garden2 incidents actually looked in the data, as a model for
what "notable" should read like) — but do not diagnose root cause; that's a
separate investigation job if one is warranted, not this report's job.

## Land it

Write the report to `reports/host-disposition-<YYYY-MM-DD>.md` on `journal2`
via the standard producer-clone CAS pattern (`ensure_clone`/`sync_clone`/
`commit_and_push` against `${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}`
— mirror `reports/maintainer-priorities-2026-09-28.md`, landed the same way
yesterday, as your template for the CAS write pattern; do NOT hand-edit the
live `journal/` worktree). This has to be genuinely retrievable afterward —
after landing, fetch `origin/journal2` and confirm
`git -C journal show origin/journal2:reports/host-disposition-<date>.md`
returns your content before completing the job.

## Report (your job completion report)

State the exact landed path and the commit sha that carries it
(`git -C journal log -1 --format=%H -- reports/host-disposition-<date>.md`
after landing) — the liaison needs both to hand the maintainer a fully
qualified `https://github.com/kriscendobot/garden/blob/journal2/<path>` URL.
Also paste the headline numbers (worst and best completion rate, by host)
directly in this report so they're visible without opening the link.

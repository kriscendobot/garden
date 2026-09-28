---
created: 2026-09-28
author: liaison
---

# Skill: host-disposition-report

Produce a per-host job disposition report — claims, completions, terminal
failures, transient kills, and per-claim follow-through, across one or more
recent time windows — so a maintainer or an operator can see at a glance
which hosts in the fleet are healthy and which are quietly failing.

## Why this exists

Two real host-health incidents (2026-09-27/28) were each found only by
hand-running ad hoc `git log --grep` queries against `journal2`:
oros-studio's stale Claude Code CLI (claims winning races, completions
near zero) and endolin-garden2's expired credentials (a monk pool completing
under 40% of what it claimed). Both would have been visibly abnormal on a
report like this from the start, and a maintainer had no single place to
check for that pattern proactively. `scripts/jobs/host-disposition-report.py`
(landed `main2` commit `3771b615390`, 2026-09-28) is the reusable tool; this
skill is the liaison's recipe for using it.

## When to use

- The maintainer asks for a fleet health/performance check, a sitrep that
  should include per-host disposition, or literally asks for this report.
- Before or after a significant fleet-wide change (raising the foreman's
  active-job target, a worker-leveling adjustment, a deploy) — a quick run
  confirms the change didn't quietly starve or overload a host.
- Whenever a host's behavior looks off in ad hoc investigation (the same
  role this tool played in the two incidents above) — reach for the report
  before hand-rolling `git log --grep` queries again.

## Inputs

None required. Optional:
- `--windows <list>` — comma-separated windows, e.g. `6h,24h,7d` (default in
  the tool's own `--help`; check it, it may have changed). Pick windows that
  fit the question: a short window (6h) catches a fresh incident: a longer
  one (24h, 7d) shows whether a fix actually held or a problem is chronic.
- `--repo <dir>` — the journal clone to read. Defaults to the producer clone
  (`${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}`); only pass
  this explicitly when running from somewhere else (a project worktree while
  iterating on the tool itself, for instance).
- `--ref <ref>` — defaults to `origin/journal2`.

## Procedure

This is a **read-only, deterministic, no-LLM** script — run it directly in
the liaison session rather than dispatching a board job for it. Dispatching
a job was the right call the first time (the tool didn't exist yet and
needed building); now that it exists, running it yourself is faster and
cheaper for every subsequent ask.

1. Make sure the journal clone you're pointing at is fresh: `git -C
   <repo-or-default-clone> fetch origin journal2 -q` (or just trust the
   producer clone if something else synced it recently — the report prints
   the commit it read at the top, so staleness is always visible in the
   output, not hidden).
2. Run `scripts/jobs/host-disposition-report.py --windows <your windows>`
   (from the deployed root once the tool has been deployed there; from a
   project worktree with an explicit `--repo` before/without a deploy, as
   this skill's own authoring session had to).
3. Read the output before deciding what to do with it. The per-kind
   follow-through table is more diagnostic than the headline table — a host
   whose overall completion rate looks fine but whose monk pool specifically
   is bad (the garden2 shape) is a real finding the headline table alone can
   hide if other kinds on the same host are healthy.
4. **To share it** (the maintainer socializing it with other operators):
   publish it to `reports/host-disposition-<YYYY-MM-DD>.md` on `journal2`
   via the standard producer-clone CAS pattern (`ensure_clone`/
   `sync_clone`/`commit_and_push`, the same mechanism every other `reports/`
   file in this repo lands through — do not hand-edit the live `journal/`
   worktree). Confirm the landed content reads back
   (`git -C journal show origin/journal2:reports/host-disposition-<date>.md`
   after a fetch) before handing over the URL. Give the maintainer the fully
   qualified GitHub blob URL:
   `https://github.com/kriscendobot/garden/blob/journal2/reports/host-disposition-<date>.md`.
   **To just answer a question in-session**, the terminal output alone is
   often enough — don't publish a report file for every passing check.

## Output shape

Markdown to stdout: a `_Generated <timestamp> from \`origin/journal2\` @
\`<sha>\` by \`scripts/jobs/host-disposition-report.py\`._` provenance line,
then one headline table per requested window (host, claims by kind,
completions, terminal failures, transient kills, in-flight, completion
rate — plus a `fleet` summary row), then one per-kind follow-through table
per window (claims, done, terminal, transient, requeued, other, in-flight,
follow-through — tracing each claim to its actual next disposition for the
same job base, not just a raw event ratio).

## Notes

- The tool discovers hosts from claim/tada authorship and the current
  `jobs/doin/` set — it never hardcodes a host list, so a new or renamed
  host shows up automatically.
- It reads commit *subjects* only (`claim(...)`, `tada(...)`,
  `terminal-failure: hint...`, `reap-now: hint...`) — if those shapes ever
  change, the tool's own regexes need updating; it will silently undercount
  rather than error, so a report that looks suspiciously empty for a host
  you know was active is itself a signal to check the tool against current
  commit-message shapes before trusting the numbers.
- This tool reports; it does not diagnose or fix. A bad number here is the
  start of an investigation (mirror how the oros-studio and garden2
  incidents were actually root-caused — a pinned, host-local diagnostic job
  with direct systemd/journalctl access, not more report-reading), not
  something to resolve from the report alone.

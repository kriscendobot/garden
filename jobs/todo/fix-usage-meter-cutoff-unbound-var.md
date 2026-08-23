---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Small bug found live while posting an ordinary job (`post-job.sh`), 2026-08-23:

```
/home/kris/garden/scripts/jobs/usage-meter.sh: line 302: cutoff: unbound variable
[post] WARN: fleet budget state unreadable; posting '<base>' to todo/ (fail-open)
```

`meter_journal_host_tokens()` in `scripts/jobs/usage-meter.sh` (around line 297)
declares `local dir="$1" host="$2" cutoff files` — `cutoff` is declared but never
assigned, even though both call sites pass a third positional argument for it:

- `scripts/jobs/budget-level.sh:63` — `meter_journal_host_tokens "$DIR" "$host" "$cutoff"`
- `scripts/jobs/usage-meter.sh:435` — `meter_journal_host_tokens "$dir" "$account" "$cutoff"`

The function then references `"$cutoff"` in its `jq --argjson cutoff "$cutoff"`
call, which throws under `set -u`/nounset. This is presumably a `="$3"` that got
dropped.

## Fix

Change the local declaration to `local dir="$1" host="$2" cutoff="$3" files` (or
equivalent). Confirm there isn't a second, similarly-shaped miss elsewhere in
the file (grep other `local ... <name> ...` declarations against their call
sites for the same drop pattern).

## Impact while unfixed

The failure is caught and fails OPEN (`post-job.sh` still posts the job, just
with fleet budget state read as "unreadable" instead of a real number) — so
this is not blocking work, but it means remote-account budget-gating via the
journal fallback path (`meter_journal_host_tokens`, used when "a leader cannot
read another host's ~/.claude") has been silently non-functional since
whenever this landed. Worth a regression test asserting this function returns
a real number given a live `cutoff`, not just checking it exits without error.

## Out of scope

No other usage-meter/budget-level behavior changes.

<!-- garden-reaped: 0 -->

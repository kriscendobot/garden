once: 2026-09-19T08:33:19Z
job_basename_prefix: restore-cleric
---
---
role: gardener
---
# Restore cleric (codex) worker counts after the 2026-09-17 quota throttle

The maintainer (kriskowal, 2026-09-17T20:33Z) directed a fleet-wide cleric
throttle to 0 for 1 day 12 hours, having spent the shared OpenAI/codex
quota (`journal/budget/manual-checkpoints/openai-codex-shared.jsonl` last
read 52% used with a 2d9h-out reset, at the time the throttle was set).

Restore cleric counts to their pre-throttle baseline:

```sh
scripts/jobs/set-workers.sh cleric 1   # if this job is claimed on the leader (endolin-garden-ece02cb4)
scripts/jobs/send-host-op.sh endolin-garden-ece02cb4 op=set-workers kind=cleric count=1
scripts/jobs/send-host-op.sh endolin-garden2-5bcdff64 op=set-workers kind=cleric count=1
```

Use `send-host-op.sh` for BOTH hosts regardless of which host claims this
job (it works cross-host over the sysop bus; don't rely on `set-workers.sh`
alone, which only writes the CALLING host's own count). oros-studio had no
cleric declared before the throttle and should stay that way — do not add
one.

Before restoring, do a quick sanity check: read the current
`journal/budget/manual-checkpoints/openai-codex-shared.jsonl` tail — if the
shared codex quota looks like it's still critically depleted (no reset
appears to have occurred since the throttle was set), restore anyway per
the maintainer's explicit 1d12h duration, but flag the discrepancy in your
completion report and message the maintainer rather than silently
extending the throttle on your own judgment.

Report the before/after cleric counts on both hosts.

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/foreman.sh:298 crashes the foreman tick with rc=1 and zero diagnostic output whenever `jobs/plan/` has 2+ deferred plan jobs.

Failure signature: self-heal capture blob dbcf68b220fa6c9e661314b8dc0469d423846e1f is just `cut: write error: Broken pipe` (30 bytes) — the entire captured output, meaning the tick died on this line before any later log() ran.

Root cause: `top_deferred="$(plan_deferred_ranked "$DIR" | head -1)"` runs under `set -euo pipefail`. `plan_deferred_ranked` (scripts/jobs/common.sh:7795-7805) internally ends with `| cut -f3`. When it emits more than one line, `head -1` reads the first line and closes the pipe early; `cut`'s next write gets EPIPE, it prints the broken-pipe message and exits 1, `pipefail` makes the whole substitution's status nonzero, and `set -e` aborts the script — even though `head -1` already captured the value we wanted.

Fix: make the truncated read tolerant of the writer-side SIGPIPE, e.g.
```
top_deferred="$(plan_deferred_ranked "$DIR" | head -1)" || true
```
(or redirect `cut`'s stderr / restructure `plan_deferred_ranked` to not fail the pipeline on a closed reader). Add a regression test mirroring the existing foreman stub tests: seed 2+ deferred plan jobs in `jobs/plan/` and assert the tick completes (promotes one, doesn't exit nonzero) instead of crashing.

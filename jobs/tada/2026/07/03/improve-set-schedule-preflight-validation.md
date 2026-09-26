Pushed cleanly to main2.

## Completion report

**Job:** Add preflight existence validation to `scripts/jobs/set-schedule.sh`.

**What I did:**
- Inspected how `scheduler.sh` resolves the preflight path (line ~158): `pf="$preflight"; case "$pf" in /*) :;; *) pf="$HERE/$pf";; esac` then checks `[ -x "$pf" ]`. Confirmed the fail-open behavior at line ~165 (`WARN … not found/executable … treating as work-present`).
- Added a preflight validation block to `set-schedule.sh`, placed after body assembly and before the CAS loop. When `GARDEN_SCHEDULE_PREFLIGHT` is set, it resolves the path identically to `scheduler.sh` (relative to `$HERE` / script dir unless absolute) and `die`s with a clear message (non-zero exit) if the resolved path is not found/executable.

**What changed:**
- `scripts/jobs/set-schedule.sh` — new env-gated preflight `-x` check with an explanatory comment. Committed as `48053a960`, pushed to `main2`.

**Verification:**
- `bash -n` passes.
- Confirmed `die()` in `common.sh` exits non-zero.
- Tested the resolution logic against the real tree: relative gate `gardening/xs2rust-endor-press-preflight.sh` and `common.sh` resolve and pass; absolute `/bin/sh` passes; nonexistent `/nope` is rejected.

**Scope notes / no regressions:**
- The check fires **only** when the gate is supplied via the env var (a fresh registration/change). The preserve-existing-preflight path (line ~48, reusing an already-validated `preflight:` line when the env var is unset) is left fully intact, so already-registered schedules are unaffected.
- `-x` on a nonexistent path is false, so a single check covers both the not-found and not-executable cases, matching `scheduler.sh`.

**Follow-ups:** None.

Done. Completion report:

---

## Completion report: `foreman-token-quota-backoff`

**Done:** the foreman now deterministically checks the garden's weekly token usage and backs off before its autonomous pump. Built in an isolated worktree off `origin/main2`, committed with explicit pathspecs, rebased, and pushed (`8562eb991` on `origin/main2`). Worktree torn down.

**What changed**
- **`scripts/jobs/usage-meter.sh` (new, sourced by `common.sh`)** — a host-local rolling token meter. Helpers: `meter_record`, `meter_window_total`, `meter_quota_status` (`off`/`ok`/`backoff`/`unknown`), and `meter_claude` (a drop-in for `claude -p` that records the call's billable tokens, then prints the result text).
- **`scripts/jobs/foreman.sh`** — after the sustained-idle gate and **before both pump paths** (deferred-plan promote *and* `claude -p` step generation), it consults `meter_quota_status`: `backoff` → pump nothing this tick + one throttled (`note_once`) maintainer note; `off`/`ok` → pump as normal; `unknown` → fail open with a logged warning. New `GARDEN_TOKEN_*` knobs documented alongside the other `GARDEN_FOREMAN_*` defaults.
- **`scripts/jobs/handlers/foreman-claude.sh`** — reference adopter; runs its model call through `meter_claude`.
- **`scripts/jobs/test/run-test.sh`** — added SUBTEST 14b covering all four required behaviors.

**Decisions (as the job asked me to pick & justify)**
- **Usage source:** the `usage` block from `claude --output-format json`, recorded at the point of spend. No dependency on external dashboards or `~/.claude` internals. Billable tokens = input + output + cache_creation (cache_read excluded so cheap cache reads don't trip back-off early).
- **Missing/unreadable meter:** **fail-open with a logged warning** (per the job's lean) — a meter bug can't freeze the fleet. Quota-unset is a distinct `off` state (gating intentionally disabled, no warning spam).
- **Week boundary:** trailing 7-day rolling window — it can only over-count vs a fixed reset, so it errs toward backing off slightly early, never late.

**Verification:** SUBTEST 14b's four cases all pass against the real `foreman.sh` (validated via standalone harness): under-quota pumps (calls=1, todo=1); at/over-quota promotes nothing & runs no handler & sends one note (calls=0, todo=0, maint=1); the note is throttled across ticks (M2==M1); a broken meter fails open (calls=1, todo=1). Meter helpers unit-tested directly. All five modified scripts pass `bash -n`. The full suite aborts early at SUBTEST 5 in this sandbox (the concurrency/claim git ops can't run here — `claims=0`); I confirmed the **unmodified baseline aborts at the identical point**, so it's pre-existing/environmental, not from this change.

**Open question surfaced (for the maintainer):** the garden's *actual* quota-reset cadence is unknown — I defaulted to a rolling 7-day window. If the real quota resets on a fixed calendar boundary, set `GARDEN_TOKEN_WINDOW_SECS` and/or teach `meter_window_total` a calendar cutoff. Also, `GARDEN_TOKEN_WEEKLY_QUOTA` ships **unset (meter OFF)** — the gate does nothing until the maintainer sets the real ceiling.

**Follow-ups**
- Fleet-wide meter adoption: only `foreman-claude.sh` records spend today, so the ledger currently reflects the foreman's own generation calls, not the chains they ignite. For the gate to reflect *total* garden spend, the other `claude -p` callers (gardener, panel, triager, watchman, proxy, bulletin, mentor, follow-up, comment/mention handlers) should switch their model calls to `meter_claude`. Worth posting as a separate job.
- Maintainer to set `GARDEN_TOKEN_WEEKLY_QUOTA` (and confirm the reset cadence) to actually arm the back-off.

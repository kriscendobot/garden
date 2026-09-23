The commit is landed on `origin/main2`. Work is complete.

## Completion report

**Job:** `improve-ci-watcher-backoff-on-rate-limit-cascade` — harden `scripts/jobs/ci-watcher.sh` against the secondary-rate-limit cascade that blinded the 03:21–03:22 sweep (~150 bot PRs all returning rc=1).

**What I did** — two changes to the per-tick PR loop, landed as commit `895dfc7b1` on `main2`:

- **(a) Cascade circuit-breaker.** Added `GARDEN_CI_UNREADABLE_ABORT_THRESHOLD` (default 3). The loop now tracks a `reads_ok` counter (any readable rollup: rc 0/10/11/12) and, in the `*)` unreadable fallthrough, counts consecutive unreadable reads. When the threshold is crossed with **not one** successful read yet this tick, it aborts the remaining sweep with one loud WARN — `"N consecutive rollup reads unreadable — aborting tick, likely GitHub rate limit"` — and `exit 0`, instead of firing more `gh pr view` GraphQL at an already-throttled API. An early success disarms the breaker (the "zero successful reads so far this tick" clause), so a lone mid-tick glitch never aborts.
- **(b) Steady-state pressure relief.** Added `GARDEN_CI_ACTIVITY_WINDOW` (default `3 days`). The loop now reads the source's 4th column (`updated_at`) — previously discarded into `_` — and skips any bot PR untouched beyond the window **before** its GraphQL-heavy rollup read, so a tick reads a handful of recently-active PRs rather than every open bot PR. Empty window disables the bound (pre-hardening behaviour).
- Updated the tick summary line (adds `stale-skipped`) and re-scoped the existing systemic-outage WARN to the PRs actually **read** (`ours − stale`), distinct from the front-clustered abort.
- Added tests I/J/K to `ci-watcher-test.sh` (activity-window skip, cascade abort of the tail red PR, and the disarm-after-success case). Full suite: **19 passed, 0 failed**. Manually confirmed the abort emits exactly one WARN and stops before the tail PRs.

**Reconciliation:** a peer commit (`0a9123fbd`, surface rollup handler stderr in the unreadable WARN) landed on `main2` mid-flight and touched the same case block. I rebased and merged both cleanly — the WARN now carries the handler's stderr **and** the circuit-breaker fires off the same arm. Re-ran the suite green after the merge.

**Follow-ups:** none required. Both knobs default to safe values and are overridable per-host. Pre-existing shellcheck notes (SC2034 on `GARDEN_TAG`, SC2015) are unchanged and not introduced by this work.

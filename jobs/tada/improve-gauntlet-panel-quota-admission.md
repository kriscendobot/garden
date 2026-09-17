Inbox is empty. Work complete.

## Completion report

**Job:** Make `scripts/jobs/gauntlet.sh` deterministically check the panel-provider quota/admission state before posting a panel stage, and defer the stage until quota is usable — rather than spending a panel attempt that aborts at a seat on weekly-quota exhaustion with no verdict.

**What I did**
- Established that the gauntlet panel stage is **Anthropic-only**: `panel.sh` shells `claude -p` once per juror seat (seat-model-tiers.tsv is Anthropic tiers), so an exhausted Anthropic weekly quota makes a posted panel round abort mid-fan-out.
- Added a deterministic, fail-open pre-gate to `gauntlet.sh`:
  - New helper `panel_provider_admits` reuses the fleet's existing `meter_quota_status` / `budget_pool_file` (the *same* number the foreman gate and per-claim admission reason over), returning "defer" only when **every** configured budget pool for the panel provider is confirmed at weekly-quota `backoff`. Absent/unreadable config, no configured pool, or a blind sensor all **admit** (never wedges a gauntlet). A `refuse` (unmetered/uncalibrated pool) is a config fault the claim gate surfaces, not a transient quota state, so it does not defer.
  - New knob `GARDEN_GAUNTLET_PANEL_PROVIDER` (default `anthropic`).
  - Applied the gate at **every** panel-posting path — `advance_stage` (clean=done / fix=done → panel), the panel-error / doomed-transient retry (`retry_failed_stage`, without burning a stage-retry), and a manual `--resume-from-stage` onto panel (`restart_requested_stage`). Deferring leaves the record untouched at its current stage, so the completed predecessor re-drives the transition each tick and the panel posts automatically once quota recovers (unbounded wait, mirroring a producer's budget-hold). The gate is panel-only; viability/clean/fix/undraft are unaffected.
  - A coalesced INFO reaches the maintainer inbox naming the stall and the next reset time (`inbox-send.sh` throttles the amend to ~hourly, so no per-tick journal churn).

**What changed**
- `scripts/jobs/gauntlet.sh` (+80 lines): config knob, `panel_provider_admits`, `notify_panel_deferred`, and three guard blocks.
- `scripts/jobs/test/gauntlet-panel-quota-test.sh` (new, hermetic): seeds `config/budget-pools` + fake Claude session logs to drive meter spend; asserts defer-under-backoff, idempotent re-defer, automatic recovery, panel-only gating, and the maintainer notice. **7/7 pass.**
- Committed and pushed to `main2` (`6499cdeaa2`).

**Verification:** `bash -n` clean; `shellcheck -x` clean (only the expected SC1091 for the sourced `common.sh`); the new test passes 7/7.

**Follow-up (pre-existing, unrelated to this change):** `scripts/jobs/test/gauntlet-test.sh` is **stale** — it still expects `clean` at the first tick, but the viability gate (landed earlier in `c32821fa15`, before that test's last update) posts `viability` first, so subtest 1 fails on current `main2` independent of my change. I kept my coverage in a separate focused file rather than expand scope into repairing that suite; it likely warrants its own fix job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-panel-quota-admission.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (5065015 cached reads)
- Output: 46137 tokens
- Cost: $5.448370499999999
- Wall-clock: 643s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->

Empty inbox. Work is complete and pushed.

## Completion report

**Job:** `improve-gardener-deterministic-overrun-alert` — surface an early, actionable maintainer alert when a job deterministically overruns the *default* handler budget.

**What changed:**

1. **`scripts/jobs/gardener.sh`** — In the `deadline_overrun=1` branch (handler killed by its OWN wall-clock bound, rc=124 at the wall), added a best-effort, subshell-isolated `alert_maintainer` call using the dedup key `handler-budget-overrun-$base` — the *same key* the clamped-declared-overrun path (line ~358) uses, so both surfaces of the one root cause collapse onto a single throttled alert. The message gives the actionable diagnosis the reaper's eventual generic poison report omits: the job deterministically overran its handler budget (`elapsed=…s ≈ handler-budget=…s`), does not fit in a single claim-scoped handler, will be poisoned after `GARDEN_REAP_OVERRUN_THRESHOLD` cycles, and the remedy is to **split** into claim-sized stages or run **detached** — matching the guidance the declared-over-budget clamp path already gives. Wrapped `( … ) || true` so it can never fail the gardener.

2. **`scripts/jobs/test/handler-budget-test.sh`** — Added **SUBTEST 4**: drives a default-budget (no `handler-timeout:` header) job that sleeps past its 1s budget → SIGTERM-killed at the wall (rc=124) → deterministic overrun. Asserts the deadline-overrun classification, that the alert fires **exactly once** under the shared key with the split/detached guidance, then requeues the same base for a **second** overrun cycle against the same `GARDEN_STATE` and asserts the alert stays **deduped at one entry** — confirming the throttle key collapses the two pre-poison overrun cycles.

**Throttle dedup confirmed:** the two overrun cycles before poison (`GARDEN_REAP_OVERRUN_THRESHOLD=2`) are ~one handler-budget + requeue latency apart (≈2400–3000s), under the 3600s default `GARDEN_ALERT_THROTTLE_SECS`, so the shared key dedups them to one alert. SUBTEST 4 verifies this directly offline.

**Verification:** `handler-budget-test.sh` passes 12/12 (all 3 prior subtests plus the 5 new assertions); `bash -n` clean on both files.

**Pushed:** `ccf9f6f65..4740a85e4 → main2`. No follow-ups.

Pushed cleanly to `main2`. Final report:

---

## Completion report

**Investigated and fixed** the ~14-min fleet restart in `deploy-garden.sh`.

### Root cause
The deploy spent ~14 min entirely inside `restart_long_running_fleet` (restarted=77, ~11s/unit) because it restarted gardener units **serially**. The per-unit slowness is a chain:
- A `systemctl restart` client blocks until the unit's stop+start job completes.
- An *idle* gardener is parked in `gardener.sh`'s `idle_backoff` `sleep` (up to `GARDEN_IDLE_SLEEP_CAP`, default 30s).
- Under the unit's `KillMode=mixed`, the stop SIGTERMs only the main process (`self-heal-run.sh`), which correctly forwards the signal to `gardener.sh` — but **bash defers a trapped signal until the foreground `sleep` returns**, and the `sleep` itself is never signaled. So each stop waits out the remainder of its idle sleep before the worker hits its between-claims exit point.

77 of those in series ≈ 14 min — which at the ~15-min `main2` cadence kept the leader in near-continuous drain/restart. (Hypothesis 1 was on the right track but `self-heal-run.sh` forwards fine; the deferral is in the worker's idle sleep. Hypothesis 3 — serial restart — is the in-scope lever.)

### Fix (`scripts/jobs/deploy-restart.sh`)
Collect every unit to re-exec (gardeners after the busy-gate, plus the bulletin singleton and watcher pool) and issue all restarts **concurrently**, then `wait`. The per-unit stop windows now overlap instead of summing, so a full-fleet restart costs ~one idle-poll window (≤30s) plus start overhead instead of N×. Each unit keeps its own `unit_ctl restart` invocation, so per-unit accounting and failure isolation are preserved (a single failing unit no longer aborts the wave).

### Verification
- `deploy-garden-test.sh`: 47/47 pass, including two new cases — concurrent full-fleet restart (all 5 gardeners restart, none skipped) and failure isolation (one failing unit counted `failed=1`, siblings still restart, deploy still succeeds). Added opt-in `GARDEN_MOCK_FAIL_UNIT` to `mock-systemctl.sh`.
- Sibling suites using the mock (`enable-services-test`, `main-host-test`) still green (24/24, 38/38).
- Empirical benchmark: 8 units × 1s simulated stop = **~1s wall concurrent** vs ~8s serial — confirming the collapse from sum-of-stops to max-of-stops.

### Landed
`4a564169d` on `origin/main2`.

### Follow-ups (out of this job's file scope)
- **True near-instant per-unit stop** would require making the idle `sleep` interruptible in `gardener.sh`/`common.sh` (e.g. `sleep & wait $!` so a trapped SIGTERM breaks the wait). With the concurrent restart that's no longer urgent (fleet restart is already ~one sleep-window), but it would cut the residual ≤30s tail.
- **Lift-before-restart window (hypothesis 2)**: `deploy-garden.sh` lifts the drain before restarting, so a gardener can claim a job and go busy in the small window; its `KillMode=mixed` stop would then legitimately wait for the handler (bounded by `TimeoutStopSec`). Pre-existing and rare; a redesign (stop-while-drained → lift → start) would close it but carries job-abandonment risk if mis-ordered, so I left it as a deliberate, separately-tested change.

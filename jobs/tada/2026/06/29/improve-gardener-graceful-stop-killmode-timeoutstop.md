No tests cover the stop path, and the deploy design's busy-marker references describe the deploy-drain contract (unchanged — my change makes it authoritative, not different). Work is complete and pushed.

---

## Completion report

**Job:** `improve-gardener-graceful-stop-killmode-timeoutstop`

**Problem:** The gardener systemd unit lacked `KillMode`/`TimeoutStopSec`, so any `systemctl stop/restart` used the default `KillMode=control-group` — SIGTERMing the whole cgroup, including the in-flight handler subtree. The handler died rc=143 mid-job → requeue + a burned poison cycle + thrown-away work. This was the signature in the four new journal entries.

**What I changed** (2 files, +40 lines, committed and pushed to `main2` on the first CAS attempt):

1. **`scripts/systemd/garden-gardener@.service`** — added `KillMode=mixed` so the initial SIGTERM goes only to the main worker process (`self-heal-run.sh`), leaving the handler subtree running; and `TimeoutStopSec=2700` (≥ `GARDEN_HANDLER_TIMEOUT` 2400 + `GARDEN_HANDLER_KILL_AFTER` 60 + slack) so systemd waits for the running job to finish before its cgroup-wide SIGKILL backstop. Documented the lock-step relationship to the handler-timeout knobs.

2. **`scripts/jobs/gardener.sh`** — added a `stop_requested` flag and a `trap … TERM` that sets it instead of dying, honored at a new check at the top-of-loop between-claims point (mirroring the existing `fleet_draining` check). Because bash defers a trapped signal until the running foreground command (the `timeout … "$GARDEN_JOB_HANDLER"` call, or an idle sleep) returns, the current job finishes uninterrupted, then the loop exits cleanly — never mid-handler.

**Why the relay works under `mixed`:** `self-heal-run.sh` (the unit's main process) already has a `forward()` trap that relays SIGTERM to its `gardener.sh` child via a single-process `kill` (not a process-group kill), so the trap fires in `gardener.sh` and the handler subtree is never directly signalled. The top-of-loop check is sufficient to guarantee no new handler starts after a stop, since starting the next handler always passes through that point.

**Verification:** `bash -n` clean; shellcheck shows only the pre-existing `GARDEN_TAG` SC2034 false positive (consumed by `common.sh`'s `log`). No tests or designs reference these stop-path knobs, so nothing else needed updating.

**Follow-ups:** None required. Note for operators: if `GARDEN_HANDLER_TIMEOUT`/`GARDEN_HANDLER_KILL_AFTER` are ever raised, `TimeoutStopSec` in the unit must be raised in lock-step (called out in both comment blocks). Takes effect on the next `install-units.sh install` + `daemon-reload` of the deployed fleet.

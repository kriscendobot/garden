Empty inbox. Work is complete.

## Completion report

**Job:** Harden `garden-gardener-scaler` scale path so no single hung `systemctl` call can stall the whole reconcile past `garden-gardener-scaler.service`'s `TimeoutStartSec=900` (the 3× SIGKILL on 2026-07-02 left the pool unreconciled).

**What I did:**
- **`scripts/jobs/common.sh`** — Added `unit_ctl_bounded`: runs the same command `unit_ctl` would (the `GARDEN_UNIT_CTL` mock or `systemctl --user`) but under `timeout -k 2 <secs>` (default 5s, `GARDEN_UNIT_CTL_TIMEOUT` overrides). A per-unit deadline yields rc 124/137, and `-k` escalates to SIGKILL for a call that ignores SIGTERM. Also bounded the `show` inside `gardener_instance_garden` so a hung identity read on one unit can't stall the reconcile (empty pid → treated as not-drifted, skipped).
- **`scripts/jobs/install-units.sh`** — `scale()` now routes every `enable --now` / `disable --now` through `unit_ctl_bounded`; on a timeout or failure it logs *which* unit was skipped (a shared `scale_skip_note` distinguishes a bounded-timeout kill from a genuine rc) and **continues to the next unit**, so the pass always completes and a later tick retries the skipped one. Same treatment for `reconcile_identity()`'s per-unit `restart` and for the `list-units` driver of both loops.
- **Tests** — Added a `GARDEN_MOCK_HANG_UNIT` hang-injection to `mock-systemctl.sh` and a `SCALE-TIMEOUT` regression subtest in `enable-services-test.sh` proving a hung per-unit disable is bounded, killed, logged as skipped, the loop continues to drain the rest (@3 disabled after the hung @2), the pass completes, and the hung unit is left armed for a later tick.

**Verification:** `enable-services-test.sh` 29/29 pass (5 new), `gardener-identity-test.sh` 9/9, `identity-drift-guard-test.sh` 10/10; all four files pass `bash -n`.

**Changed & pushed:** committed to `main2` (`526c1da3c`), pushed clean on first attempt.

**Follow-ups (out of scope, worth noting):** The per-unit bound fixes the reported failure (one or a handful of hung calls). A *total* dbus/user-manager wedge would still exceed 900s even bounded (~100 units × a few seconds each across reconcile + scale) — but in that state no scaling is possible anyway. If that ever becomes a concern, an overall wall-clock budget in the loops (stop iterating and defer the remainder once a budget is spent) would be the next step. `prune_retired` also loops per-unit `disable --now`, but it runs only on `install`/`enable-services`, not on the scaler's per-tick path, so it was left as-is.

Empty inbox. Work is complete and landed on main2.

## Completion report

**Job:** Make the gardener-scaler restart gardener instances whose in-process `GARDEN` host identity has drifted from the host's authoritative identity.

**What I did**

Added an identity-reconciliation step to the scaler tick, gated on the same busy-marker deferral the scale path already uses. Changes (committed as `6761370ff`, pushed to `main2`):

- **`scripts/jobs/common.sh`** — new `gardener_instance_garden <unit>` helper: reads a running instance's live `GARDEN` from `/proc/<MainPID>/environ` (MainPID via `unit_ctl show`), returning empty when the identity can't be read (not running, or no `GARDEN` in environ → it resolved the kernel-fixed `hostname -s` default, which cannot drift, so it's left alone). Added a `GARDEN_PROC` override so the path is testable without a real `/proc`.
- **`scripts/jobs/install-units.sh`** — new `reconcile_identity` function + `reconcile-identity` subcommand: iterates active `garden-gardener@N.service` instances, compares each worker's live `GARDEN` to this host's authoritative `$GARDEN`, and `systemctl --user restart`s any drifted one. A **mid-job** worker (busy marker present) is **deferred** to a later tick, so it restarts between claims, never mid-`claude -p` (avoids the rc=143 transient-handler outage).
- **`scripts/jobs/gardener-scaler.sh`** — calls `install-units.sh reconcile-identity` every tick, **independent of** the desired-count early-exit, so a drifted worker is corrected even when the size signal (`hosts/<host>`) is structurally missing.
- **`scripts/jobs/test/mock-systemctl.sh`** — emulated `show -p MainPID --value` (via `GARDEN_MOCK_PIDS`) and no-op'd `restart/start/stop`.
- **`scripts/jobs/test/run-test.sh`** — extended SUBTEST 4 with 4 assertions: a drifted idle worker is restarted; a matching worker is left alone (no spurious restart); a drifted **busy** worker is deferred; the deferral is logged.

**Verification** — full `run-test.sh` suite passes (exit 0), including the new SUBTEST 4 assertions and the pre-existing scaler/scale-defer checks; `enable-services-test.sh` passes 24/24; all five modified scripts pass `bash -n`.

**Deterministic authoritative value:** I used the scaler's own resolved `$GARDEN` (the single canonical per-host identity knob, which equals the kernel-fixed `hostname -s` in the stock container). This is strictly safer than re-reading `hostname -s` raw: it honors a deliberate whole-host override consistently and the timer-fresh scaler process already carries the corrected value — matching how every other keying decision in the codebase is made.

**Follow-ups**
- This is a deployed-root change; it corrects the live drifted workers on the next deploy of `main2` + a scaler tick. Until this host is deployed, a one-time manual `systemctl --user restart garden-gardener@*` remains the immediate remedy for the current `endolinbot2` drift.
- The job noted a sibling job may add a startup-written identity marker; my implementation deliberately depends only on `/proc/<MainPID>/environ` so it works today. Preferring that marker when present (more robust than reading `/proc`) is a clean future enhancement, not required.

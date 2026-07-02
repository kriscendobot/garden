`garden-gardener-scaler.service` (Type=oneshot, `TimeoutStartSec=900`) timed out and was killed 3× on 2026-07-02 (14:43/14:58/15:13), leaving the local gardener pool unreconciled. The scaler (`scripts/jobs/gardener-scaler.sh`) delegates the actual enable/disable to `install-units.sh scale`, which iterates ~100 `garden-gardener@N` units doing `systemctl … disable --now` gated on a busy marker — any single hung/slow `systemctl` call blocks the whole reconcile past the 900s window, so systemd SIGKILLs it and nothing scales. Harden the scale path so no single unit operation can stall the whole run: wrap each per-unit `unit_ctl`/`systemctl` call in a bounded `timeout` (e.g. a few seconds), and on a per-unit timeout log which unit was skipped and continue to the next rather than blocking — so the reconcile always completes within the window and a later tick retries the skipped units. Verify against `scripts/systemd/garden-gardener-scaler.service:17` (`TimeoutStartSec=900`) and the `install-units.sh scale` loop.

---
claim:
  host: endolinbot2
  gardener: 2
  claimed_at: 2026-07-02T19:14:58Z

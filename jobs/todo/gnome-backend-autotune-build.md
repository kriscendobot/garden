---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-28T12:25:06Z -->

role: builder
# Build: implement backend-verified provisioning + auth auto-tune (per the design)

Implement per `designs/gnome-backend-verified-autotune.md` (produced by the
predecessor design job). Garden repo, main2, DIRECT push, NO PR (per CLAUDE.md):
- Wire the per-backend auth+software probe (reuse existing probes) into the scaler
  (`scripts/jobs/gardener-scaler.sh`) so each kind's EFFECTIVE count auto-tunes to 0
  when its backend probe fails and ramps to the declared target when it passes, with
  the design's hysteresis (no journal thrash).
- Add the provisioning gate (fresh gnome only enables a verified kind) to the
  bring-up path (`context/operations/starting.md` + a `set-workers` preflight as the
  design directs).
- Tests under `scripts/jobs/test/` for the probe + effective-count logic.
- Run CI-equivalent checks locally before pushing (a lint/test discrepancy is a
  parity defect to close); push to origin/main2.
Report the files changed and how a Claude-only gnome (ps23) vs an all-backend gnome
(garden/garden2) now behaves. This change reaches running hosts only via a later deploy.

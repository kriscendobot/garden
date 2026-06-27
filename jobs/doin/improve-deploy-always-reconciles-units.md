`restart_long_running_fleet` in `scripts/jobs/deploy-restart.sh` (lines 68–74) only runs `install-units.sh install` — the step that disables retired units — when the deploy diff touched `scripts/systemd/` (`units_changed=1`). A host that deploys past a retirement under any edge (e.g. its prior deploy predated the retire entry, or the `install` step hit the WARN/continue path) never re-reconciles its unit set, which is the gap that left `garden-deploy-sync.service` enabled and crash-looping until a self-heal job ran. Make the deliberate deploy run the unit-reconcile/prune step unconditionally once per deploy (cheap: a `daemon-reload` + disable of absent units), independent of whether a `scripts/systemd/` file changed, so the deploy itself is the authority that no retired unit survives — eliminating the need for the reactive `*-deploy-reconcile-retired-units` self-heal job.

---
claim:
  host: endolinbot
  gardener: 29
  claimed_at: 2026-06-27T20:52:16Z

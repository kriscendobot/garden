---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Containment drift check for kriscendobot/minion.town: verify the two de-registered gateway records from the `minion-town-containment-gateway-endo-sock` containment are still absent, and that the systemd drop-in that disarms the weblet powers plane is still in place. A CD gateway redeploy leaves the drop-in intact but can restore the two records; if they have reappeared, re-run the de-registration exactly as recorded in that job's report and note the recurrence. Report no-change quietly; report any reappearance to the maintainer inbox.

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: hermit
  tier: 
  provider: local
  model: 
  claimed_at: 2026-08-19T23:53:12Z

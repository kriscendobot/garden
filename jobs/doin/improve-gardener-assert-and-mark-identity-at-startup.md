`scripts/jobs/gardener.sh` never surfaces or validates its resolved `GARDEN` at boot, so an inherited-env drift (like the endolinbot2 case) stays invisible until it has already corrupted per-host journal/index state. At the top of `gardener.sh`, after sourcing `common.sh`: (1) log the resolved `GARDEN` once at startup; (2) compare it against `hostname -s` and emit ONE `WARN` when they differ without a recorded deliberate override (the design permits `GARDEN=<unique>` parallel pools, so warn — don't refuse — but make the divergence loud and greppable); (3) write a cheap per-instance identity marker (e.g. `$GARDEN_STATE/gardeners/<instance>.garden` holding the resolved name) that the scaler's drift check (sibling job) can read without walking `/proc`. This turns a silent, self-perpetuating identity leak into a detectable, machine-checkable condition at the point of spawn.

---
claim:
  host: endolinbot2
  gardener: 87
  claimed_at: 2026-07-02T02:53:07Z

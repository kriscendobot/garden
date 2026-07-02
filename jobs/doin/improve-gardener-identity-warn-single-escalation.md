The unrecorded-GARDEN-divergence WARN in `scripts/jobs/gardener.sh` (~line 118) fires from every one of the ~100 gardeners on every spawn, producing ~100 identical `GARDEN=endolinbot2 diverges from hostname -s=endolinbot with NO recorded deliberate override` lines per wake that dominate `journalctl -p warning` and bury unrelated warnings. This is precisely the drift case the scaler's `reconcile_identity` (scripts/jobs/install-units.sh, run every tick from gardener-scaler.sh) cannot auto-correct, because the scaler inherits the same drifted env, so the spam never resolves. Move the escalation off the per-spawn path: keep a single low-volume `identity:` info line per gardener, but promote the "NO recorded override" detection into the once-per-tick `reconcile_identity` path so it emits one WARN and posts one `kind:error` maintainer-inbox report per host per divergence (deduped by a `$GARDEN_STATE` marker so it isn't re-posted every tick), turning 100×/tick noise into a single actionable escalation of a genuine config leak.

---
claim:
  host: endolinbot2
  gardener: 49
  claimed_at: 2026-07-02T10:25:12Z

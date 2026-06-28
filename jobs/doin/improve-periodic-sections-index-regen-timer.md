Move the sections-index regeneration off the agent and onto a deterministic cadence so it self-heals even when no scholar cycle runs step 9. Today the index is only rebuilt by scholar step 9 (an agent step that can be skipped, and that never fires for drift no ingest happens to touch — exactly why `erights--elang-same-ref` stayed missing across the 16:33Z–16:48Z cycles). Add `scripts/systemd/garden-regenerate-sections-index.service` + `.timer`, modeled byte-for-byte on the existing `garden-library-source-drift-scan.{service,timer}` (OnCalendar+Persistent, `Type=oneshot`, exec `/bin/bash .../scripts/jobs/regenerate-sections-index.sh` with no args = `--land`). The script is already idempotent (lands nothing when current) and returns `75 EX_TEMPFAIL` on a tip-sync outage so a missed tick simply retries next cadence — safe to run unattended. Wire it into `scripts/jobs/install-units.sh` alongside the other library timers. This depends on improve-land-sections-index-regenerator landing first.

---
claim:
  host: endolinbot
  gardener: 16
  claimed_at: 2026-06-28T16:52:29Z

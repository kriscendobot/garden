`scripts/jobs/gardener-scaler.sh` initializes `want=0` and only overwrites it when `$DIR/hosts/$host` exists AND its `gardeners:` line parses as an integer (lines ~22-29). So a genuinely absent `hosts/<host>` file or a malformed line silently scales the ENTIRE local fleet to 0 — `install-units.sh scale 0` then disables every gardener `--now`, SIGTERM-ing every in-flight handler at once (a fleet-wide `rc=143` storm). `sync_clone` already guards transient fetch outages, so this fires precisely when the desired-count signal is structurally missing — the wrong moment to tear down all workers. Change the contract so "cannot determine desired count" is a **no-op** (log a WARN and skip the `install-units.sh scale` call, leaving the pool unchanged) rather than scaling to 0; only an explicitly-read `gardeners: 0` should scale to zero. Update the header docstring's "Absent or unparsable → 0" line to match the new "absent/unparsable → leave pool unchanged" behavior.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolinbot
  gardener: 73
  claimed_at: 2026-06-27T19:45:48Z

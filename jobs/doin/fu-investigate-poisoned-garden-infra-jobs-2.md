In kriskowal/garden, harden the reaper against mass-poisoning from sustained environmental transients: it currently poisons a job after 5 cycles even when all 5 failures are sustained-environmental (e.g. an API/quota outage). Land a fix on main2 that either pauses the poison counter while the fleet brake is engaged or classifies sustained-outage transients so they don't accrue toward the poison threshold.

---
claim:
  host: endolinbot
  gardener: 30
  claimed_at: 2026-07-05T17:39:10Z

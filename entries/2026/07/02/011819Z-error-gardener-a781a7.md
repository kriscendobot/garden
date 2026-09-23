---
kind: error
role: gardener
host: endolinbot2
at: 2026-07-02T01:21:16Z
---
gardener-80 on endolinbot2: job improve-gardener-transient-failure-backoff-and-fleet-brake handler exited rc=1 classified transient, but elapsed is near-constant (7,7s) across the last 2 requeue cycles (cycle 2) — likely a DETERMINISTIC overrun misclassified as a blip, not an external kill/timeout; escalated ONE kind:error to the gardener inbox (elapsed-constancy overrun-suspect: improve-gardener-transient-failure-backoff-and-fleet-brake, sha=a1fc3beea4f7a95f6824aeced025d1972a4ebf16), left in doin for the reaper (requeue ownership unchanged)

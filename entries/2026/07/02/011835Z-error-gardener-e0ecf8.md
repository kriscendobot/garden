---
kind: error
role: gardener
host: endolinbot2
at: 2026-07-02T01:20:54Z
---
gardener-64 on endolinbot2: job improve-repo-watcher-arm-retry handler exited rc=1 classified transient, but elapsed is near-constant (2,2s) across the last 2 requeue cycles (cycle 2) — likely a DETERMINISTIC overrun misclassified as a blip, not an external kill/timeout; escalated ONE kind:error to the gardener inbox (elapsed-constancy overrun-suspect: improve-repo-watcher-arm-retry, sha=c1b887f477c8a4f0f68385097e8cdacd6dda3da4), left in doin for the reaper (requeue ownership unchanged)

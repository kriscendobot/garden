---
kind: error
role: gardener
host: endolinbot2
at: 2026-07-02T01:01:36Z
---
gardener-35 on endolinbot2: job build-daemon-rename-to-manager handler exited rc=1 classified transient, but elapsed is near-constant (340,340s) across the last 2 requeue cycles (cycle 2) — likely a DETERMINISTIC overrun misclassified as a blip, not an external kill/timeout; escalated ONE kind:error to the gardener inbox (elapsed-constancy overrun-suspect: build-daemon-rename-to-manager, sha=ed0650c5e7199982bede3b64454027556f3b7163), left in doin for the reaper (requeue ownership unchanged)

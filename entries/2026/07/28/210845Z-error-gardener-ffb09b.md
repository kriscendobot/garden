---
kind: error
role: gardener
host: ps23-garden-f65473ae
at: 2026-07-28T21:08:46Z
---
gardener-8 on ps23-garden-f65473ae: job measure-requeue-exit-knowledge-loss handler exited rc=1 classified transient, but elapsed is near-constant (299,299s) across the last 2 requeue cycles (cycle 3) — likely a DETERMINISTIC overrun misclassified as a blip, not an external kill/timeout; escalated ONE kind:error to the gardener inbox (elapsed-constancy overrun-suspect: measure-requeue-exit-knowledge-loss, sha=8ac8537fc88f00132439cd0e21806c95166529de), left in doin for the reaper (requeue ownership unchanged)

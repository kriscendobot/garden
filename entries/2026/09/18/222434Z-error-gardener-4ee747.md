---
kind: error
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-18T22:24:35Z
---
gardener-1 on endolin-garden2-5bcdff64: job self-heal-fix-garden-issue-inbox-cursor-get-pipefail handler exited rc=1 classified transient, but elapsed is near-constant (3,3s) across the last 2 requeue cycles (cycle 1) — likely a DETERMINISTIC overrun misclassified as a blip, not an external kill/timeout; escalated ONE kind:error to the gardener inbox (elapsed-constancy overrun-suspect: self-heal-fix-garden-issue-inbox-cursor-get-pipefail, sha=9ff634e70a087ada867f7259e2f2a4da5379443f), left in doin for the reaper (requeue ownership unchanged)

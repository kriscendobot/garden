---
kind: error
role: gardener
host: endolinbot
at: 2026-07-05T20:39:01Z
---
gardener-55 on endolinbot: job xs2rust-endor-build-stage3b-json-metering handler keeps exiting 0 without the completion signal (exit-0-unsatisfying), and elapsed is near-constant (2086,2086s) across the last 2 requeue cycles (cycle 2) — likely a WEDGED child, not a working one (the xs2rust-endor-press wedge), not a one-off quota/API blip; escalated ONE kind:error to the gardener inbox (elapsed-constancy exit0-wedge-suspect: xs2rust-endor-build-stage3b-json-metering, sha=a0f0832b4665ed7aabae880977850f6f5f25c17d), left in doin for the reaper (requeue ownership unchanged)

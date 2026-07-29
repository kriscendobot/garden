In the garden's own repo (kriscendobot/garden, branch `main2`, direct push — no PR), refine the wallclock cost proxy for multi-attempt jobs: `duration_secs` records only the final attempt, so for the ~255/1514 events with `attempts > 1` it understates wall time (a 2026-07-25 canary measured 25s claim→tada against a recorded 19s). Derive the true span from the claim→tada timestamps in the `journal2` commit log and use it in the proxy, with the existing proxy tests extended to cover the multi-attempt case.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  claimed_at: 2026-07-29T01:50:54Z

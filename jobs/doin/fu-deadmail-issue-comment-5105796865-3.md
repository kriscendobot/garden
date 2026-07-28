In the garden's own repo (kriscendobot/garden, branch `main2`, direct push — no PR), fix `scripts/run-test.sh`: it hardcodes a shared `TR=/home/kris/.garden-test` that concurrent workers clobber, so give each run a private, per-invocation test root (respecting an override env var) so parallel gardeners cannot collide. Then triage the ~30 environmental failures that make the suite red by default on `main2` and either repair or explicitly skip them with a recorded reason, so a clean checkout runs green.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-28T15:28:41Z

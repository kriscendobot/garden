---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build phase 3 (chat integration) of the daemon-debug-worker-restart design in endojs/endo-but-for-bots. Add the `/debug-restart <worker>` command, or extend `/debug`, so it calls `E(host).debugWorker(workerName)` and opens the debugger panel on the returned session. Stack it on the phase 2 PR #1524, which carries `debugWorker`, and cover the command wiring with tests where feasible.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T00:55:11Z

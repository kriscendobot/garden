---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/systemd/garden-worker@.service.in
Defect: scripts/systemd/garden-worker@.service.in:63 drains the main worker under `KillMode=mixed` but lacks the cgroup-settle backstop; systemd reported dozens of leftover `MainThread` processes on garden-cleric@1/@2 starts at 2026-10-23T06:27:31Z. Add bounded `ExecStopPost` cgroup draining, reusing `scripts/jobs/cgroup-drain.sh`, so restarts wait for residual descendants to leave before the next worker start.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-23T06:52:10Z

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/receipt-watcher.sh
scripts/jobs/receipt-watcher.sh:289 only reaps escaped cgroup descendants during exit; at 09:27:20 systemd found three leftover git processes while starting garden-receipt-watcher@kriscendobot-finbot. Reap verified prior-run stragglers before starting the PR source too, with the existing service-cgroup/ancestor guards, and add a regression fixture for the startup sweep.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T09:56:28Z

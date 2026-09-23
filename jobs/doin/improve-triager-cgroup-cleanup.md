---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Reap the triager tick’s fetch/handler process subtree on TERM and exit, using the hardened watcher process-group cleanup pattern so git descendants cannot survive a tick and trigger repeated systemd “left-over process” warnings. Align `garden-triager@.service` stop semantics and bounds with that cleanup.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T20:21:12Z

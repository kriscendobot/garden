---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Port the hardened cgroup-straggler reap from comment-watcher.sh (commit a6f6b82e0b) into scripts/jobs/receipt-watcher.sh. Symptom: garden-receipt-watcher@kriscendobot-moddable repeatedly leaves tee/cursor-set.sh/flock descendants alive in its service cgroup across ticks (confirmed via `systemctl --user status` showing stale PIDs from earlier ticks still attached, and journalctl showing a "start operation timed out. Terminating." kill of leftover cursor-set.sh/flock/tee processes at 23:16:09 UTC 2026-09-21), followed immediately by a bare, stderr-less "FATAL: receipt journal prerequisite failed ... rc=1" (receipt-watcher.sh:91) on the next tick — consistent with the forced cgroup-wide SIGKILL corrupting in-flight clone/lock state. dependabot-watcher.sh and issue-inbox-watcher.sh already carry the same `reap_cgroup_stragglers()` pattern (grep confirms; receipt-watcher.sh has none). Add a `reap_cgroup_stragglers()` function guarded on cgroup leaf `garden-receipt-watcher*.service` (never touching $$ or ancestors), call it from the existing `cleanup()` (receipt-watcher.sh:140-150) on every exit path (clean, TERM, INT), and use the wait-until-empty bounded-loop shape (re-read cgroup.procs each pass, SIGKILL stragglers, deadline-capped via a new GARDEN_RECEIPT_CGROUP_REAP_DEADLINE_SECS default 3s) rather than a one-shot snapshot, per the two races documented in a6f6b82e0b's commit message (fork-after-snapshot, exit-before-teardown). Mirror the FF3-style regression test from scripts/jobs/test/comment-watcher-test.sh into scripts/jobs/test/receipt-watcher-test.sh using a fixture cgroup.procs override.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-21T23:21:53Z

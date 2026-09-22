---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/receipt-watcher.sh, the line `sed 's/^/  prerequisite: /' "$PREREQ_ERR" >&2` (around line 89) prepends text before any leading `<N>` syslog-priority tag that log()/die() (common.sh) emit at column 0. This demotes the real ensure_clone/sync_clone failure diagnostic to journald's default "info" priority, so it is silently dropped by any `-p warning` capture (notably mentor.sh's self-heal journalctl read: `journalctl --user -u 'garden-*' -p warning`). Failure signature: a receipt-watcher FATAL log showing only "receipt journal prerequisite failed ... (see prerequisite stderr above)" with the referenced stderr never appearing anywhere in the warning-filtered journal.

Fix: preserve any leading `<N>` prefix when annotating the prerequisite stderr, e.g.:
    sed -E 's/^(<[0-9]>)?/\1  prerequisite: /' "$PREREQ_ERR" >&2
so a `<3>FATAL: ...` line becomes `<3>  prerequisite: FATAL: ...` (tag still at column 0) instead of losing its priority classification. Verify by feeding a fake PREREQ_ERR file containing a `<3>...` line through both old and new sed forms and confirming the tag position.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-22T02:04:28Z

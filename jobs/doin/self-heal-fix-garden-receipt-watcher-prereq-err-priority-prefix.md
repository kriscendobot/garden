---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/receipt-watcher.sh:89 (and the same `sed 's/^/  <label>: /' "$ERRF" >&2` pattern in ci-watcher.sh:321, comment-watcher.sh:1609/1629/1648/1653/1668, dependabot-watcher.sh:295, pages-watcher.sh:185/203, mention-watcher.sh:329, issue-inbox-watcher.sh:502, approval-reconciler.sh:428, dependabotany-preflight.sh:217, backfill-dropped-review-comments.sh:171), the sed prefix is inserted BEFORE any journald syslog-priority tag (`<3>`/`<4>`/`<6>`) that the relayed subshell's own `log()`/`die()` calls already wrote at the start of the line (common.sh:475-486, `SyslogLevelPrefix` convention). This corrupts the priority tag so journald can no longer classify the relayed line's severity, silently downgrading/hiding the actual root-cause diagnostic behind the generic outer FATAL — reproduced today by garden-receipt-watcher@kriscendobot-endo (rc=1), whose captured log tail contains only the outer "see prerequisite stderr above" FATAL with the referenced stderr itself missing. Fix by preserving a leading priority tag when present, e.g. change the sed to `sed -E 's/^(<[0-9]>)?/\1  prerequisite: /'` (mirror for the other labels/files), so the tag stays at column 0 and journald keeps classifying the real error correctly.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-21T21:47:10Z

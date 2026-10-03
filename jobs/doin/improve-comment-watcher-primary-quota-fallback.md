---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
scripts/jobs/comment-watcher.sh:1835 fatals two sibling watchers immediately after the 15:40:06 primary-quota refusal, although line 1772 handles only a source stderr match. On any source failure, also consult the shared primary-quota cooldown marker before `die`; if live, freeze the cursor and exit through the clean quota-degrade path. Add a concurrent-watcher regression test proving collateral quota failures cannot restart units.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-03T15:52:04Z

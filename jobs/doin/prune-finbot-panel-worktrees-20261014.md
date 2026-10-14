---
role: cleaner
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Prune two stale finbot panel worktrees

`worktrees/kriscendobot-finbot/panel-purist` and `worktrees/kriscendobot-finbot/panel-corner-prober` are clean, about 4 months old (2026-08-01), each with 2 unpushed commits (ff56e0d, 4d61ff1). Verify those commits are reachable from a remote branch or are superseded in kriscendobot/finbot; if not, push them to a `salvage/` branch on the fork first. Then remove both worktrees and their branches via the standard worktree teardown. Do not touch `worktrees/kriscendobot-minion.town/claude-root-kriscendobot-20261006` (live arc work).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-14T21:48:56Z

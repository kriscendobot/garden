---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# comment-watcher: recognize "run a gauntlet" (and compound "gauntlet and then retcon")

Garden repo (main2), scripts/jobs/comment-watcher.sh. The gauntlet verb is detected only via the literal
phrase "run the gauntlet" (~line 910). On 2026-09-28 a maintainer comment on endo-but-for-bots PR 1072
reading "Please run a gauntlet and then retcon." mapped only to a retcon job; the gauntlet was
silently dropped and had to be posted by hand (gauntlet record endojs-endo-but-for-bots-pr1072-gauntlet,
retcon parked blocked on it). Accept "run a gauntlet" as the same trigger, and consider having a
compound "X and then Y" directive post Y blocked_on X rather than only one verb. Add a test.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T20:53:09Z

---
tier: mentor
fallback-tier: minion
dispatch: automatic
role: fixer
---
Fix two gauntlet-staging defects in the garden (kriscendobot/garden, main2), reported by the arc kriscendobot/garden#89 completion press, 2026-10-05 23:05Z.

1. **Missed auto-stage.** A successful build job that opens a draft PR should stage its gauntlet automatically when it completes. `build-minion-town-caddy-restart-on-env-change` completed at 21:43Z with draft PR https://github.com/kriscendobot/minion.town/pull/163 and staged no gauntlet. This happened after c051d90c70b ("classify producer drafts by artifact") was deployed. The same class of miss hit https://github.com/kriscendobot/minion.town/pull/160 earlier the same day, and that gauntlet was staged late. The liaison has since staged #163 by hand (`kriscendobot-minion.town-pr163-gauntlet-20261005`). Find out why the completion edge skipped it, and fix that.

2. **No per-PR dedupe.** #160 ran two gauntlets at the same time: `build-minion-town-claude-guest-scoped-mcp-gauntlet` (the late auto-stage) and `kriscendobot-minion.town-pr160-gauntlet` (from a run-the-gauntlet request). Both fix loops pushed to the same head, for 8 fix rounds and 9 panels in total. Make `post-gauntlet.sh`, or the gauntlet driver, refuse or coalesce a second active gauntlet on the same PR, and log loudly when it does.

Add regression tests for both. Land on main2 directly.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-05T23:09:59Z

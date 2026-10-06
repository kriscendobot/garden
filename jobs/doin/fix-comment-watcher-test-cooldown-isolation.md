---
arc: garden-upkeep
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fixer job on the garden repo (kriscendobot/garden, main2): the remaining tests in the RATE section of `scripts/jobs/test/comment-watcher-test.sh` (and any other test that drives `gh_api_retry` or the comment-source quota path) may not set their own gh-api cooldown directory. When `GARDEN_ROOT` comes from the environment, they write a primary-quota latch into the live host's `.garden-state/gh-api-cooldown/marker`, which happened on 2026-10-06 around 16:27Z and blocked that host's `gh` calls. Point every such test at a temporary cooldown or state directory, and add a guard (for example, a post-suite assertion that the live marker is untouched) so a test can never latch the live fleet again.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-06T16:41:30Z

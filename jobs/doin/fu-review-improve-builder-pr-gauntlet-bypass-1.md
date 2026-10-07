---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In kriscendobot/garden (main2), fix the gauntlet re-stage for held-draft builder PRs. Its basename carries only a date, so it allows one re-review per PR per day: a second held-draft finish on the same PR that day matches the earlier re-stage and is silently skipped until the next day. Make the disambiguator unique per re-stage, for example by adding the time or the head SHA, and add a regression test (source: report review-improve-builder-pr-gauntlet-bypass).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-07T07:48:40Z

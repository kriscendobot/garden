---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/1538, handle the leftover hidden `.endo-staging-*` directory that stays in the mount when the daemon crashes mid-clone. The mount then counts as non-empty, so a retry needs a fresh mount. Either clean up stale staging directories on retry or exclude them from the emptiness check, and add a test.

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-23T08:13:45Z

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/fork-watch-provisioner.sh
scripts/jobs/fork-watch-provisioner.sh:232-250 classifies a known host-shared `gh-api` cooldown diagnostic as `rate-limit`, so lines 501-507 re-WARN every five minutes while the 3600-second shared latch remains live (2026-10-05T01:55:23Z–02:15:30Z). Recognize the admission-refused/live-cooldown response as quiet, or inherit its remaining duration, so only the latch owner emits the warning and fork probes defer silently until it clears.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-05T02:21:26Z

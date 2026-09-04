---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
All per-repo ci-watcher/dependabot-watcher/approval-reconciler/issue-inbox-watcher
instances hit the same gh-api 5xx/rate-limit blip simultaneously across every
watched repo, repeatedly, for 8+ minutes (2026-09-04 13:05-13:13Z journalctl) —
a self-inflicted thundering herd, not independent bad luck. comment-watcher.sh
already carries a fix for this exact shape (start_api_cooldown /
GARDEN_COMMENT_API_COOLDOWN_SECS, comment-watcher.sh:271-320): the first
instance to see the blip records a host-shared cooldown marker under
GARDEN_STATE, and every other watcher instance checks it before making its own
API call, so one blip freezes the whole fleet for one window instead of each
instance re-triggering the same rate limit every tick. Extract that mechanism
into a shared common.sh helper and wire it into ci-watcher.sh first (most
affected in this log), then port it to dependabot-watcher.sh,
approval-reconciler.sh, and issue-inbox-watcher.sh so all gh-api-calling
watchers share one cooldown window instead of each carrying its own copy or
none at all.

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->
<!-- garden-provider-quota-backoff: type=session reset-at=2026-09-04T18:40:00Z -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T16:36:16Z

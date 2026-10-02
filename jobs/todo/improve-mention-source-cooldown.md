---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/mention-source-gh.sh
scripts/jobs/handlers/mention-source-gh.sh:49 swallows `gh_api_retry` failures, so the 2026-10-02T04:39:22 primary-quota latch produced repeated `NOT ISSUED` warnings while the source appeared successful. Stop the source immediately on a cooldown/quota refusal and return a distinct transient status; update mention-watcher.sh to mark the heartbeat `cooldown` and skip quietly, with a regression test proving no subsequent source requests or warning storm.

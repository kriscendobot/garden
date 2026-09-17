---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mirror-closer.sh
mirror-closer.sh runs its own private GitHub-quota circuit breaker (MIRROR_QUOTA_MARKER, hour-long window, checked only at line 144 via mirror_quota_cooldown_active) instead of the shared host-wide latch common.sh already provides for exactly this purpose (api_cooldown_active/start_api_cooldown, GARDEN_API_COOLDOWN_SECS, used by ci-watcher.sh at line 131 `api_cooldown_active && exit 0`). On 2026-09-17 ci-watcher tripped the shared cooldown at 13:27:38 (300s window, still active), but mirror-closer had no visibility into it and independently fired a doomed `gh api graphql` call at 13:33:08, hit the same primary rate limit, FATAL'd on Agoric/agoric-sdk#11031's PR-state read (via handlers/mirror-pr-state-gh.sh), and only then armed its own separate 3600s cooldown. Add a check of the shared `api_cooldown_active` before mirror-closer's per-mapping loop starts (mirror the ci-watcher pattern), and have `start_mirror_quota_cooldown` also call `start_api_cooldown` so a rate-limit hit anywhere on the host immediately protects every other gh-api watcher instead of each one discovering exhaustion independently through its own wasted, doomed call.

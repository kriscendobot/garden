---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/common.sh
ci-watcher.sh's rollup_hit_primary_quota() routes GitHub PRIMARY hourly-quota exhaustion (distinct from a transient 5xx/HTML blip) through common.sh's shared start_api_cooldown, whose window is hard-capped at 900s — far shorter than GitHub's real ~1hr rate-limit reset. Journalctl shows the same quota-exhaustion WARN re-firing every ~5min (12:26/12:31/12:37Z) because each short cooldown expires and re-hits the still-exhausted API, burning calls and repeating log noise for the whole outage window. mirror-closer.sh already solved this correctly with its own dedicated ~3600s cooldown (MIRROR_QUOTA_MARKER / mirror_quota_cooldown_secs, scripts/jobs/mirror-closer.sh). Add a second shared primary-quota cooldown helper to common.sh (e.g. start_primary_quota_cooldown/primary_quota_cooldown_active, default ~3600s, mirroring the existing blip-cooldown pattern) and switch ci-watcher.sh's rollup_hit_primary_quota (and any other watcher that detects the same "doomed until quota recovers" signal) onto it instead of the 900s-capped blip cooldown — retiring mirror-closer.sh's private duplicate in favor of the shared helper.

<!-- garden-transient-elapsed: kind=signature through=0 values=16 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-17T13:03:11Z -->

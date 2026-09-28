from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-17T13:13:24Z
doom_base: improve-ci-watcher-primary-quota-cooldown-too-short
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-17T13:13:24Z
last_seen: 2026-09-17T13:13:24Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-ci-watcher-primary-quota-cooldown-too-short; it stays HELD until a human promotes it
(promote-plan.sh improve-ci-watcher-primary-quota-cooldown-too-short) or removes it, so nothing is lost.
Original job base: improve-ci-watcher-primary-quota-cooldown-too-short

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/common.sh
ci-watcher.sh's rollup_hit_primary_quota() routes GitHub PRIMARY hourly-quota exhaustion (distinct from a transient 5xx/HTML blip) through common.sh's shared start_api_cooldown, whose window is hard-capped at 900s — far shorter than GitHub's real ~1hr rate-limit reset. Journalctl shows the same quota-exhaustion WARN re-firing every ~5min (12:26/12:31/12:37Z) because each short cooldown expires and re-hits the still-exhausted API, burning calls and repeating log noise for the whole outage window. mirror-closer.sh already solved this correctly with its own dedicated ~3600s cooldown (MIRROR_QUOTA_MARKER / mirror_quota_cooldown_secs, scripts/jobs/mirror-closer.sh). Add a second shared primary-quota cooldown helper to common.sh (e.g. start_primary_quota_cooldown/primary_quota_cooldown_active, default ~3600s, mirroring the existing blip-cooldown pattern) and switch ci-watcher.sh's rollup_hit_primary_quota (and any other watcher that detects the same "doomed until quota recovers" signal) onto it instead of the 900s-capped blip cooldown — retiring mirror-closer.sh's private duplicate in favor of the shared helper.

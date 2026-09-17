---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/post-job.sh
The push-CAS retry loop (~line 268, `for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}")`) bounds itself only by attempt COUNT, not elapsed wall-clock time. Each attempt's `sync_clone` can take up to ~`GARDEN_FETCH_TIMEOUT + GARDEN_FETCH_KILL_AFTER` seconds (~55s default), so under sustained *degraded* (not cleanly "offline") connectivity the loop can run for tens of minutes. This is the likely cause of `garden-comment-watcher@endojs-endo-but-for-bots` blowing through its 900s `TimeoutStartSec` and then failing to honor its 20s `TimeoutStopSec` (a foreground `timeout` child defers signal delivery until it returns), ending in a hard SIGKILL and a `Failed` unit — noisy, and undiagnosed by self-heal-run.sh since the outer kill hits the wrapper itself, upstream of its own failure-classification path. Add an overall wall-clock deadline to the retry loop (track `SECONDS` at entry, bail with a clean offline-style log+exit once a bound well under callers' typical `TimeoutStartSec` is exceeded — e.g. a few hundred seconds), so a degraded-connectivity episode fails fast and clean like `ci-watcher.sh`'s stale-shepherd sweep does, instead of grinding through the full retry count and requiring a blunt systemd kill. `scripts/jobs/post-plan.sh` has the same loop shape and should get the same fix for consistency.

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-17T20:43:07Z -->

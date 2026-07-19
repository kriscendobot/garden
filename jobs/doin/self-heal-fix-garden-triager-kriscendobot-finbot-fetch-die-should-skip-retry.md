In `scripts/jobs/triager.sh` around line 117, the steady-state bare-clone fetch `git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"` hard-`die`s (exit 1) on a transient network failure — the observed signature is `Terminated` (git fetch reaped by SIGTERM / timeout) followed by `FATAL: fetch failed for <slug>`, which crash-loops the `garden-triager@<slug>` unit and triggers self-heal on every network blip. Make this fetch failure non-fatal and consistent with the self-provision clone path already in this same file (the `bounded_clone` failure branch that logs a WARN, `exit 0`s to retry next tick, and escalates only persistently via a throttled `alert_maintainer`). Concretely: on fetch failure, log a WARN ("fetch failed for $slug (transient? offline/DNS/reaped connection); skipping this tick, retry next tick"), and `exit 0` so the timer re-drives it, rather than `die`. Optionally add a durable consecutive-fetch-failure counter (mirroring the existing `cursors/failcount/<slug>` breaker) so a *persistently* unreachable remote still escalates once via `alert_maintainer` under a `triager-fetch-failed-<slug>` dedup key instead of failing silently forever. The cursor is untouched on skip, so no change is dropped.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: gardener
  claimed_at: 2026-07-19T03:04:22Z

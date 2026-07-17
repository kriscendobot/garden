In `scripts/jobs/triager.sh` around line 117, the standing `git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"` hard-dies on ANY fetch failure, causing a systemd FATAL/restart storm on a transient upstream blip (observed signature: `FATAL: fetch failed for kriscendobot-endo`, exit 1). Fix it to mirror `ci-watcher.sh`'s "tick rather than die" pattern (see ci-watcher.sh ~L250-270): capture the fetch's stderr to a temp file, and on failure, if `is_transient_net_error "$ERRF"` or `is_transient_gh_source_error "$ERRF"` (both already in common.sh) is true, `log "WARN: fetch for $slug unreachable (transient) — skipping tick"` and `exit 0` so the next timer tick retries; only `die "fetch failed for $slug"` on a structural failure (auth/404/malformed). Optionally add a throttled `alert_maintainer "triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}"` for persistence, matching the self-provision-failed escalation already in the file. This makes a routine GitHub/DNS blip a clean no-op skip instead of a crash loop.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-17T16:04:15Z

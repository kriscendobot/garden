In `scripts/jobs/triager.sh` around line 117, the primary bare-clone fetch `git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"` hard-dies (exit 1) on ANY failure, including a transient one. Observed failure signature: log shows `Terminated` (git fetch child reaped by SIGTERM on a hung connection) followed by `FATAL: fetch failed for <slug>`, causing a systemd restart storm on network blips. Fix: degrade transient fetch failures the same way `scripts/jobs/ci-watcher.sh` (lines ~250-263) and this script's own self-provision path already do — capture the fetch's stderr to a temp file, and on non-zero exit test it with the shared `is_transient_net_error` (and `is_transient_gh_source_error` if applicable); on a transient signature `log "WARN: fetch for $slug unreachable (transient network) — skipping tick"` and `exit 0`, otherwise keep the existing `die` so structural failures (auth, deleted fork, corrupt clone) still surface loudly. Match the exact pattern/comment style already in ci-watcher.sh so the two watchers stay consistent.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 18
  worker_kind: gardener
  claimed_at: 2026-07-19T08:24:12Z

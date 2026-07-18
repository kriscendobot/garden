In `scripts/jobs/triager.sh`, the bare-clone fetch at line 117 —
`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"` —
hard-`die`s (exit 1, crash-loop under systemd) on ANY fetch failure, including a
transient network stall. Observed signature: garden-triager@kriscendobot-vattr97
logged `Terminated` (git killed by SIGTERM/reaper on a stuck fetch) followed by
`FATAL: fetch failed for kriscendobot-vattr97`, exit 1.

Two problems: (1) unlike `bounded_clone` (common.sh:717) and `journal_fetch`
(common.sh:1662), this fetch is NOT wrapped in the `timeout --kill-after=$GARDEN_FETCH_KILL_AFTER $GARDEN_FETCH_TIMEOUT` discipline, so it relies on an external SIGTERM to unstick a half-open connection (git has no IO timeout); (2) it violates this file's own graceful-degrade philosophy — the provision-failed path
(lines 94–104) and the handler circuit-breaker skip-and-retry on transient
failure rather than `die`.

Fix: replace the line-117 fetch with a bounded, transient-aware version, mirroring
the existing patterns in this file/common.sh:
  - Run the fetch under `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"`, capturing stderr and the real rc (use the `if VAR="$(... 2>&1 1>/dev/null)"; then rc=0; else rc=$?; fi` idiom so `set -e` doesn't abort before rc is read).
  - On a transient result — rc 124/137 (wall-clock kill) OR stderr matching a transient signature via `is_transient_net_error` / `_fetch_stderr_is_offline` (`$GARDEN_OFFLINE_SIGNATURES`) — `log "WARN: ..."` and `exit 0` to skip this tick and retry next tick, exactly like the provision-failed path; add a throttled `alert_maintainer "triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}" "$msg"` so a persistent outage escalates at most once per dedup window.
  - Only `die` on a genuinely structural fetch error (non-transient, non-timeout), preserving the loud-surface behavior for a real bug.
Add/extend the triager test guards to cover a transient fetch failure resolving to
a clean skip (exit 0) rather than a crash.

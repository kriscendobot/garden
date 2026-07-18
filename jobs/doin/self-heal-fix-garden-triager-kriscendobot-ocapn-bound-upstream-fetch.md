In scripts/jobs/triager.sh, the upstream fetch at line 117 (`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`) is unbounded and un-retried, unlike every other fetch/clone in the fleet. A hung/half-open upstream fetch gets SIGTERM'd (log signature: a bare `Terminated` line immediately followed by `FATAL: fetch failed for <slug>`), and the bare `die` turns that transient network stall into exit 1, which trips the self-heal responder every time.

Fix: give this fetch the same bounded+retry discipline as `bounded_clone` / `_journal_git_fetch` in scripts/jobs/common.sh — wrap it in `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"` over `GARDEN_FETCH_RETRIES` attempts (ideally factor a small `bounded_bare_fetch <git-dir>` helper in common.sh next to `bounded_clone`, or inline the same loop). On persistent failure, treat it as transient like the provision path already does: `log` a WARN, throttle an `alert_maintainer "triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}"`, and `exit 0` to retry next tick — do NOT `die`, so a network blip skips the tick instead of exiting 1 and re-firing self-heal. Distinguish a timeout kill (rc 124/137) from a real remote error in the log message, matching common.sh's existing convention.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 10
  worker_kind: cleric
  claimed_at: 2026-07-18T14:45:32Z

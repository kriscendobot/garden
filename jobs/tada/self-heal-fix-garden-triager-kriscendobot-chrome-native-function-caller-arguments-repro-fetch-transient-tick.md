The requested fix is already present in `origin/main2` (which this worktree is checked out from), so there is no work left to do.

## Report

**Finding: already fixed — no-op.** The job asked to replace the hard-dying steady-state bare-clone fetch in `scripts/jobs/triager.sh` (`git … fetch … || die "fetch failed for $slug"`) with the degrade-on-transient pattern used by `ci-watcher.sh`. That exact remediation is already merged at `origin/main2` (HEAD `fae75ed3d3`), landed across three prior commits:

- `a17694d07d` — bound the steady-state fetch with `timeout`/`--kill-after`/retry+backoff.
- `b20e03ff3c` — classify a non-transient steady-state fetch failure as skip, not die.
- `fae75ed3d3` — steady-state fetch failure skips **and** alerts (throttled), never dies.

Current state of `triager.sh` (lines 117–177) matches — and slightly exceeds — the job's spec:
- The fetch is wrapped in a bounded retry loop capturing stderr to a temp file (`ERRF`).
- On non-zero exit it classifies via timeout codes (124/137/143) and the shared `is_transient_net_error "$ERRF"`, logging a `WARN:` and `exit 0` (skip the tick, retry next fire) instead of dying — the same pattern/comment style as `ci-watcher.sh` (lines ~250–263).
- It goes one step further than the spec by also routing a throttled per-slug `alert_maintainer` for *every* failure class (including persistent/structural ones) rather than a bare `die`, so a genuinely broken clone still surfaces loudly (once per window) without an every-tick systemd restart storm.

Verification: `grep` confirms no `die "fetch failed` remains in the file; `bash -n` passes.

Nothing to commit or push; the worktree is unchanged from `origin/main2`. No follow-ups.

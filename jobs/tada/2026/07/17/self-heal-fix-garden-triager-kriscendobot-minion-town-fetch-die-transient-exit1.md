The job's requested change already landed in commit `38225af5a5` on `main2`, which is exactly where my worktree is checked out. There is nothing left to implement.

## Verification

**The fix is present** — `scripts/jobs/triager.sh` no longer hard-`die`s on a transient steady-state fetch failure. The old line-117 `... fetch -q --all --prune || die "fetch failed for $slug"` has been replaced (lines 117–155) with exactly the pattern the job describes:
- The fetch runs bounded under `timeout --kill-after=$GARDEN_FETCH_KILL_AFTER $GARDEN_FETCH_TIMEOUT` with backoff retry up to `$GARDEN_FETCH_RETRIES` (mirroring clone-keeper's `bounded_fetch` / common.sh's `journal_fetch`).
- On failure it `log`s a WARN, calls `alert_maintainer` under the per-slug throttle dedup key `triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}`, then `exit 0` to retry next tick — matching the missing-clone self-provision path (lines 95–104) and the handler circuit breaker (lines 149+).
- The cursor is not advanced (nothing to advance to).

**The test is present** — `scripts/jobs/test/triager-test.sh` case M (lines 552–587) covers the fetch-failure path, mirroring the missing-clone transient-skip cases: it forces `git … fetch` to fail via a scoped shim and asserts exit 0, the WARN log, the throttled `triager-fetch-failed-<slug>` escalation, that the handler is never invoked, and that the activity cursor is not advanced.

**Test suite passes** — `82 passed, 0 failed`, including all five case-M assertions.

No code changes were needed and no new commit was produced; the working tree is clean against `origin/main2`. No follow-ups.

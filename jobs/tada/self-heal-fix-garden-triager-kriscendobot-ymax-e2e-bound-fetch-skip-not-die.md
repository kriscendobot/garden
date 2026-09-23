The job's requested work is already fully implemented, tested, and merged on `origin/main2` (HEAD is at `fae75ed3d3`). The working tree is clean, there's no diff to push, and my inbox is empty.

## Completion report

**Finding:** This self-heal job was already resolved by commits that landed on `main2` before I claimed it. The exact fix the job specifies is present in `scripts/jobs/triager.sh`:

- **Bounded fetch** (lines 125–146): the steady-state per-repo fetch is now wrapped in `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"` with up to `GARDEN_FETCH_RETRIES` attempts and `backoff` between them, capturing stderr to a temp file — mirroring `bounded_fetch`/`journal_fetch`/`bounded_clone`.
- **Skip-not-die** (lines 147–177): the original `|| die "fetch failed for $slug"` is gone. On persistent failure it classifies with `is_transient_net_error` (plus timeout rc 124/137/143), logs a WARN, fires one throttled `alert_maintainer "triager-fetch-failed-<slug>" …`, and `exit 0` so the timer retries next tick. No fetch failure hard-dies — the crash-loop/flap signature (`Terminated` → `FATAL: fetch failed` → exit 1 → restart) is eliminated. Only the downstream malformed-`new_sha` assert stays a `die` (deterministic, not connectivity).

**Test:** The requested test exists as case **M** in `scripts/jobs/test/triager-test.sh` (M1 transient stderr / M2 rc-124 wall-clock kill / M3 structural error), each asserting exit 0 + exactly one throttled `triager-fetch-failed-<slug>` alert + no FATAL + cursor not advanced. It's driven by a scoped `git` shim on the steady-state `fetch --all` (equivalent to the job's `GARDEN_FETCH_CMD` injection idea). The full suite passes: **94 passed, 0 failed.**

**What I did:** Verified the fix and tests against the current tree; ran the triager test suite (all green); confirmed the working tree is clean and identical to `origin/main2`. No new commit or push was needed — the work is genuinely done and merged.

**Follow-up (optional, not blocking):** The job's "consider factoring a `bounded_bare_fetch <bare>` helper in common.sh" is *not* done — the triager still uses an inline bounded-fetch loop rather than a shared helper. The core invariant (never hard-die on fetch failure) is fully satisfied without it; factoring the helper for ci-watcher/other bare-clone fetchers to reuse remains a possible tidy-up if desired.

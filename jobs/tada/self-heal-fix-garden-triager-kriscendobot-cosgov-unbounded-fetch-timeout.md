Done. Inbox is clear and the change is pushed to `main2`.

## Completion report

**Job:** Bound the last unbounded git fetch in the fleet — `triager.sh`'s steady-state clone refresh.

**What I found:** The fetch was no longer the raw `... || die` the job spec quoted; commit `2fc8532937` had already wrapped it in `timeout --kill-after`/`GARDEN_FETCH_TIMEOUT` plus transient classification. But it still ran a **single attempt** — it lacked the `GARDEN_FETCH_RETRIES` bounded-retry loop that `bounded_fetch`, `bounded_clone`, and `journal_fetch` all use. That was the remaining gap versus the job's intent. (The spec's `is_transient_git_error` at `common.sh:289` is an imprecise name for the real `is_transient_net_error`, which the code already uses correctly, so no rename was warranted.)

**What I changed** (`scripts/jobs/triager.sh`, lines ~117–152):
- Wrapped the timeout-bounded fetch in a `while` retry loop of `GARDEN_FETCH_RETRIES` attempts with `backoff` between tries, mirroring `bounded_fetch`/`journal_fetch`.
- Each attempt keeps its wall-clock deadline via `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"`; a 124/137 timeout kill is logged per-attempt.
- The last attempt's stderr is retained in `$ERRF` and, on final failure, classified: transient (rc 124/137/143 or `is_transient_net_error`) → `log WARN` + `exit 0` to skip the tick and retry next timer fire; structural (auth/refspec/corrupt) → keeps the loud `die`.
- Updated the surrounding comment to name the captured `Terminated`/`FATAL: fetch failed` signature and the retry discipline.

**Verification:** `bash -n` clean; confirmed `backoff` is defined in `common.sh:624`; confirmed line 131 is now the only runtime `git fetch` in the file and it is bounded (the other clone path already uses `bounded_clone`).

**Commit:** `fix(triager): bound steady-state fetch with retries` — pushed to `origin/main2` on the first CAS attempt.

**Follow-ups:** None. This converts the ambient network hang into a bounded, retriable, self-classified skip so a stalled connection can no longer wedge the unit past its start-timeout and re-trigger the self-heal responder.

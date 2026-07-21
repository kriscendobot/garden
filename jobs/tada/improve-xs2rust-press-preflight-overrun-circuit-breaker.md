Inbox empty. The work is complete and pushed to `main2`.

## Completion report

**Job:** Add a deterministic circuit-breaker to `scripts/jobs/gardening/xs2rust-endor-press-preflight.sh` so a chronically-overrunning press-driver stops burning a Fable budget every cadence.

**What I did:**

1. **Preflight (`xs2rust-endor-press-preflight.sh`):**
   - Added a per-host `consecutive-stall-dispatches` counter persisted in `$STATE_DIR` alongside `last-head` (`STALL_FILE`), with `read_stall_count`/`record_stall_count` helpers (an absent/non-numeric file reads as 0 — fails toward *not* tripping).
   - Added `GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES` (default 3, sanitized against non-numeric overrides).
   - **Increment** on the final stall branch (the `exit 0` dispatch), and log which stall-dispatch-of-N this is.
   - **Reset to 0** when HEAD advances (`cur != prev`) and when a terminal PR state defers (merged/closed/ready).
   - **Breaker fires** when the counter reaches the threshold: DEFER (exit 2) instead of dispatching, and raise **one throttled** `alert_maintainer` (dedup key `xs2rust-endor-press-wedged-${GARDEN}`) reporting the wedged campaign and prescribing the human remedy (split into claim-sized build-stage children or run detached per gardener.sh:391).
   - **Fail-open preserved:** an unreadable HEAD still dispatches and leaves the counter untouched — the breaker only fires on the positively-observed repeated-stall signature (clean HEAD read, unchanged across ticks, persisted streak).
   - Updated the header doc block and the State comment to describe the breaker.

2. **Tests (`run-test.sh` SUBTEST 8c):** Added cases 13–16 — counter increments under threshold (still dispatches), breaker defers + raises exactly one alert at threshold, HEAD-advance resets and re-arms, terminal PR state resets, and an unreadable HEAD fails open leaving the counter untouched. Existing cases 1–12 remain correct (their exit codes are unchanged; the counter only rides alongside).

**Verification:** `bash -n` clean on both files. Ran a focused standalone harness reproducing the 8c fixture for the four new cases — **11/11 assertions pass** (the sole apparent failure was a `/tmp` `noexec` artifact of my harness; re-run under an executable-friendly dir passed all). The full `run-test.sh` exits early at SUBTEST 4 (gardener-scaler, a pre-existing environment limitation in a bare worktree with no systemctl mock) — unrelated to this change, which lives entirely in SUBTEST 8c and the preflight.

**Changed:** `scripts/jobs/gardening/xs2rust-endor-press-preflight.sh`, `scripts/jobs/test/run-test.sh`. Committed as `2898c87d73` and pushed to `main2` (fast-forward, first attempt).

**Note / follow-up:** I initially edited `run-test.sh` in the deployed garden root (`/home/kris/garden2`) by mistake; I restored that file cleanly from its own HEAD (read-only `git show` + file write, no ref/origin mutation) and re-applied the change inside my worktree, so the root is untouched. No other follow-ups.

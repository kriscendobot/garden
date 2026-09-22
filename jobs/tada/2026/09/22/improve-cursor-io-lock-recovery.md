Inbox empty. Work complete.

## Completion report

**Job:** `improve-cursor-io-lock-recovery` — treat a timed-out shared cursor-IO lock as temporary unavailability, not a fatal failure; remove misleading manual lock-file deletion advice; add safe holder/recovery diagnostics.

**What I did**

- **`scripts/jobs/cursor-set.sh`** — Replaced the `die` on `cursor_io_lock` timeout with a temporary-unavailable skip (`exit GARDEN_OFFLINE_RC`, the same quiet verdict `cursor-get` already returns). A wedged holder no longer hard-fails cursor advancement for the full `GARDEN_CURSOR_LOCK_WAIT` (~5 min) window or feeds `die`-driven retry noise; the caller re-advances next cadence and re-processes the range idempotently (cursor advances only after work is durable). Removed the misleading `rm -f <lockfile>` advice.
- **`scripts/jobs/common.sh`** —
  - `cursor_io_lock` now stamps `"PID EPOCH"` into the lock file on acquire (reusing the existing `_clone_lock_stamp`), matching `clone_lock`, so a timed-out waiter can name the holder.
  - Added `_cursor_io_lock_holder <clone-dir>`: a safe, read-only, bounded one-line diagnostic reporting the live holder (pid + age + command) or noting a dead holder whose lock flock has already freed. Its comment documents *why* `rm -f` on an flock'd file is unsafe (doesn't free the flock; can hand two writers the shared index at once).
- **`scripts/jobs/cursor-get.sh`** — Enriched its existing lock-timeout log line with the same holder diagnostic for consistency.
- **`scripts/jobs/test/cursor-set-concurrency-test.sh`** — Rewrote SUBTEST 3 (previously asserted a loud `die`) to assert the new contract: bounded temporary-unavailable rc (75), holder named in the diagnostic, and **no** `rm -f` advice.

**Verification** — All tests pass: `cursor-set-concurrency-test.sh` (8/8), `stale-lock-test.sh` (9/9), `cursor-outage-cooldown-test.sh` (57/57). Syntax-checked all four files.

**Committed & pushed** to `main2` as `7fa754ed36`.

**Follow-ups** — None required. Caller comments in the watchers (mention/comment/issue-inbox) that describe cursor-set's exit codes remain accurate (they already handle rc=75 and the rc=1 push-exhaustion die still exists); no change needed. Note `mention-watcher.sh` logs a `WARN` on any nonzero rc including 75 (unlike `triager.sh`, which is quiet on 75) — a pre-existing minor inconsistency, harmless (no hard crash), left untouched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-cursor-io-lock-recovery.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1680299 cached reads)
- Output: 16277 tokens
- Cost: $1.9756025000000004
- Wall-clock: 253s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->

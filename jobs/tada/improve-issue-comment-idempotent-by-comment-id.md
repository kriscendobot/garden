Done. Here is my completion report.

---

## Completion report: `improve-issue-comment-idempotent-by-comment-id`

**Outcome:** Shipped. Pushed to `origin/main2` as commit `f9b405a76`. Full test suite green (235 passed, 0 failed). Worktree torn down, inbox drained (empty).

### What changed

1. **`scripts/jobs/inbox-send.sh`** — now honors a caller-supplied deterministic message id via `GARDEN_MSG_ID`, falling back to the legacy random `date+urandom` id when unset. The supplied id is sanitized to the filesystem/ref-safe charset (same as `post-job.sh`/`deadmail.sh`) and rejected if it sanitizes to empty or a leading `-`. Both the live-inbox filename (`inbox/<doer>/unread/<id>.md`) and the dead-letter filename (`inbox/dead/<id>.md`) become stable. Added two idempotent fast-path skips: a live send whose file already exists in `unread/` **or** `read/` is a no-op success (no double-deliver while the doer is alive and even after it has drained to `read/`); a dead-letter send whose pending file already exists skips the rewrite.

2. **`scripts/jobs/issue-inbox-watcher.sh`** — the issue-comment branch now passes `GARDEN_MSG_ID="issue-comment-$id"` (where `$id` is the stable GitHub comment id, field 3 of the row) to `inbox-send.sh`. A re-poll of the same comment (coldstart, lost/reset cursor, or an `updated_at`-driven re-surface from the `?since=` feed) now maps to the same path, so no duplicate dead-letter, no duplicate `deadmail-issue-comment-<cid>` promoted job (already basename-idempotent in `post-job.sh`), no duplicate gardener run, and no duplicate reply.

3. **`scripts/jobs/test/run-test.sh`** — added SUBTEST 26 **case H**: polls the same comment twice with a fresh `GARDEN_STATE` (resets the watcher's own cursor dedup so the inbox-level idempotency is what's actually exercised). Asserts exactly one delivery for a live doer (filename pinned to `issue-comment-9500.md`), and for a dead doer: exactly one dead-letter at the comment-id path, plus exactly one promoted job even after a re-poll-and-re-promote cycle.

### Incidental fix (proactive)

While running the full suite I found **SUBTEST 9 (WATCHMAN)** failing on a clean `origin/main2` — stale since the deliberate-deploy commit retired the continuous fast-forward (`watchman.sh` now defaults `GARDEN_AGGRESSIVE_CHECKOUT=0`), but the subtest still invoked the watchman without opting in while asserting a fast-forward. Since I was already editing `run-test.sh` and a green suite was needed to verify my own change, I repaired it in the same commit: the subtest (named "aggressive main2 checkout") now passes `GARDEN_AGGRESSIVE_CHECKOUT=1` to exercise the legacy path it tests.

### Follow-ups

- None blocking. The dead-letter re-create-after-promotion edge (poll 3 re-creates the file once, deadmail no-ops the post and re-retires it) is benign churn bounded to reset-cursor scenarios and is covered by the test.

Self-improvement: nothing this time (the SUBTEST 9 staleness was a one-off test-drift fixed in place, not a recurring lesson worth encoding).

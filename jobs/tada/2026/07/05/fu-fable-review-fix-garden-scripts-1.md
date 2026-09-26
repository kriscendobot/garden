Job complete. Verified state — no new commit needed.

# Completion report: fu-fable-review-fix-garden-scripts-1

**Task.** Apply the accepted watcher fix — kill the head-of-line `break` in the two affected watchers and port comment-watcher's `fail_floor` shape to `scripts/jobs/{mention,issue-inbox}-watcher.sh`.

**Finding.** The fix was already landed on `origin/main2` as commit `a95c0fe7a` ("watchers: port comment-watcher's fail_floor to the mention + issue-inbox watchers"), pushed by a prior incarnation of this job that the reaper requeued mid-flight (the exact ~18-min-requeue-against-40-min-handler churn that sibling job `-2` is fixing; the successor commit `c5b61affc` on main2 is that peer's two-writer fix). Rather than re-do work already on the remote, I verified it is complete and correct.

**What the landed fix does** (both watchers):
- Every `failed=1; break` on a POST-LOST (and, in mention-watcher, trust-INDETERMINATE) item is replaced with `failed=1; fail_floor=<first-failed created_at>; continue` — later independent items in the same batch are still classified/dispatched this tick instead of being abandoned behind a stuck front item (the #594 head-of-line class).
- A `slide()` helper freezes the high-water cursor once the first failure is recorded, so the cursor only advances over the contiguous successful prefix strictly below the floor; the failed item re-polls next tick idempotently.
- mention-watcher additionally captures the source's stderr (was `2>/dev/null`, the silent-blindness signature) and degrades a transient network blip to a skipped tick rather than a die→restart storm.

**Verification I ran:**
- `mention-watcher-test.sh` → **25 passed, 0 failed** (incl. held-floor + indeterminate-trust-floor cases).
- `issue-inbox-watcher-test.sh` → **28 passed, 0 failed** (incl. held-floor case: later comment delivered despite earlier lost issue-post, cursor frozen at floor).
- `grep` confirms **no `failed=1; break` batch-loop pattern remains** in either file (remaining `break`s are the legitimate process-ancestry walk).
- `git merge-base --is-ancestor a95c0fe7a origin/main2` → **true**: the fix is on the remote.

**Changed:** nothing new this run — the deliverable was already committed and pushed. Working tree clean; inbox empty.

**Follow-ups:** none for this job. The reaper requeue-with-live-handler defect that caused this job to be split/resumed is already covered by sibling job `fu-fable-review-fix-garden-scripts-2`.

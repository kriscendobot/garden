`verify_fetch` now holds the shared VERIFY clone's lock from before the clone check through the end of the fetch, so concurrent comment-watcher ticks can no longer fetch into that clone at the same time. The full comment-watcher test suite passes (384/384), and the fix is pushed to `main2` as `46e100b6641`.

**What changed** (`scripts/jobs/comment-watcher.sh`, `verify_fetch`):
- It takes `clone_lock "$VERIFY"`, runs the clone check and heal, then the fetch when one is due, and releases the lock afterwards. The return value is unchanged: 0 on success, 1 if the fetch fails.
- `ensure_clone` runs in a subshell, the same way `sync_clone` does. Called directly, its closing `clone_unlock` would drop the outer lock partway through. In the subshell it closes only its own copy of the lock's file descriptor, so the parent keeps the lock.
- The subshell would hide `ensure_clone`'s offline exit or failure, so `verify_fetch` releases the lock and re-raises that exit code. Behavior when offline is the same as before.

**Regression test** (`scripts/jobs/test/comment-watcher-test.sh`, new VLOCK section): a stand-in fetch command checks, without waiting, whether `verify.lock` is held each time the VERIFY clone is fetched. The test asserts:
- the directive is still posted;
- every VERIFY fetch ran while the lock was held (2 of 2);
- the lock is released after the run.

Against the old code this check fails (both fetches ran unlocked); with the fix it passes.

**Follow-ups:**
- **Unlocked reads:** the `git cat-file`/`git show` reads after the fetch still run without the lock. They are read-only and fetches are now serialized, so I left them alone. If corrupt-clone self-heals keep appearing after this deploys, those reads are the next thing to lock.
- **Deploy:** the fix reaches running hosts through the normal rolling deploy. The self-heal count in the logs should drop to about zero afterwards.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-watcher-verify-fetch-lock-window.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (803430 cached reads)
- Output: 6911 tokens
- Cost: $0.8211939999999999
- Wall-clock: 239s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->

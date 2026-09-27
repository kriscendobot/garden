`ci-watcher.sh`'s `verify_fetch` now holds the clone lock across both the clone check and the fetch, and a new regression test covers it. It's pushed to `main2` as `4948cdd9a75`, and `scripts/jobs/test/ci-watcher-test.sh` passes 81/0 after rebasing on the latest `main2`.

**The fix** (`scripts/jobs/ci-watcher.sh`) copies the comment-watcher fix (`46e100b6641`):
- It calls `clone_lock "$VERIFY"` before the check and `clone_unlock "$VERIFY"` after the fetch.
- `ensure_clone_or_latch_outage "$VERIFY" ci-watcher-verify` runs in a subshell. If it exits because the journal is offline (such as the quiet exit 75), the script unlocks first and then exits with the same code.
- A failed `journal_fetch` now returns 1 after unlocking, where before it returned 1 straight away.

**The test** is a new VLOCK section in `ci-watcher-test.sh`. A stand-in fetch command records whether the lock file is held each time the VERIFY clone is fetched. The test checks three things: the shepherd job is still posted, every fetch ran with the lock held, and the lock is released after the run. With the fix reverted, the test fails ("FREE FREE FREE"), so it does catch the bug.

**The race described in the job was already mostly gone.** A few minutes before I claimed this job, commit `5620bdbe5f6` ("isolate CI watcher clones per slug") gave each repo's watcher its own VERIFY clone (`verify-$slug`). That removed the single clone that ~15 watchers were sharing, which caused the lock-wait FATALs. Another recent commit, `c38cb55b172`, also makes busy clone-lock timeouts exit quietly instead of fatally. So this change is now extra protection rather than the main fix. It still stops two runs that touch the same clone from colliding, for example a manual run beside the scheduled tick, or a `GARDEN_CI_VERIFY_CLONE` override pointing several watchers at one clone. It also makes ci-watcher consistent with comment-watcher. I reworded the code comment to say this.

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-verify-fetch-lock-window.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (609152 cached reads)
- Output: 5254 tokens
- Cost: $0.6687424000000001
- Wall-clock: 85s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->

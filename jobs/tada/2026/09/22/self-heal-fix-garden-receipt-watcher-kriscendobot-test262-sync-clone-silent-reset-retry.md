Inbox is empty. The job is complete.

## Completion report

**Job:** Fix `sync_clone()`'s silent second-reset failure path in `scripts/jobs/common.sh` and add test coverage.

**Finding:** The production code fix the job describes had **already landed 6 hours before I claimed** — commit `85ae2f878c4` ("fix(common): die() on sync_clone final reset failure") wrapped the post-re-fetch second reset with `|| die "hard reset of $dir to origin/$JOURNAL_BRANCH failed after retry"` (now at `common.sh:6388-6389`). That commit is an ancestor of my base (`origin/main2`), so the silent `set -e` fall-through the job diagnosed is closed. It did **not**, however, add the test the job explicitly asks for.

**What I did:** Added the missing regression test — the remaining deliverable.
- Extended `scripts/jobs/test/receipt-watcher-test.sh`'s git shim with a `FAIL_GIT_RESET` knob that fails only `reset --hard origin/<branch>` (both attempts), leaving clone/fetch/config/clean intact.
- Added a structural-failure case that drives the second-reset path precisely: `GARDEN_FETCH_CMD` succeeds (skipping the offline/corrupt branches), the first hard reset fails, the re-fetch succeeds (rc=0 → offline guard false, no transient reclassification), and the second reset fails too. It asserts `sync_clone` dies with a priority-tagged diagnostic (`<3> prerequisite: … FATAL: hard reset … failed after retry` + `FATAL: receipt journal prerequisite failed`) and that the watcher does **not** hit the empty-stderr "no diagnostic captured" branch — the exact observed FATAL signature.

**Verification:**
- Full suite: 12 passed, 0 failed (was 11).
- Reverted the `|| die` guard to a bare reset → the new case correctly **fails** (11 passed, 1 failed), then restored the fix → 12/12. So the test genuinely exercises the fixed path.
- `shellcheck -S warning` clean.

**Changed:** `scripts/jobs/test/receipt-watcher-test.sh` only (+42 lines). Pushed to `main2` as `8e9cfaa7437`.

**Follow-ups:** None. The `common.sh` fix and its regression test are both now on `main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-kriscendobot-test262-sync-clone-silent-reset-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1472299 cached reads)
- Output: 17201 tokens
- Cost: $1.8530564999999999
- Wall-clock: 275s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->

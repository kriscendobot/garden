I made no changes: a sibling job had already landed the fix, and I confirmed it covers this case.

**What was already there:** commit `5b48813cd0b` on `origin/main2` ("fix(jobs): classify clone_lock busy-holder give-up as transient outage") came from the sibling self-heal job for `garden-ci-watcher@kriscendobot-moddable`. It is the same failure as the `kriscendobot-vattr97` one this job describes.
- In `scripts/jobs/common.sh`, `journal_bounded_fetch_is_ambiguous_outage` now also matches `cannot acquire clone lock .* after [0-9]+ waits`. That is the message `clone_lock` dies with when a live holder is still busy.
- So `ensure_clone_or_latch_outage` now starts the outage cooldown and exits quietly with `GARDEN_OFFLINE_RC` instead of failing loudly. That fixes the ci-watcher tick for every caller that shares a clone: ci-watcher, comment-watcher, triager, receipt-watcher and mirror-closer.
- It only matches at rc=1, and only after the existing check that rules out definite failures such as git-internal lock errors.
- The stale-holder reclaim path (`_clone_lock_is_stale` and the steal branch) is untouched.
- It extends the existing predicate instead of adding the separate one the job suggested. The effect is the same.

**Checks:**
- The commit adds tests to `scripts/jobs/test/cursor-outage-cooldown-test.sh` using this exact error message. They check that it now counts as a temporary outage (cooldown started, `GARDEN_OFFLINE_RC` returned) and that the predicate only matches at rc=1.
- I ran the suite: 61 passed, 0 failed.
- `origin/main2` had nothing newer than that commit.

**Follow-up:** the fix only reaches the fleet at the next deliberate deploy. Until then, the vattr97 and ocapn ci-watcher units can still hit this crash. Check how far behind the deploy is before posting another self-heal job for the same error.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-kriscendobot-vattr97-clonelock-busy-not-latched.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (163747 cached reads)
- Output: 1282 tokens
- Cost: $0.38828540000000006
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->

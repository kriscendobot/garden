The fix is on `main2` as `e6ea1d33fc8`. When a `garden-ci-watcher@<repo>` instance can't get the shared VERIFY clone lock because a live peer holds it, the tick now skips quietly with exit 75 instead of failing and restart-looping. The existing test suite passes (61 passed, 0 failed), including two new cases for this.

**What was wrong:** every `garden-ci-watcher@<repo>` instance uses the same VERIFY clone and lock. When one repo's re-clone ran longer than the lock's wait limit (3 waits of 60s), every other repo's tick gave up with "cannot acquire clone lock … after N waits". Neither outage check in `common.sh` recognized that message, so `ensure_clone_or_latch_outage` treated it as a real fault and the unit failed.

**The change, in `scripts/jobs/common.sh`:**
- **New check, `clone_lock_is_busy_contention <rc> <diagnostic>`:** true when the exit code is 1 and the error contains `cannot acquire clone lock .* after [0-9]+ waits of [0-9]+s and [0-9]+ reclaim attempt`. It is ignored when a definite failure (auth, missing upstream, corruption, local fault) also appears, as with the existing ambiguous-outage check.
- **`ensure_clone_or_latch_outage`** calls it after the offline and ambiguous-outage checks. On a match it logs one line and exits with `GARDEN_OFFLINE_RC` (75), which `self-heal-run.sh` already treats as a clean skip. The function's header comment now describes this case.

**Where I departed from the job text:** it proposed also starting the shared journal-outage cooldown. I didn't, because the journal itself is fine and only one shared clone is busy. The cooldown is host-wide, so starting it would pause every unrelated journal reader on the host, such as cursor reads for all watchers. The affected instances skip this tick and retry on the next timer firing (the timer runs every 90 seconds).

**Tests,** in `scripts/jobs/test/cursor-outage-cooldown-test.sh`:
- (a7) the lock-busy message exits 75 and does not start the cooldown.
- (a8) the same message alongside a "not a git repository" error still fails loudly with exit 1.

**Possible follow-up (not done here):** the root cause is that all instances share one clone. Giving each repo's ci-watcher its own `GARDEN_CI_VERIFY_CLONE` path would stop the contention entirely, at the cost of one extra clone per watched repo.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-kriscendobot-oros-ckm-data-readiness-clone-lock-busy-not-latched.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (510729 cached reads)
- Output: 5300 tokens
- Cost: $0.6252018
- Wall-clock: 60s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->

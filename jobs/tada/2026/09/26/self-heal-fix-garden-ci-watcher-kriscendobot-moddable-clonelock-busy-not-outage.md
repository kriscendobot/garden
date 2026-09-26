**Report: self-heal-fix-garden-ci-watcher-kriscendobot-moddable-clonelock-busy-not-outage**

The watcher no longer crash-loops when a sibling holds the clone lock. The two outage tests pass (61/61 and 14/14), and the fix is pushed to `main2` as commit `5b48813cd0b`.

**What changed**
- **`scripts/jobs/common.sh`:** `journal_bounded_fetch_is_ambiguous_outage` now also matches the message `clone_lock` gives when it gives up on a busy holder: `cannot acquire clone lock .* after [0-9]+ waits`. When a sibling watcher sharing the same VERIFY clone holds the lock past the 180s budget, `ensure_clone_or_latch_outage` now treats it as a temporary outage. It starts the shared cooldown and exits quietly with `GARDEN_OFFLINE_RC` (75) instead of dying loud. I also updated the comment above the function.
- **The same rule now covers `sync_clone` too.** Its retry-exhaustion branch calls the same function, so it inherits the new classification.
- **No overlap with the "definite failure" check:** its lock patterns are git's own lock messages (`unable to create .*\.lock`, `cannot lock ref`), which the new wording doesn't match. A new test asserts this.
- **`scripts/jobs/test/cursor-outage-cooldown-test.sh`:** new case (a5b) uses a fake busy-lock message. It checks that `ensure_clone_or_latch_outage` exits 75 and starts the cooldown, and that the classifier treats the message as an outage only at rc=1 and never as a definite failure.

**Tests:** `cursor-outage-cooldown-test.sh` passes 61/61 with the 2 new cases, and `triager-pacing-test.sh` passes 14/14.

**Follow-ups**
- Hosts pick up the fix at their next deliberate deploy.
- A busy clone lock now starts the whole host's journal-outage cooldown, so other cursor reads and writes also skip for that window, as the job specified. If that proves too broad, a later change could skip quietly on a busy lock without starting the cooldown.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-kriscendobot-moddable-clonelock-busy-not-outage.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (409775 cached reads)
- Output: 3796 tokens
- Cost: $0.569011
- Wall-clock: 58s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->

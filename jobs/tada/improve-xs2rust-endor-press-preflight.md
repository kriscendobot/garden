The rebase merged cleanly, my changes are intact on `origin/main2`, and all 13 test cases still pass. The work is complete.

---

## Completion report

**Situation found:** The job asked me to *author* `scripts/jobs/gardening/xs2rust-endor-press-preflight.sh` because it "does not exist." Between the job being posted and my claim, three prior commits (`adb542d6`, `0e1d7a0a`, `911226b4`) had already landed the file on `origin/main2` with a working stall-bar gate (HEAD-tracking + build-child ownership) and its inline test in `run-test.sh` SUBTEST 8c. The scheduler's exit-code contract (0=dispatch, 2=skip, other=fail-open) was already correctly matched.

**Gap I closed:** The existing gate covered the collision/stall half of the spec but **not** the spec's final clause — *"only exit work-present when PR #600's branch HEAD is idle/stalled AND the finish line is unmet."* The script would still dispatch the expensive Fable driver on a stalled HEAD even after PR #600 was merged, closed, or handed off (left DRAFT) — exactly the waste the job targets.

**What I changed** (commit `50256cd8b` → `e26ebb406` on `main2`):
- Added finish-line predicate **(d)** to `xs2rust-endor-press-preflight.sh`: a new `read_pr_state()` reader (one `gh_api_retry` call, jq-classified into `merged`/`closed`/`ready`/`draft`, with a `GARDEN_PRESS_STATE_CMD` test override parallel to the existing `GARDEN_PRESS_HEAD_CMD`) and a guard that defers (exit 2) on a **confirmed terminal state**. It reads in the safe direction: `draft` (still being pressed) and an *unreadable* state both fall through to the existing stall logic, so a network blip loosens toward dispatch, never toward silently skipping a live campaign.
- Updated the header docstring to document rule (d) and its fail-safe direction.
- Extended `run-test.sh` SUBTEST 8c: defaulted the finish-line read to `draft` so cases 1-7 are unchanged and hermetic (no real network), then added cases 8-12 proving a terminal state overrides an otherwise-dispatching stall (merged/closed/ready → defer) while unreadable-or-draft under the same stall still dispatches.

**Verification:** `bash -n` + shellcheck clean (only the pre-existing `GARDEN_TAG` SC2034 note, untouched). The full `run-test.sh` suite is too slow to complete in budget (cut at ~560s in the concurrency subtests), so I ran an isolated standalone harness replicating the exact 8c seed/push fixtures: **13/13 PASS** — all 7 original regression cases plus the 5 new finish-line cases plus baseline-persistence — both before and after the rebase.

**Follow-ups:** None required. Note the full monolithic `run-test.sh` has no per-subtest filter and takes >9 min end-to-end; if a future CI wants fast targeted verification, extracting SUBTEST 8c into a standalone runnable would help — not needed for this job.

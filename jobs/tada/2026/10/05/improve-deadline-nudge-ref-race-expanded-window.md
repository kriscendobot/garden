**Completion report: improve-deadline-nudge-ref-race-expanded-window**

The fix is in: `deadline-nudge.sh` now treats Git's journal2 "cannot lock ref … is at X but expected Y" rejection as a lost race, not a server rejection. It is pushed to `main2` as commit `873736317e7`. Both test suites passed when run once each.

**What I did:**
- **`scripts/jobs/common.sh`:** I applied the patch from the job spec as written.
  - It adds `journal_push_is_ref_lock_race`, which matches only `cannot lock ref '...': is at <hex> but expected <hex>`.
  - `journal_push_is_cas_contention` now counts that rejection as a lost race.
  - `journal_push_is_server_rejection` and `journal_push_is_definite_failure` now return false for it.
  - Callers therefore re-sync and retry instead of raising a repair alert.
  - A `cannot lock ref` that is not a race (for example, "Permission denied") is still treated as a definite failure.
- **New `scripts/jobs/test/deadline-nudge-reflock-push-stub.sh` (executable):** a test stub. On the first push it lands a competing claim, then rejects the push with the ref-lock message.
- **`scripts/jobs/test/deadline-nudge-test.sh`:** three new checks:
  - an end-to-end check that the push is retried as a lost race, the batch is recomputed, both warnings are delivered, and no alert or alert fingerprint appears;
  - a check of how the shared push functions classify the race;
  - a check that a ref-lock failure that is not a race stays definite.

**Tests:**
- `deadline-nudge-test.sh`: 57 passed, 0 failed, including all three new checks.
- `cursor-outage-cooldown-test.sh`: 65 passed, 0 failed.

I committed only the three files above and pushed to `main2` with the repo-lock rebase-and-retry loop.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-ref-race-expanded-window.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (421824 cached reads)
- Output: 5989 tokens
- Cost: $0.6228408000000001
- Wall-clock: 714s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->

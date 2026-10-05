---
handed-off: improve-deadline-nudge-ref-race-split
deliverable-complete: false
---
This split was already done by the earlier attempt, so I didn't post anything new. The fix itself has also already landed on main2.

**The split, already in the journal:**
- The orchestration `improve-deadline-nudge-ref-race-split` (`jobs/orch/`, serial, halt on child failure, state `running`) is recorded as a single-child split.
- The stated reason it can't be divided: the deliverable is one atomic change (a classifier check plus its regression test). The earlier attempt hit the 2400s limit because the deadline-nudge test suite takes about 10 minutes on a loaded host and was run several times, not because the work is large.
- It sets the time limit for the child to 5400s (`split-indivisible-handler-timeout: 5400`).
- Its one child, `improve-deadline-nudge-ref-race-expanded-window`, has been promoted and is currently in `jobs/doin/`.

**The fix on main2:** commit `873736317e7` ("fix(deadline-nudge): treat a receive-side ref-lock CAS race as lost race") is on origin/main2.
- It adds `journal_push_is_ref_lock_race` to `scripts/jobs/common.sh` and counts it as compare-and-swap contention, so it is no longer classed as a server rejection or a definite failure.
- A `cannot lock ref` error that isn't a race, such as Permission denied, is still treated as a definite failure.
- It adds a regression test in `scripts/jobs/test/deadline-nudge-test.sh`, with a new stub `scripts/jobs/test/deadline-nudge-reflock-push-stub.sh`.

I checked that the new function is in `common.sh`. I did not rerun the test suite here. The child job's notes say the patch passed 57/0 on the deadline-nudge suite before it was handed over.

**Follow-up:** the child is still in `doin/`. Once it reports completion, the orchestrate watcher should close the split.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-ref-race.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (1 unmetered)
- Input: 18 tokens (631390 cached reads)
- Output: 4808 tokens
- Cost: $1.6843564 (1 engagement(s) unpriced)
- Wall-clock: 2470s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->

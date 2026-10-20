## Completion report: improve-mentor-outage-retry-backoff

During a transient provider outage, `mentor.sh` no longer calls the provider on every timer tick. It now waits on a saved, doubling retry deadline. The fix is pushed to `main2` as commit `8a2b6a63a84`.

**What changed**
- **`scripts/jobs/mentor.sh`**
  - **Saved deadline:** the outage state file now holds `<sha> <attempts> <next-retry-epoch>`.
  - **Delay schedule:** each transient attempt sets the deadline to now plus 1500s × 2^(N−1), capped at 4h. Both values can be set with `GARDEN_MENTOR_OUTAGE_RETRY_BASE_SECS` and `GARDEN_MENTOR_OUTAGE_RETRY_MAX_SECS`. The 1500s base is shorter than the 30-minute timer, so the first retry still happens on the next tick.
  - **Skipping early ticks:** a new step 3b (`outage_retry_deferred`) exits quietly before the handler runs if the deadline hasn't passed. The `seen`/`journalctl-since` markers are not advanced.
  - **Reset:** any real verdict (success, semantic rejection, or a genuine defect) already called `note_transient_recovery`, which deletes the state file, so it now clears the deadline too.
  - **Old state files:** a state file without a deadline is treated as eligible.
  - **Test clock:** added a `GARDEN_MENTOR_NOW` clock override for tests. Warnings now include "next handler retry in Ns".
- **`scripts/jobs/test/mentor-transient-backoff-test.sh`** now steps a fake clock through 10 ticks, 30 minutes apart. It checks that:
  - the provider is called 4 times, not 10;
  - neither marker advances;
  - the saved count and deadline are what the schedule predicts;
  - a healthy handler is not called before the deadline;
  - the retry happens once the deadline passes, followed by one recovery notice;
  - after a verdict, the next outage starts again at the 1500s base;
  - a genuine defect clears the deadline.
- **`scripts/jobs/test/run-test.sh`** (subtest 11): the transient tick now sets a deadline, so the next tick, which simulates a real defect, moves the clock past it.

**Verification**
- `mentor-transient-backoff-test`, `mentor-rejection-backstop-test` and `mentor-routine-result-filter-test` pass.
- shellcheck: no new warnings in `mentor.sh` (the one remaining note is on an older line). It flags `A && B || C` in my new test asserts as info only.
- `claude-session-limit-classifier-test` fails 5 checks, the same with and without my change. Those checks are in the gardener path, not the mentor.
- `run-test.sh` hit my 580s limit in subtest 5, so I could not run its subtest 11 here. That edit only moves the clock forward and is not yet confirmed by a run.

**Follow-ups:** the 5 failures in `claude-session-limit-classifier-test.sh` (the session-cap capture is not logged as transient, and the clobber fail-safe check) are worth their own job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mentor-outage-retry-backoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1183865 cached reads)
- Output: 13233 tokens
- Cost: $1.020201
- Wall-clock: 1537s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->

---
handed-off: improve-deadline-nudge-failure-trace-split
deliverable-complete: false
---
I treated this as an indivisible job and handed it off to one child job with a longer time limit. I didn't implement the original fix in this claim, as the split protocol requires.

**Why it's indivisible:** the fix is one connected mechanism in about 60 lines of `scripts/jobs/deadline-nudge.sh`.
- The tick subshell's error and exit traps, plus the stage code paths that check their own exit status in `deadline_nudge_tick`, need to write a single local fault record.
- The parent's final `WARN` then reads that record.

A child that only writes the record, or only reads it, can't be checked on its own, and both would edit the same lines. So the previous run overran because of the cost of reproducing and testing the failure, not because the work is broad.

**What I posted:**
- **Child job** `improve-deadline-nudge-failure-trace-expanded-window`, parked with `post-plan.sh --orchestrated --orchestrated-by improve-deadline-nudge-failure-trace-split`. It has:
  - `handler-timeout: 4800` (was 2400; the ceiling is 14339).
  - The concrete `split-indivisible-reason`.
  - The full original spec, plus notes for whoever picks it up:
    - The subshell already builds a trail of failed commands but only logs it inside the subshell, so the parent's `WARN` can't see it.
    - Record the current stage name (clone, journal-sync, staging or push) as each stage starts, so a failure that never triggers a trap still names its stage.
    - Add a self-contained test that forces a stage failure and checks that the `WARN` shows the stage and the command.
- **Orchestration** `improve-deadline-nudge-failure-trace-split`, recorded with `post-orchestration.sh --serial --on-child-failure halt`. Its description has the same `split-indivisible-reason` and `split-indivisible-handler-timeout: 4800`.

**Check:** I ran `assert-overrun-split-posted.sh` against the live journal with a test report containing the handoff marker. It exited 0, so the completion check accepts this one-child split.

**Next step:** once the orchestration runs, the child job does the actual fix.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-failure-trace.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 22 tokens (599480 cached reads)
- Output: 4922 tokens
- Cost: $0.6432719999999998 (1 engagement(s) unpriced)
- Wall-clock: 2485s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->

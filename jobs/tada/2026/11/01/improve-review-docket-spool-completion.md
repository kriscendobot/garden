A finished fixer is no longer left stuck in `doin` when its review-docket re-entry gets spooled. The fix is pushed to `main2` as d45a2d77f58, and the new regression test passes.

**What changed**
- **`scripts/jobs/gardener.sh`** (the fixer re-entry block): return code 76 from `review-docket.sh reenter` is now treated as a deferral, like 2 and 3. That code means the docket couldn't commit right away but saved the re-entry to its host-local queue (the spool) to retry later. The gardener now logs `fixer review-docket re-entry for '<base>' (<pr>) spooled (rc=76); a later docket transaction drains it; completing the job` and moves the job to `tada`. Any other nonzero code still fails the completion and leaves the job retryable. I updated the comment there to explain this.
- **New test, `scripts/jobs/test/fixer-docket-spooled-completion-test.sh`:** runs a fixer job named against PR #209 through the real `gardener.sh` against a throwaway journal, with a stub docket that returns a fixed code. It checks two cases:
  - **Returns 76:** the re-entry call is sent as expected, the job ends in `tada` (not `doin`), the spooled message is logged, and nothing is logged as a failure.
  - **Returns 1:** the job does not complete and the failure is logged, so ordinary failures are still retried.

**Verification**
- Without the fix, the new test fails with "spooled (rc=76) re-entry did not complete the fixer into tada". With it, the test passes.
- `fixer-reentry-pr-test.sh` and `draft-guardrail-terminalization-test.sh` still pass, and `bash -n` and `shellcheck` report nothing.

**Follow-ups:** The fix only takes effect on each host once the rolling deploy brings it there. Until then, a fixer completing on a host that hasn't updated can still get stuck the same way.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-review-docket-spool-completion.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (694664 cached reads)
- Output: 6187 tokens
- Cost: $0.7315848
- Wall-clock: 97s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->

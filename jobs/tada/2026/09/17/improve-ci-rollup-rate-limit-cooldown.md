Implemented and pushed commit `ffa0cafe046` to `main2`.

- CI rollup primary-quota exhaustion now opens the host-wide API cooldown and immediately stops both normal and stale-shepherd sweeps.
- Added regression coverage for both paths.
- Verification: `ci-watcher-test.sh` completed with 74 passed, 0 failed; `git diff --check` and Bash syntax checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-rollup-rate-limit-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 156s

<!-- garden-usage-end -->

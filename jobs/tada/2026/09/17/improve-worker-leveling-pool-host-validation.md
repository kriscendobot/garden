Implemented and pushed commit `23c106eb5b` to `main2`.

- `set-worker-leveling.sh` now rejects replacements missing a valid positive monk cap for any calibrated Anthropic weekly-token pool host.
- Validation runs against freshly synchronized pool configuration before every commit attempt.
- Added hermetic regression coverage for valid, missing, invalid, and excluded pool cases.
- Passed 58 targeted tests across the new test, physical-cap coupling, proportional leveling, and live budget admission suites. Shellcheck reported informational findings only.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-worker-leveling-pool-host-validation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 187s

<!-- garden-usage-end -->

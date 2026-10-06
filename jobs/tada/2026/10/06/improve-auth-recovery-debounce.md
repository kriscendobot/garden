Implemented and pushed `ae5e4270365` to `main2`.

- Claude auth recovery now requires two consecutive successful probes with an unchanged credential fingerprint.
- Failed confirmations and credentials mutated during probing retain the auth-failure marker and reset only the recovery candidate.
- Expanded regression coverage; `worker-health-gate-test.sh` passed all 74 checks.
- Full `run-test.sh` exposed three unrelated failures in scaler logging and bulletin rendering.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-auth-recovery-debounce.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 608s

<!-- garden-usage-end -->

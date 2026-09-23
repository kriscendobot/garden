Retired the sysop issuer gate and pushed:

- `main2` commit `231ef05767`: removed issuer checks/config seam, added arbitrary-host acceptance coverage, and updated all affected docs.
- `journal2` commit `ba20561522`: removed `config/sysop-issuers`.
- Maintainer attestation for all four destructive ops remains unchanged.
- Verification: `sysop-test.sh` passed 56/56; `bash -n` and ShellCheck passed for `sysop.sh`. The integrated `run-test.sh` does not include sysop subtests.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-sysop-issuer-gate-retirement.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 539s

<!-- garden-usage-end -->

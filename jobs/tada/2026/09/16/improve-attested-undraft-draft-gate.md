Implemented and pushed commit `e57d236baa` to `main2`.

- Attested `undraft-*` jobs now consume cited PRs after validating the named maintainer against the journal allowlist.
- Missing, malformed, duplicate, or unauthorized attestations retain the normal ready-PR block.
- Added regression coverage for the live PR #99 shape and forged-attestation rejection.
- Verified with `assert-producer-pr-draft-test.sh`, ShellCheck, Bash syntax checks, and `git diff --check`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-attested-undraft-draft-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 253s

<!-- garden-usage-end -->

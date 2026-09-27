- Reproduced finding `29a24c1b1052ec91` at the pinned SHA and confirmed the 64-bit regexp meter was truncated to 32 bits by the XS oracle.
- Added the exact fixture plus load-bearing VM and differential regressions in commit `66cbfc4c32`; mutation testing confirmed the regression fails under truncation.
- Verified the existing causal fix `c8497fd88b`, and the reproducer now completes without divergence.
- Amended [standing PR #1298](https://github.com/endojs/endo-but-for-bots/pull/1298) and documented the finding. CI passed: 27 successful, 7 skipped, no failures.
- Follow-ups: none for this finding; the standing draft remains open for other findings.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-29a24c1b1052ec91-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 3 host(s) (5 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (5 engagement(s) unpriced)
- Wall-clock: 3663s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->

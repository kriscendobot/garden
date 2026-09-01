Implemented and landed commit `3411c580d3` on `main2`.

- `deploy-garden.sh` now probes candidate-gate roots for direct execution, rejects `/tmp` when `noexec`, falls back to `$GARDEN_SCRATCH/tmpexec`, fails loudly if none work, and cleans roots on all exit paths.
- Extended `deploy-garden-test.sh`; 118 passed, 0 failed. Mutating away the probe made the suite fail, as recorded in its header.
- Real deploy with `TMPDIR` unset reported `/tmp` as possible `noexec`, selected executable scratch, and passed all four candidate suites for `3411c580d3`. It then safely deferred because cleric 2 exceeded the long-job threshold; the deployed tree was not advanced.
- The 2026-08-20 watchdog hypothesis does not hold: both hosts had this exact noexec failure on July 29, but commit `532584e036` worked around that suite and was already in both the deployed `745fa90891` and candidate `231ef05767`; no August 20 gate rejection is recorded. Both hosts nevertheless need this systemic fix.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-deploy-gate-noexec-tmpdir.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 421s

<!-- garden-usage-end -->

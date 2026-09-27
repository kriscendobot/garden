Finding `67ca18e4febe7a34` repaired and regression-locked.

- Reproduced the original numeric-rendering divergence at SHA `38ca1d189` after verifying the 3-byte artifact hash.
- Confirmed a false-positive comparison: XS and Ironhorse emitted different decimal spellings for the same IEEE-754 value. The standing branch’s causal fix `fdb9fef6e0` correctly compares exact numeric values.
- Added the exact binary fixture, a submodule-free `ironhorse-vm` regression, and an oracle-linked differential regression.
- Proved the comparator test load-bearing by temporarily disabling the numeric comparison and observing the recorded failure.
- Pushed commit `6bdad480522b6849c909137d4b57eb9edc107e64` through fetch/rebase/CAS to `ironhorse-fuzz-findings`; it remains an ancestor of the advancing remote branch.
- Adopted standing draft PR endojs/endo-but-for-bots#1298 and documented the finding in comment `5855017364`.
- Verification passed: full `ironhorse-vm` suite, all 78 `ironhorse-fuzz` library tests, pinned fuzz replay, formatting, and all 11 pre-push stages. Successor-head CI is pending with no failures; concurrent branch pushes canceled earlier runs.
- Follow-up: the PR remains draft for the maintainer-triggered gauntlet under the current manual-gauntlet policy.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-67ca18e4febe7a34-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (6 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (6 engagement(s) unpriced)
- Wall-clock: 2913s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->

Reproduced finding `67a52af412f03a7b` and confirmed it is the already-fixed numeric dtoa comparison class.

Pushed commit `54089e53f3` to `ironhorse-fuzz-findings`, adding the exact binary fixture plus load-bearing `ironhorse-vm` and differential-harness regressions. Raw string comparison reproduces the failure; the standing branch’s IEEE-754 value comparison resolves it.

Adopted and documented standing PR #1088. The direct fuzz replay, Rust suites, pre-push probes, and all 24 CI checks pass. The existing staged gauntlet owns panel/undraft follow-up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-67a52af412f03a7b-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 5259s

<!-- garden-usage-end -->

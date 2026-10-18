Implemented and pushed commit `46215da0605` to `main2`.

- Gauntlet panel stages now run read-only deterministic probes against pinned base/head commits before dispatching jurors.
- Probe failures skip the panel and route exact captured output to the fixer.
- Malformed or empty probe evidence fails closed.
- Added regression coverage for pre-pass gating and fixer routing.
- Verified: 13 check suites (including 11 gauntlet viability checks), 98 gauntlet integration checks, 16 retry-budget checks, and pre-push-gate tests all passed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-deterministic-style-prepass.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 654s

<!-- garden-usage-end -->

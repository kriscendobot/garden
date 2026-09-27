- Reproduced finding `12aca768c2e73c73` at `38ca1d1893` with the pinned toolchain: XS truncated the regexp meter from `6,840,385,536` to `2,545,418,240`, creating a false divergence. The causal 64-bit oracle-shim fix was already present on the standing branch in `c8497fd88b`; the Rust port was correct.
- Added the exact verified 10-byte fixture, an oracle-free `ironhorse-vm` regression test, and a differential oracle regression test. Proved the VM test load-bearing by temporarily restoring 32-bit truncation and observing the expected failure.
- Pushed commit `97ff21c414` to `ironhorse-fuzz-findings`; it remains an ancestor of the current branch head.
- Verified formatting, all `ironhorse-vm`/`ironhorse-fuzz` tests, all eight pre-push gates, and the complete latest PR CI matrix, including IronHorse oracle sanitizers. All passed.
- Adopted and amended draft PR [#1298](https://github.com/endojs/endo-but-for-bots/pull/1298), documenting the finding and solution in [a top-level comment](https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5854178173).
- Follow-up: current builder policy forbids automatically staging the gauntlet. PR #1298 remains draft until the maintainer requests `run the gauntlet #1298`.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-12aca768c2e73c73-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 9 on 2 host(s) (7 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (7 engagement(s) unpriced)
- Wall-clock: 4156s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->

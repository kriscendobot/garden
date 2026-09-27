---
handed-off: endojs-endo-but-for-bots-pr1298-gauntlet
deliverable-complete: false
---
Reproduced finding `197b32cc30bdd4fe` at the recorded SHA and traced it to the XS oracle’s former 1024-byte result buffer; the causal fix already existed in `7fae4aea2f`.

Added exact-input, submodule-free VM and differential regressions in commit `7fe420a0b3c`, pushed to `ironhorse-fuzz-findings`, and documented the finding on standing PR #1298.

Verification passed: mutation proof, targeted regressions, full `ironhorse-vm`/`ironhorse-fuzz` suites, `ironhorse-snapshot`, formatting, exact fuzz replay, and all 8 pre-push probes. CI had zero failures with 13 checks pending at handoff.

Follow-up: staged gauntlet `endojs-endo-but-for-bots-pr1298-gauntlet` durably owns remaining CI, panel, fix-loop, and readiness work.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-197b32cc30bdd4fe-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s) (6 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (6 engagement(s) unpriced)
- Wall-clock: 2118s

<!-- garden-usage-end -->

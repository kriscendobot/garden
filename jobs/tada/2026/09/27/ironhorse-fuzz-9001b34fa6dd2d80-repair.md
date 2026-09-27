Completed finding `9001b34fa6dd2d80` and amended standing PR endojs/endo-but-for-bots#1298.

- Reproduced the exact 5-byte artifact at the recorded SHA/toolchain and verified its SHA-256.
- Diagnosed an oracle false positive: XS truncated the 1231-byte `RegExp.source` result to 1023 bytes; Ironhorse was correct.
- Confirmed the causal fix already exists as `7fae4aea2f`; added permanent fixtures plus submodule-free VM and oracle-linked differential regression tests in `32ed05cd89`.
- Verified both targeted tests, the repaired fuzz replay, formatting, mutation-based regression evidence, and all 11 pre-push gates. The full VM suite only hit the documented host-libm math mismatch unrelated to this change.
- Rebased and CAS-pushed the commit; newer standing-branch heads contain it. Documented the finding in the PR comment.
- Successor CI remained pending after repeated newer fuzz pushes canceled preceding runs. The active staged gauntlet `endojs-endo-but-for-bots-pr1298-gauntlet` covers the rolling PR.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-9001b34fa6dd2d80-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (4 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (4 engagement(s) unpriced)
- Wall-clock: 2042s

<!-- garden-usage-end -->

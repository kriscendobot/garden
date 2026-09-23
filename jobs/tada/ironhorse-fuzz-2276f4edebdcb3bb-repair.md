Reproduced finding `2276f4edebdcb3bb` at project SHA `38ca1d1893` after verifying the artifact SHA-256. Root cause was oracle-side completion truncation, already causally fixed by `7fae4aea2f`; no engine change was warranted.

Pushed commit `c2466f49c2` to `ironhorse-fuzz-findings`, adding exact-input differential coverage and a submodule-free `ironhorse-vm` regression with frozen bytecode, symbols, and full 1312-byte result.

Load-bearing proof: restoring the old 1024-byte limit and disabling overflow handling made the new regression fail; restoring the fix made it pass. The pinned fuzz replay, Rust-scoped gauntlet, and all 24 PR checks passed.

Adopted standing PR #1088 and documented the finding at https://github.com/endojs/endo-but-for-bots/pull/1088#issuecomment-5468278375. Existing staged gauntlet jobs own panel review and undrafting.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-2276f4edebdcb3bb-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1658s

<!-- garden-usage-end -->

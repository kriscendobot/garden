---
handed-off: endojs-endo-but-for-bots-pr1298-gauntlet
deliverable-complete: false
---
Reproduced finding `3fc02d8b57faa79a` at the pinned SHA and diagnosed an XS non-shortest decimal-spelling artifact; IronHorse computes the correct IEEE-754 value.

Added the exact hashed fixture and a submodule-free, mutation-proven regression test. Pushed commits `b71ccebb7b` and `589ec4fc33` to `ironhorse-fuzz-findings`, including the corrected standalone fuzz lockfile. The reproducer now completes successfully; focused tests, Clippy, Rustfmt, lock freshness, and source probes pass. A broader host run encountered an unrelated pre-existing `acosh(MAX)` platform fixture mismatch.

Amended endojs/endo-but-for-bots#1298 and documented the finding in PR comment `5863978824`. CI is pending without failures on a successor head containing the commits.

The previously halted required gauntlet was durably resumed at panel round 2; active successor `endojs-endo-but-for-bots-pr1298-gauntlet` owns the remaining review, CI, and disposition work.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-3fc02d8b57faa79a-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 3 host(s) (5 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (5 engagement(s) unpriced)
- Wall-clock: 2396s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->

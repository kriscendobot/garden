Applied and pushed panel-2 fixes to PR #980 at `3353924c9c`:

- Hardened `decodeAscii` against proxies, detached views, invalid ranges, and quadratic decoding.
- Preserved arbitrary-byte sturdyrefs and Unicode handoff locations.
- Added protocol golden vectors and load-bearing regression tests.
- Corrected changesets, release metadata, documentation, and migration guidance.
- Posted the required SHA-mapped PR summary.

Verification: local harness passed; targeted tests and lint passed; CI completed green with 26 checks.

Self-improvement: nothing this time.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-ascii-adopt-ocapn-sites-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1483s

<!-- garden-usage-end -->

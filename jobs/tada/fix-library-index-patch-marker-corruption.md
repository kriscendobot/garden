Implemented and pushed commit `48a22ee7dd` to `main2`.

- Added a producer-side guard in `land-journal-edit.sh` rejecting literal `@@ … @@` diff hunk headers in the four shared library indexes.
- Preserved legitimate Markdown `+`/`-` prefixes to avoid false positives.
- Added regression coverage for all four clean indexes and malformed patch rejection.
- Verification: focused suite passed 32/32; remote `main2` matches the commit.
- Full suite: 376 passed, 1 unrelated pre-existing issue-inbox stderr assertion failed.
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-library-index-patch-marker-corruption.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 259s

<!-- garden-usage-end -->

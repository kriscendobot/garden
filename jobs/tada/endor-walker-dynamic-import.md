Implemented and pushed commit `4e3002738a` to PR #282’s `feat/endor-run-entry-point-deps` branch.

- Added static detection and graph-following for literal dynamic `import()` and analyzable `require.resolve()`/`require()` bindings.
- Graduated `dynamic`, `dynamic-ancestor`, `dynamic-import-esm`, and `optional`; added Node-reference goldens and raised the parity floor to 23.
- Added scanner and ingestion regression tests, including break-target evidence.
- Verified 54 entry-walker tests, all 5 parity tests, golden drift checks, binary compilation, formatting, and diff hygiene.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endor-walker-dynamic-import.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1278s

<!-- garden-usage-end -->

Applied and pushed panel round-1 fixes in commit `91577009a`:

- Added schema-validated batch promotion/resume and a post-sweep completeness gate.
- Capped batches at 100 cases and rejected invalid `--jobs` values.
- Corrected documentation, HTML scope/oracle claims, classification, and naming.
- Added hostile-string JSON round-trip and provenance-wire tests.
- Verified 53 Rust unit tests plus integration tests, ShellCheck, Clippy, and an end-to-end scoped sweep.
- CI reached terminal green: 25 checks passed, 0 failed.

No follow-ups required.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-full-test262-automation-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1382s

<!-- garden-usage-end -->

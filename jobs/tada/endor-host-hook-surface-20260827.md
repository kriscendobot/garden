Implemented and pushed commit `29ef53bce33c71f50f787ee79612c8c31b7136d2` to `feat/endor-run-entry-point-deps`.

Changes:
- Added typed `exitModuleImportHook` and observational `moduleSourceHook` equivalents to `WalkOptions`.
- Materialized deterministic synthetic ESM sources into CAS archives for real XS execution.
- Added an options-aware `endor run` ingestion seam while preserving default fast-path behavior.
- Added real-execution tests and contextual error-boundary tests for both hook classes.

Verification:
- Entry-walk tests: 58 passed.
- Full Endor no-default-features suite: 314 library, 3 binary, 5 integration, and 1 parity test passed.
- Cargo check, clippy, Rust formatting, local verification, and all 5 pre-push probes passed.
- Regression probes confirmed all four new tests fail when their respective hook dispatch is removed, then pass after restoration.
- Remote branch matches the local commit; GitHub reported no checks for the branch.

Posted the required PR completion summary:
https://github.com/endojs/endo-but-for-bots/pull/282#issuecomment-5437607701

Follow-up: Increment 7 can now graduate `fixtures-exit` and `fixtures-module-source-hook` and raise the parity floor from 30 to 32. Queued the library-concept gap for scholar review after that validation.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endor-host-hook-surface-20260827.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2230s

<!-- garden-usage-end -->

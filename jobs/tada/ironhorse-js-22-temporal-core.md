---
orchestration-failed: true
---
Implemented and pushed Temporal core records, `Instant`, and `Duration` to shared draft PR https://github.com/endojs/endo-but-for-bots/pull/970 at `2281c79b072f285c21ed76e9d587d05ccc3ed3cb`.

Changes:
- Added immutable branded records, exact nanosecond arithmetic, parsing, formatting, comparison, rounding, balancing, options, getters, and range/brand enforcement.
- Removed the coarse `feature:Temporal` pre-skip.
- Added precise `oracle-host-missing-temporal` handling because pinned XS lacks Temporal, plus focused regression tests and snapshot ledger coverage.
- Pins unchanged: test262 `be13516fb6441b950ba8a3df97eb34062c186972`; XS `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`.

Official slice before: all 1,005 cases pre-skipped as `feature:Temporal`.
After:
- Instant: 465 total; 322 host-only skipped, 143 unsupported, 0 failures/infrastructure.
- Duration: 540 total; 292 host-only skipped, 248 unsupported, 0 failures/infrastructure.
- 614 cases now execute Ironhorse successfully; 391 remain blocked on shared prerequisites or calendar/`relativeTo` work.

Validation:
- Temporal regressions: 3 passed.
- `cargo test --workspace --release`: all suites passed; one benchmark ignored.
- Exact metering corpus: 1,712/1,712 covered, zero failures/skips; computron expectations unchanged.
- PR remains open and draft. Completion comment: https://github.com/endojs/endo-but-for-bots/pull/970#issuecomment-5297447161

Follow-up: later Temporal/shared-engine children must resolve the remaining 391 unsupported cases and provide an oracle with Temporal support.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-22-temporal-core.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1027s

<!-- garden-usage-end -->

---
orchestration-failed: true
---
Implemented and pushed numeric/JSON support to the shared draft PR:

- Added integral radix conversion and catchable receiver/range errors for `Number.prototype.toString`.
- Added generic coercion for `parseInt`, `parseFloat`, `isNaN`, `isFinite`, and `JSON.parse`.
- Added catchable JSON syntax and cyclic-value errors.
- Added four XS-backed Rust regression tests.

Official built-ins improved from 365/1,642 to 467/1,642 covered (+102), with zero failures, infrastructure results, or covered regressions. Retired skip reasons include `Number.toString:non-decimal-radix`, `Number.toString:non-number-receiver`, `Number.toString:radix-range`, `JSON.parse:non-string`, `JSON.parse:syntax`, `parseInt:non-string-argument`, `parseFloat:non-string-argument`, and `isNaN/isFinite:uncoercible`.

Validation:

- Official numeric language slice: 484/578 covered; 0 failures/infrastructure.
- `cargo test --workspace --release`: passed.
- Exact-metering corpus: 1,711/1,711 passed unchanged.
- Focused regressions: 4/4 passed.

Pins unchanged: test262 `be13516fb6441b950ba8a3df97eb34062c186972`; XS `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`.

Head: `f09bd12e96a93f565f4bf78e1226338912369a9b`
PR: https://github.com/endojs/endo-but-for-bots/pull/970 (open, draft)

Follow-up: the overall acceptance gate remains incomplete, notably Date at 0/594 and BigInt built-ins at 1/77, plus remaining Math, JSON, and operator gaps.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-13-numeric-date-json.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 812s

<!-- garden-usage-end -->

Implemented Error objects, shared coercions, and strict semantics, plus parser fixes for 88 newly exposed early-error failures.

Changes:
- Added realm-correct Error/NativeError/AggregateError prototypes, messages, causes, descriptors, generic `Error.prototype.toString`, and catchable native TypeErrors.
- Implemented ToPrimitive/numeric/string/property-key conversions and strict assignment/delete/`this`.
- Enabled strict test262 variants while preserving proprietary byte/meter identity.
- Added focused Rust/XS regression tests.
- Fixed duplicate `__proto__`, bare-arrow class heritage, and invalid inline RegExp modifier early errors.

Verification:
- Official focused slice: 325 total, 104 covered, 0 failed, 221 named skips; baseline was 61 covered. No covered regressions.
- Full `language/**`: 23,724 total, 7,096 covered, 0 failed, 16,628 named skips; +4,377 covered and all 19 baseline failures removed.
- Exact metering corpus: 1,712/1,712 covered, 0 failed/skipped; expectations unchanged.
- Debug and release workspace gates: 508 passed, 0 failed each.
- GitHub CI: 24 checks successful; one completed-success lint job remains stale as “in progress.”
- Pins unchanged.

Remaining focused skips are explicit unsupported prerequisites, chiefly arguments handling, deeper Error stack/cross-realm behavior, and Reflect.construct reentry.

Pushed head `75e9b5e02d519ac256b870d2bbb01a0f6523f2e8` to the open draft PR:
https://github.com/endojs/endo-but-for-bots/pull/970
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-02-errors-coercions-strict.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 5727s

<!-- garden-usage-end -->

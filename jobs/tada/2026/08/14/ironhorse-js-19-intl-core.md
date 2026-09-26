---
orchestration-failed: true
---
Implemented and pushed deterministic Intl core support:

- Added canonicalization, option extraction, `supportedLocalesOf`, `supportedValuesOf`, `Intl.Locale` fields/maximize/minimize, and `Intl.Collator` options/resolvedOptions/compare.
- Pinned NFC data via `icu_normalizer = 2.2.0`; embedded profile version `ironhorse-intl-2026a`.
- Added focused Intl and oracle-host regression tests.
- Preserved all existing exact-metering cases unchanged.

Verification:

- `cargo test --workspace --release`: passed.
- Exact corpus: 1711 covered, 0 failed, 0 skipped.
- Official pinned slice before: 299 unsupported.
- After: Intl 58 unsupported/8 host-skipped; Locale 119/49; Collator 47/18. Zero Ironhorse failures or infrastructure results.
- Pins unchanged: test262 `be13516fb6441b950ba8a3df97eb34062c186972`; XS `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`.

The acceptance coverage gate remains unmet because the pinned XS oracle has no `Intl` global; 75 executing cases are precisely classified `oracle-host-missing-intl`, while 224 encounter earlier shared engine gaps.

Head: `2ac4cf8c7c0550c6d4f7e95c2733e27e6c7d0940`
PR: https://github.com/endojs/endo-but-for-bots/pull/970 (open, draft)
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-19-intl-core.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1413s

<!-- garden-usage-end -->

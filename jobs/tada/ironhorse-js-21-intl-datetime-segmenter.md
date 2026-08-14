---
orchestration-failed: true
---
All gates pass, the implementation is pushed to the shared draft PR, and the PR remains open and draft. Let me clean up the temp build dir reference (leave the worktree; harness tears it down) and write the report.

The core deliverable is genuinely finished and pushed, but the complete-slice-conversion gate is not fully met (128 cases remain unsupported, mostly from pre-existing shared VM limitations), so — following the child-11 precedent — I report this honestly as an orchestration-failed outcome.

---

## Completion report

**Job:** `ironhorse-js-21-intl-datetime-segmenter` — implement `Intl.DateTimeFormat` and `Intl.Segmenter` in the Ironhorse engine, on the shared completion PR.

**What I did**
- Implemented **`Intl.Segmenter`** in `ironhorse-vm`: grapheme/word/sentence segmentation over the pinned `icu_segmenter` (2.2.0) Unicode data, the `%Segments%`/`%SegmentIterator%` objects, `segment`, `containing`, `resolvedOptions`, and the `isWordLike` word tag. Indices/segments are UTF-16 code units (surrogate pairs and lone surrogates preserved).
- Implemented **`Intl.DateTimeFormat`**: full ECMA-402 option resolution/validation (components, `dateStyle`/`timeStyle`, hour cycle, `calendar`/`numberingSystem`, time zone), proleptic-Gregorian `format`/`formatToParts`/`formatRange`/`formatRangeToParts`/`resolvedOptions`. Time zones: UTC, numeric `±HH:MM` offsets, `Etc/GMT±N`, and a small IANA table at standard offset. Formatting is internally consistent (`format` == concatenated parts).
- Fixed `Object.prototype.toString` to honor a `Symbol.toStringTag` string on the receiver's chain (unmetered walk; only the frozen Intl objects carry one, so covered/metered cases are untouched). This is spec-correct and also improves the official `Object/prototype/toString` slice (10 covered, 0 failed).
- Added 16 oracle-backed Rust regressions in `rust/engine/ironhorse-262/tests/intl_datetime_segmenter.rs` (all pass).

**Totals before → after** (official pinned slice `intl402/{DateTimeFormat,Segmenter}`, 323 files; `ironhorse-xst --test262-dir <test262@be13516fb>`):
- `oracle-host-missing-intl` (host-only exclusion): **7 → 109**
- `abort-value-differs` (unsupported): **211 → 128**
- `feature:Temporal` (proposal exclusion): 65 (unchanged)
- **ironhorse-failure: 0; infrastructure: 0** — regression invariant held.
- `covered` stays 0 by construction: the pinned XS oracle has no ECMA-402 host, so the slice's ceiling is the *justified host-only exclusion* (`oracle-host-missing-intl`); 109 convertible cases now reach it.

Residual 128 `abort-value-differs` are mostly pre-existing shared limitations: native-function `name`/`length` `getOwnPropertyDescriptor` (a whole-VM gap — `Intl.ListFormat`/`PluralRules` from children 19/20 behave identically), `format`-as-getter/bound-function, exact CLDR output for non-`en` locales / flexible day periods, full IANA tzdb + DST, and `subclassing`/`proto-from-ctor-realm`.

**Gates run (all green)**
- `cargo test -p ironhorse-vm -p ironhorse-snapshot --release` (the exact CI gate): pass.
- Oracle-backed suites (`corpus_conversion_equivalence`, `regressions_dual_run`, `intl_core`, `intl_formatters`, `string_algorithms`, `numeric_json`, `intl_datetime_segmenter`): pass.
- Exact-metering cases corpus (`ironhorse-262/cases/**`, 1712 cases): **1712/1712 covered, 0 failed** under the standard gate — unchanged. (The `--gate-meter-exact` strict-advisory mode reports 51 pre-existing off-by-one computron advisories in arrays/bigint cases, unrelated to and unaffected by this change.)
- No new compiler warnings.

**Pins:** unchanged — test262 `be13516fb6441b950ba8a3df97eb34062c186972`, XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. (Copied the pinned `c/moddable` submodule tree from a sibling worktree locally to build the oracle; not committed.)

**Head SHA:** `7e28440de7f41dbb8e9a59b736a883215b5c400d`
**PR:** https://github.com/endojs/endo-but-for-bots/pull/970 — kept **open** and **draft** (not merged).

**Follow-ups** (for later children / residual-gap closure): native-function `name`/`length` descriptor reflection (converts the many `name.js`/`length.js`/`prop-desc.js` across all Intl families at once); `format` as a cached bound-function getter; full CLDR patterns for non-`en` locales and flexible day periods; full IANA/tzdb time-zone table with DST.

The complete-slice-conversion gate is not fully met (128 cases remain unsupported), so per the child-11 precedent I mark this orchestration-failed while the implementation itself is genuinely finished, tested, and pushed.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-21-intl-datetime-segmenter.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 389 tokens (36550773 cached reads)
- Output: 159421 tokens
- Cost: $25.2254175
- Wall-clock: 2250s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->

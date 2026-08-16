---
gate: orchestrated
orchestrated_by: ironhorse-intl-value-parity-orch
priority: normal
role: builder
posted_by: producer
posted_at: 2026-08-15T01:24:45Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Complete Intl.Collator + Array.sort data-dependent-comparison metering — close intl402/Collator slice

**Family slice:** `intl402/Collator` (~38 residual cases).

**Measured diagnosis:** Collator is PARTIAL — `new Intl.Collator('en').compare('a','b')` → `-1` completes. But `['b','a','c'].sort(new Intl.Collator('en').compare).join('')` → `Unsupported("Array.prototype.sort:data-dependent-comparison-metering")`. This **`Array.prototype.sort` data-dependent-comparison metering blocker is cross-cutting** (it also gates non-Intl sort cases and relates to the general-engine metering backlog — see the with-subtree meter-blocker notes); closing it unblocks Collator sort cases and beyond.

**Deliverable:**
- Resolve the `Array.prototype.sort:data-dependent-comparison-metering` unsupported stop so a user comparator (including a bound Collator `compare`) meters deterministically and completes. Coordinate with any live general-metering work to avoid a divergent exact-computron expectation.
- Close residual Collator option processing (`usage`, `sensitivity`, `caseFirst`, `numeric`, `ignorePunctuation`, `collation`, extension keywords), `compare` bound-getter semantics, and `resolvedOptions`. Drive every case to `IronhorseOnlyComplete` with correct values.
- Lock exact values with Rust regression tests; verify the exact-metering corpus stays byte-identical.

**Parent orchestration:** `ironhorse-intl-value-parity-orch` (nested under the js-26 residual-closure arc, issue kriskowal/garden#51). This child owns ONE Intl formatter family. It was carved by the diagnostic handler of `ironhorse-js-26-cg-intl-value-parity`, which measured the cluster and found it requires real ECMA-402 engine implementation across several constructors — too large for one handler.

**Root cause (measured, engine head `cf9247cd0` off the shared branch; oracle 23b4d6b0a6):** the pinned Moddable XS oracle has **NO ECMA-402 host** — `Intl` is an undefined global in XS, so for any Intl-host case the oracle throws `ReferenceError: get Intl: undefined variable`. Therefore the accepted terminal for an Intl-host-dependent case is **`oracle-host-missing-intl`**, reached ONLY when Ironhorse runs the case to **COMPLETION** (`Agreement::IronhorseOnlyComplete`) with the correct value while the oracle reports the missing binding. This is exactly the host-only-exclusion pattern child-20 established for ListFormat/PluralRules — see `rust/engine/ironhorse-262/tests/intl_formatters.rs` and `tests/intl_core.rs`. The current `abort-value-differs` reasons are Ironhorse **throwing** (mostly `TypeError`, because the constructor is unimplemented or an option path is wrong) where it must instead complete.

**Acceptance bar (non-negotiable):** convert this family's cases to the accepted terminal via **real execution** — either genuine `covered` (`BothComplete`, values agree, for cases where XS itself completes, e.g. the default `Number/Array.prototype.toLocaleString` bridge) or the standards-grounded host-only exclusion `oracle-host-missing-intl` (ECMA-402 is a separate spec the pinned XS build was compiled without). Do **NOT** weaken the classifier, relabel, suppress, skip-list, or add expectation files. Lock every value with focused **Rust regression tests** under `rust/engine/ironhorse-262/tests/` asserting the EXACT Ironhorse output (mirror the `intl_result` / `ironhorse_only_result` helpers in `tests/intl_formatters.rs`). Zero generic `ironhorse-aborted`, `parse-or-decode`, `unsupported-opcode:*`, `abort-value-differs`, or `non-primitive-completion` reasons may remain within this family's slice.

**Regression invariant:** no case covered in `rust/engine/ironhorse-262/baseline/baseline.json` may regress; no new `ironhorse-failure`/`infrastructure` result; every exact-metering/byte-identity case under `rust/engine/ironhorse-262/cases/**` stays passing (`ironhorse-xst --gate-meter-exact` corpus + `cargo test --workspace --release`). Run the affected official slice, the full Ironhorse Rust workspace gates, and the exact-metering corpus before every push.

**Pins (unchanged; record any change):** engine measured on head `b3c3ae93b81c0f266458cd25f2f27d94ef80cc5b` (this child stacks on the current shared-branch head, fetch first); test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1 c/moddable`). Rust toolchain: prepend `$HOME/.cargo/bin` to PATH; set `TMPDIR` off any noexec mount.

**Shared branch/PR (do not create a new one):** work on `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970 — OPEN, draft, keep it open, do NOT merge). Fetch the remote branch first, preserve every prior commit, stack your bounded commits on its head, and push with a rebase CAS loop. This orchestration is **serial** to avoid working-tree/CAS collisions, but always fetch+rebase before push.

**Implementation location:** `rust/engine/ironhorse-vm/src/interp.rs`. The Intl constructors are wired in `fn create_intl` (~line 5204): today it registers only `Locale`, `Collator`, `ListFormat`, `PluralRules`, `Segmenter`, `DateTimeFormat`. `NumberFormat`, `DisplayNames`, `DurationFormat`, `RelativeTimeFormat` are NOT registered (`typeof Intl.X === 'undefined'`). Mirror the established `Native::*` / `NativeMethod::*` enum + dispatch shape (search `Native::ListFormat`, `NativeMethod::Collator`). Reusable option helpers already exist: `intl_resolve_locale`, `intl_get_option_enum`, `intl_get_number_option`, `intl_get_options_object`, `intl_string`.

**Repro/verify:** build with `cargo build --release -p ironhorse-262 --bin ironhorse-xst --bin ironhorse-262-report`. Measure a slice with `rust/engine/ironhorse-262/scripts/full-run.sh --subtree <PREFIX> --output <dir> --jobs 4` (vendors the pinned test262; requires a clean engine tree — commit before running). For fast single-case triage, `ironhorse_262::dual_run(src)` returns `.agreement` / `.ironhorse_result` / `.ironhorse_error` / `.ironhorse_halt` / `.oracle_error` (write a throwaway `tests/` file, `cargo test --test <name> -- --nocapture`, delete before commit).

**If this family is itself too large for your handler budget:** do NOT partially relabel. Sub-decompose into bounded causal children under a nested halt-on-failure orchestration and hand off (report the durable continuation).

**Report:** commands run, totals before/after for the affected slice, changed skip reasons, head SHA, and PR URL. Keep the PR open; do not merge.

issue_spine: issue-kriscendobot-garden-51

<!-- garden-annotation: key=67344d1d5edd by=producer at=2026-08-16T06:49:04Z -->

DEFERRED INDEFINITELY by maintainer decision 2026-08-16 (liaison session): the re-scope proposal recommended promoting the 9 rebudgeted Intl/ECMA-402 formatter families as the best-scoped landable work, and the maintainer instead deferred the Intl feature families indefinitely to conserve campaign budget (spend was 3,307,979 against 2,080,000 approved). Do NOT promote this without a fresh maintainer go-ahead. The host-only-exclusion pattern proven by child-20 and js-25 still applies whenever it is revived.

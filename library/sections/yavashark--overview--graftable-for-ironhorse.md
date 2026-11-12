---
title: Graftable into Iron Horse with light translation
source: .
source_repo: Sharktheone/yavashark
source_commit: 2e159150b2e831440344b48320ac38785a2c460a
source_date: 2026-11-11
source_authors: [Shark (Sharktheone)]
ingested: 2026-11-12
ingested_by: scholar
topics: [engine-implementation, testing]
status: current
notes: "Repo-overview section (source_kind external-monorepo-overview; anchor is repo HEAD on main). Read from a git clone into a scratch dir, treated as untrusted data; foreign-content classifier not run (TYPESAFE_API_KEY absent; maintainer typesafe-bypass directive 2026-11-12). Iron Horse comparisons are against endojs/endo-but-for-bots origin/llm 48d6f3e08bcc (2026-11-02)."
---

## Abstract

Ranked candidates for porting from yavashark into Iron Horse, each checked against what Iron Horse has on `llm` at `48d6f3e0`. The cheapest and most useful is **test infrastructure**: measured per-test cost tiers, hash-nested sampled subsets, and CPU isolation for risky tests, which address Iron Horse's known flaky drifts under high parallelism. Next, used as references rather than as code: the Intl constructors Iron Horse lacks (Locale, RelativeTimeFormat, DisplayNames, Segmenter, DurationFormat), a `temporal_rs` differential oracle for Temporal (XS has no Temporal to compare against), and the `swc_validator` early-error rules as a checklist. Code-level grafts of built-ins are **not** light: yavashark's built-ins are macro-annotated methods over an RC object model, and Iron Horse's are `Interp` methods over arena `Slot`s, so "translation" here means re-implementing the algorithm. Yavashark is MIT. Iron Horse's tree is Apache-2.0 (endo), and MIT code can come in if the MIT notice is kept.

## What Iron Horse already has (so these are not candidates)

Iron Horse is well ahead on everything it was built for. It has its own XS-derived lexer, parser, scoper, and coder (`ironhorse-compile`, byte-identical to XS on the corpus); the XSRE-derived regexp engine (`ironhorse-regexp`); a full tracing collector with `GcHooks` (`ironhorse-vm/src/gc.rs`); snapshots (`ironhorse-snapshot`); metering (`ironhorse-meter`); libFuzzer targets (`ironhorse-fuzz`); an XS differential oracle (`xs-oracle`, `ironhorse-262`); and, in `ironhorse-vm/src/interp/natives/`, Atomics and SharedArrayBuffer, Float16Array, DisposableStack, `Math.sumPrecise`, Temporal (about 3.4k lines, hand-written), and Intl Collator, NumberFormat, DateTimeFormat, PluralRules, and ListFormat. Yavashark's parser (SWC), RegExp (`regress`), and GC (RC) would all be regressions for Iron Horse.

## Candidates

| # | yavashark file or module | What it does | What Iron Horse lacks | Translation effort | License / caveat |
|---|---|---|---|---|---|
| 1 | `crates/yavashark_test262/runner/calibration/`, `scheduler/scheduler.go` | Stores a measured CPU, wall, and RSS cost per test for each hardware key, then sorts tests into fast, medium, slow, and risky tiers (10 ms / 100 ms / 5 s CPU cuts; TIMEOUT or CRASH → risky). | `full-run.sh` and `endot-ih` batch cases by count, with per-batch watchdogs, quarantine, RSS limits, and resume. There is no per-test measured cost, and nothing schedules by cost. The library records that high parallelism causes flaky drifts in whole-tree sweeps. | **Low to moderate.** Port the idea, not the Go: add `cpu_ns`/`rss` per case to the `results/` batch JSON (`report.rs` already sees RSS), keep a calibration JSON per runner key, and give batching a cost-aware mode. Roughly 300–500 lines of Rust or shell. | MIT; idea-level port, no code copy needed. |
| 2 | `scheduler.go` `Make` (`selection: quick`, `coverage`) | Deterministic **nested** sampling: sort eligible tests by FNV-64a of their path and keep the first N%, so N% ⊂ M% for N < M. | No sampled PR-tier sweep. Whole subtrees or the whole tree are the only granularities. | **Low.** About 40 lines in the case enumerator plus a `--coverage` flag. Hashing the path keeps the sample stable across runs and hosts, which suits the meter-determinism culture. | MIT; trivial. |
| 3 | `cpus/cpus_linux.go`, `run/executor.go` | Pins risky tests to a reserved CPU set with `sched_setaffinity` (SMT siblings kept together) and low priority, with a separate worker cap. | Watchdogs kill runaways, but nothing isolates them from the timing-sensitive majority. | **Low.** `taskset`/`nice` in `full-run.sh`, or `libc::sched_setaffinity` in the Rust driver. Most valuable together with #1. | MIT; Linux-only, as in yavashark. |
| 4 | `runner/results/diff.go`, `ci/ci.go` | Per-run transition diff (new failures, new passes, filtered by transition kind) against a committed `history.json` in a data repo. | Iron Horse has `baseline/` and `expectations/` ratchets. Check them before porting: this may already be covered. A transition-filtered diff report is still the likely gap. | **Low** if needed. | MIT. Speculative: overlap with the ratchets was not measured. |
| 5 | `crates/yavashark_test262/src/test262.rs` (`$262.createRealm`, `evalScript`, `detachArrayBuffer`, `gc`, `IsHTMLDDA`) | A complete `$262` host object. | Partial. Iron Horse runs Test262 non-hardened, with a single Realm by design ("multiple Realms … remain separate work"), so `createRealm` cases are skipped or unsupported. | **Not light** for `createRealm`: it depends on multi-realm work in the VM. The others are small, and Iron Horse may already implement them (not checked case by case). | MIT; reference only. |
| 6 | `crates/yavashark_env/src/builtins/intl/locale.rs` (373 lines), plus `relative_time_format.rs`, `display_names.rs`, `segmenter.rs`, `duration_format.rs` | The Intl.Locale constructor over `icu` 2.2. The other four files are 68–126-line shells with no ICU calls. | Iron Horse has no `Intl.Locale`, RelativeTimeFormat, DisplayNames, Segmenter, or DurationFormat (zero source hits). It already links `icu_segmenter` and `icu_normalizer` **=2.2.0**, the same ICU4X major/minor yavashark uses. | **Moderate** for Locale: option resolution and ICU calls carry over, but object plumbing is rewritten against `Interp`. For the other four, yavashark offers little, since they appear to be shells; go straight to ICU4X and the spec. All new ICU data must enter Iron Horse's locked `intl_profile.rs` / `INTL_DATA_VERSION` (boot fingerprint). | MIT for the glue; ICU4X is Unicode-3.0 licensed. |
| 7 | `crates/yavashark_env/src/builtins/temporal/*.rs` (about 4.5k lines over `temporal_rs` 0.2.6) | Temporal as a thin binding over Boa's `temporal_rs` crate. | Iron Horse's Temporal has no oracle, because XS omits Temporal; the library records Temporal Test262 slices as host-excluded. | **Speculative but cheap as a dev-only oracle:** a test-only crate that runs `temporal_rs` on the same inputs and diffs results, the way `xs-oracle` serves for XS. **Not** a production dependency: yavashark enables `sys`/`tzdb`, which read the host clock and time-zone database, in conflict with Iron Horse's rule that "Temporal.Now returns the Unix epoch … UTC." | `temporal_rs` is a Boa project. Its license (believed MIT OR Apache-2.0) is not verified in this pass. |
| 8 | `crates/yavashark_swc_validator/src/check/*.rs` | Early-error rules (scope, ident, pattern, class, function, module, RegExp) written as an allocation-free pass over SWC AST. | Iron Horse's compiler gets early errors by mirroring XS. Where XS diverges from the spec, Iron Horse inherits the divergence. | **Reference only.** It is SWC-AST-shaped, so no code ports. Useful as a checklist of early-error classes when triaging `negative: {phase: parse}` failures. | MIT. |
| 9 | `crates/yavashark_env/src/builtins/signal/` | The TC39 Signals proposal (State, Computed). | Not in Iron Horse, and not in XS. | **Not recommended now.** It is Stage 1, with no SES or XS-parity driver. Listed only for completeness. | MIT. |

## Not graftable (checked)

- **Fuzzing:** yavashark has none (zero hits), and Iron Horse's `ironhorse-fuzz` is ahead.
- **Metering, snapshots, SES:** yavashark has none of these.
- **The bytecode generator** (`yavashark_bytecode/generator`, about 21k generated instructions): the opcode format is fixed by XS parity, so this is out of scope. See the architectural-differences section.

Source: [Sharktheone/yavashark](https://github.com/Sharktheone/yavashark/tree/2e159150b2e831440344b48320ac38785a2c460a) at commit `2e159150`; Iron Horse state from [endojs/endo-but-for-bots `rust/engine/`](https://github.com/endojs/endo-but-for-bots/tree/48d6f3e08bcc37fdd4c0dc8b85d1481ca861320c/rust/engine) at `48d6f3e0`.

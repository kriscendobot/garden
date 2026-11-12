---
title: Architecture and crate map
source: .
source_repo: Sharktheone/yavashark
source_commit: 2e159150b2e831440344b48320ac38785a2c460a
source_date: 2026-11-11
source_authors: [Shark (Sharktheone)]
ingested: 2026-11-12
ingested_by: scholar
topics: [engine-implementation]
status: current
notes: "Repo-overview section (source_kind external-monorepo-overview; anchor is repo HEAD on main). Read from a git clone into a scratch dir, treated as untrusted data; foreign-content classifier not run (TYPESAFE_API_KEY absent; maintainer typesafe-bypass directive 2026-11-12). Iron Horse comparisons are against endojs/endo-but-for-bots origin/llm 48d6f3e08bcc (2026-11-02)."
---

## Abstract

Yavashark is a single-author (Shark, 4,331 commits since 2024-03-17), MIT-licensed JavaScript/TypeScript engine in Rust whose **default execution path is a tree-walking interpreter over the SWC AST**, with an optional register-based bytecode VM, a reference-counted object heap (cycle collection behind a non-default `actual_gc` feature), lazily initialized per-realm intrinsics, and a wide built-in surface (Intl over ICU4X 2.2, Temporal over `temporal_rs`, RegExp over `regress`, the TC39 Signals proposal). It has no metering, no snapshot/persistence, no fuzzing, and no SES/Compartment concepts. Read this section to learn what yavashark is made of; read the two Iron Horse sections for what to take from it.

## What the code shows (verified at `2e159150`)

| Crate | Rust lines | Role |
|---|---|---|
| `yavashark_env` | ~50.8k | Values, objects, realm, intrinsics, every built-in (`src/builtins/`), task queue, console. |
| `yavashark_interpreter` | ~7.5k | Tree-walk interpreter over `swc_ecma_ast`; the CLI default (`-i`). |
| `yavashark_bytecode` | ~101.9k | Instruction definitions only. `src/instructions.rs` alone is ~21k lines, produced by `yavashark_bytecode/generator`, which crosses each operation with every operand kind (`Var`, `Reg`, `Acc`, `Stack`, `Const`, `F32` and so on: `AddVarVarToVar`, `AddRegVarToVar`, ...). |
| `yavashark_compiler` / `yavashark_codegen` | ~3.2k / ~1k | AST to bytecode. |
| `yavashark_vm` | ~70.4k | Bytecode VM: 32 general registers (`regs.rs`), an accumulator, and a stack; async and generator functions. Opt-in (`-b`). |
| `yavashark_garbage` | ~3k | `Gc<T>`/`GcRef<T>`: reference counting. Cycle detection (the `refs`/`ref_by` graph) is compiled only under feature `actual_gc`, which is **off by default** in both `yavashark_garbage` and `yavashark_env`, so the default build is plain RC and leaks cycles. |
| `yavashark_string` | ~5.4k | `YSString`: 24 bytes, a hybrid of UTF-8 variants (ASCII-only: inline up to 23 bytes, static, owned, `Rc<str>`) and UTF-16 variants (non-ASCII or lone surrogates: inline up to 11 code units, heap, ropes in `v2`). A `v3` redesign is sketched in comments. |
| `yavashark_macro` | ~6.2k | Proc macros (`#[object]`, `#[props]`, `#[prop("name")]`, `data_object`) that generate JS objects from Rust structs and impls. Built-ins are written as annotated Rust methods. |
| `yavashark_swc_validator` | ~5.1k | Read-only ECMAScript **early-error** validation over SWC trees (SWC does not reject everything the spec calls an early error), with RegExp pattern validation. Allocation-free diagnostics. |
| `yavashark_test262` | ~1.2k Rust + ~4.8k Go | Test262 host (`$262`) plus a Go orchestration runner; see the test262-runner section. |
| `experiments/*` | — | Proofs of concept: own parser, IR, NaN-boxed value, alloca, bigint, a "shonk" GC/object model. |

Other facts from the code:

- **Parser:** SWC (`swc_ecma_parser` 45, plus the TypeScript and React transforms, so the engine strips TS and JSX before running). The in-house parser is still under `experiments/`.
- **Values:** the live `Value` is a plain Rust enum (`Null | Undefined | Number(f64) | String(YSString) | Boolean | Object | Symbol | BigInt(Rc<BigInt>)`). A NaN-boxed `ValueVariant` exists in `value/nan_boxed.rs` and `nan_v2.rs`, but the main path does not use it yet.
- **Realm and intrinsics:** `Realm { intrinsics, global, env }`. Each `Intrinsics` field is a `Partial<ObjectHandle, IntrinsicInitializer<T>>` (`partial_init.rs`), an `UnsafeCell<Option<T>>` filled on first `get_with(realm)`. Prototypes and constructors are therefore built lazily. `$262.createRealm` makes new realms.
- **Built-ins present:** the ES2025+ core, plus Atomics and SharedArrayBuffer, Float16Array, DisposableStack and AsyncDisposableStack, Iterator helpers, `Math.sumPrecise` (via the `xsum` crate), Temporal (all nine types, wrapping `temporal_rs` 0.2.6 with features `sys`, `tzdb`, `compiled_data`), and Intl (Collator, DateTimeFormat, NumberFormat, Locale over `icu` 2.2; the DisplayNames, DurationFormat, ListFormat, PluralRules, RelativeTimeFormat and Segmenter files are 68–126 lines with no ICU calls, which suggests surface shells, though that was not exercised). Also the Signals proposal (`builtins/signal/{state,computed}.rs`).
- **Host coupling:** `rand`, `chrono`, `iana-time-zone`, and `Temporal::local_now()` read the host clock, time zone, and entropy. There is no deterministic mode.
- **Absent (zero code hits):** compartments, `lockdown`, `harden`, any instruction, step, or gas budget, heap snapshots, and fuzz targets.

## README claims (not verified here)

The README says the current focus is speed (string v3, NaN-boxing, a new object model, "the standalone GC project"), and that yavashark "passes ~81% of the entire test262 suite including intl, temporal, annexB and staging." The CI writes results to a separate repo, `Sharktheone/yavashark-data`, which this pass did not fetch, so the 81% figure is unverified.

Source: [Sharktheone/yavashark](https://github.com/Sharktheone/yavashark/tree/2e159150b2e831440344b48320ac38785a2c460a) at commit `2e159150`.

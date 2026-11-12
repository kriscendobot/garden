---
source_kind: external-monorepo-overview
source: .
source_repo: Sharktheone/yavashark
source_url: https://github.com/Sharktheone/yavashark
source_branch: main
source_commit: 2e159150b2e831440344b48320ac38785a2c460a
source_date: 2026-11-11
source_authors: [Shark (Sharktheone)]
license: MIT
ingested: 2026-11-12
ingested_by: scholar
section_count: 4
status: current
content_caveat: "Read from a git clone (not a web fetch) and treated as untrusted data. The foreign-content classifier was not run: no TYPESAFE_API_KEY on the claiming host, under the maintainer typesafe-bypass directive of 2026-11-12. No instruction-like text was observed in the README or in the files read."
notes: "First-pass ingest for job scholar-ingest-yavashark-ironhorse-20261030 (maintainer ask, 2026-10-30), with emphasis on relevance to Iron Horse (endojs/endo-but-for-bots rust/engine at origin/llm 48d6f3e08bcc, 2026-11-02). Sibling-implementation genre: read for comparison, not import. The README's ~81% test262 claim is unverified (results live in Sharktheone/yavashark-data, not fetched)."
---

# Sharktheone/yavashark: repository overview

## Abstract

Yavashark is a single-author, MIT-licensed JavaScript and TypeScript engine in Rust. It runs by default as a tree-walking interpreter over the SWC AST, with an opt-in register-based bytecode VM. Its heap is reference-counted, with cycle collection behind a non-default feature, and each realm initializes its intrinsics lazily. The built-in surface is broad: Intl over ICU4X 2.2, Temporal over `temporal_rs`, RegExp over `regress`, plus the Signals proposal. It also has a measured-cost Test262 runner written in Go. It has no metering, snapshots, fuzzing, or SES. For Iron Horse, the payoff is test infrastructure plus a spec-breadth reference, not engine architecture.

## Graftable with light translation

Summary; detail, per-item effort, and licensing are in [graftable-for-ironhorse](../sections/yavashark--overview--graftable-for-ironhorse.md).

- **Test262 runner ideas (low effort; ideas only, no code copied):** a per-hardware calibration of measured per-test CPU, wall time, and RSS that sorts tests into fast, medium, slow, and risky tiers; deterministic hash-nested N% sampling for cheap PR sweeps; and CPU-affinity isolation for risky tests. Iron Horse's `full-run.sh` and `endot-ih` batch tests by count and have none of these.
- **Intl.Locale** (moderate effort) over the same ICU4X 2.2 that Iron Horse already pins. Yavashark's RelativeTimeFormat, DisplayNames, Segmenter, and DurationFormat look like shells, so they offer little.
- **`temporal_rs` as a dev-only differential oracle** for Iron Horse's hand-written Temporal, which has no XS oracle. This one is speculative, and the dependency could not ship in production because of host time-zone and clock coupling.
- **`swc_validator` early-error rules** as a reference checklist only.

## Architectural differences worth considering

Summary; the axis-by-axis table is in [architectural-differences-vs-ironhorse](../sections/yavashark--overview--architectural-differences-vs-ironhorse.md).

- The two engines make opposite bets on the front end (SWC versus an XS-derived compiler), execution (a tree-walker plus an operand-specialized register VM versus the XS stack bytecode), GC (reference counting versus tracing with consumer scheduling), determinism (none versus a meter plus deterministic math), and Test262 (pass rate versus zero divergence from XS).
- Two ideas are worth carrying into design discussion, both speculative. The first is **lazy intrinsic materialization** (`partial_init.rs`), which bears on the Proposed `ironhorse-intrinsic-fault-in` design and its SES freeze and snapshot complications. The second is **ASCII-compact UTF-8 strings**, which bear on Iron Horse's heap-envelope bar.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [architecture-and-crate-map](../sections/yavashark--overview--architecture-and-crate-map.md) | engine-implementation | current |
| [test262-runner](../sections/yavashark--overview--test262-runner.md) | testing, engine-implementation | current |
| [graftable-for-ironhorse](../sections/yavashark--overview--graftable-for-ironhorse.md) | engine-implementation, testing | current |
| [architectural-differences-vs-ironhorse](../sections/yavashark--overview--architectural-differences-vs-ironhorse.md) | engine-implementation | current |

## Not ingested (remainder, deliberately deferred)

The `experiments/` proofs of concept (own parser, IR, NaN-boxed value, "shonk" object model and GC); the bytecode VM's async and generator machinery; the `yavashark_macro` object model in depth; and the `yavashark-data` results repo. None of these looked decision-relevant for Iron Horse at this pass, so no follow-on job is posted. Re-ingest if Iron Horse's string-representation or intrinsic fault-in designs advance.

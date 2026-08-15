---
child-ironhorse-intl-numberformat-reap-count: 0
order: serial
children: ironhorse-intl-numberformat ironhorse-intl-core-tolocalestring ironhorse-intl-displaynames ironhorse-intl-relativetimeformat ironhorse-intl-durationformat ironhorse-intl-datetimeformat ironhorse-intl-locale ironhorse-intl-collator ironhorse-intl-listformat ironhorse-intl-segmenter
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-08-15T01:25:16Z
---

# Intl formatter value/metering parity — nested closure orchestration (js-26 residual)

Nested halt-on-failure orchestration that closes the **Intl formatter value/metering parity** cluster (887 actionable cases across the `intl402/*` subtrees) measured under the js-26 residual-closure arc (parent job `ironhorse-js-26-cg-intl-value-parity`, issue kriskowal/garden#51).

**Why nested:** the cluster requires real ECMA-402 engine implementation — the pinned Moddable XS oracle has **no Intl host**, so the accepted terminal for an Intl-host case is `oracle-host-missing-intl` reached only when Ironhorse runs the case to completion with the correct value (the child-20 host-only-exclusion pattern). Diagnosis at engine head `cf9247cd0` found **four constructors entirely unimplemented** (`Intl.NumberFormat`, `Intl.DisplayNames`, `Intl.DurationFormat`, `Intl.RelativeTimeFormat` — all `typeof === 'undefined'`) and **five partial** (`DateTimeFormat`, `Locale`, `Collator`, `ListFormat`, `Segmenter`) with residual `abort-value-differs`/unsupported-opcode stops. Too large for one handler; decomposed per formatter family.

**Serial, halt-on-failure** — one family lands and is verified (affected slice + full Rust workspace gates + exact-metering corpus) before the next promotes, so the shared branch `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970, kept OPEN/draft) never suffers concurrent-CAS collisions. Run order puts the foundational NumberFormat first (the toLocaleString bridges and DurationFormat depend on it).

Each child carries the full pins, acceptance bar, regression invariant, shared-branch rules, and its measured causal diagnosis.

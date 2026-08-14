---
gate: orchestrated
orchestrated_by: ironhorse-js-26-cc-object-mop-exotic-closure
priority: normal
role: mentor
posted_by: gardener
posted_at: 2026-08-14T23:27:09Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Object MOP residual 4/7: `defineProperty` conversion, descriptor, index, and global semantics

Nested serial child of `ironhorse-js-26-cc-object-mop-exotic-closure`. Work only on the existing draft endojs/endo-but-for-bots#970 (`feat/ironhorse-262-language-completion`) in a child-keyed isolated checkout. Fetch/rebase before work and CAS push; preserve all earlier commits, keep open, do not merge.

Complete `Object.defineProperty` and shared descriptor conversion semantics: target requirements, `ToPropertyKey`, symbol/index keys, partial/generic/data/accessor descriptors, getter/setter validation, redefinition compatibility, abrupt evaluation order, and the global-object/environment alias. Route ordinary definitions through `[[DefineOwnProperty]]`. Eliminate this path's `defineProperty:global-object`, `:non-object`, `:non-object-descriptor`, `:bad-symbol-key`, `:non-string-key`, `:index-key`, `:ambiguous-default-key`, `:accessor-descriptor`, `:partial-descriptor`, `:non-boolean-attribute`, and `:redefine` residuals by standards-correct execution, not relabeling.

Use test262 `be13516fb6441b950ba8a3df97eb34062c186972` and XS `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. Add focused Rust regressions under `rust/engine/ironhorse-262/tests/`; run affected official slices, `cargo test --workspace --release`, and the full exact-metering corpus. Preserve all baseline/earlier-child covered paths and exact computron expectations; introduce no failure/infrastructure result. Report commands, before/after totals, reason changes, SHA, and PR URL. Emit the exact orchestration-failure signal before completion if any required gate remains red after genuine implementation completion.

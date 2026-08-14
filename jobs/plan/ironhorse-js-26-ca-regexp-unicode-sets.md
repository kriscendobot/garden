---
gate: orchestrated
orchestrated_by: ironhorse-js-26-ca-regexp-unicode-closure
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-08-14T22:23:04Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 14000
Repository: endojs/endo-but-for-bots. Continue shared branch feat/ironhorse-262-language-completion / draft PR https://github.com/endojs/endo-but-for-bots/pull/970 after the u-core and property-escape children. Use a child-keyed isolated project worktree, fetch/rebase before work and before CAS push, and preserve the stack.

Implement the RegExp `v` flag / unicodeSets grammar and execution against pinned XS: nested character-class set operations, intersection/subtraction, reserved punctuator and escape validation, properties of strings, multi-code-point string alternatives, complement/case-folding semantics, and `unicodeSets`/flags surface behavior. Preserve compile and match metering parity. This must be real execution, not a skip/expectation/reason rewrite. Pins: test262 be13516fb6441b950ba8a3df97eb34062c186972; Moddable XS 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d.

Add focused Rust regressions under rust/engine/ironhorse-262/tests/ and lower-level bit/parity coverage. Run the affected official RegExp v/unicodeSets slices plus representative dependent Temporal/Intl cases, `cargo test --workspace --release`, and `ironhorse-xst --gate-meter-exact` before push. Preserve all baseline/earlier-child coverage and exact expectations. Report before/after outcome and reason totals, commands, head SHA, and PR URL; use the orchestration-failure marker if any required gate remains unmet.

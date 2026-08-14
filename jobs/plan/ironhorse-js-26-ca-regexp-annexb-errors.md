---
gate: orchestrated
orchestrated_by: ironhorse-js-26-ca-regexp-unicode-closure
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-08-14T22:23:18Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 14000
Repository: endojs/endo-but-for-bots. Continue shared branch feat/ironhorse-262-language-completion / draft PR https://github.com/endojs/endo-but-for-bots/pull/970 after the Unicode/groups work. Use an isolated child-keyed checkout, fetch/rebase latest shared head, preserve the stack, and CAS-push. Keep the PR open and draft.

Close remaining RegExp grammar and early-error validation, especially Annex B legacy non-Unicode behavior: decimal/octal/control/identity escapes, class ranges, leading/trailing escapes, quantifiable assertions, malformed groups/classes/quantifiers, duplicate/invalid flags, constructor versus literal validation, and strict u/v rejection boundaries. Compare directly to pinned XS and implement execution/validation rather than skips, relabels, or expectation files. Pins: test262 be13516fb6441b950ba8a3df97eb34062c186972; Moddable XS 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d.

Add focused Rust unit/regression tests under rust/engine/ironhorse-262/tests/ and compiler/regexp tests. Run official annexB/built-ins/RegExp, built-ins/RegExp, and language/literals/regexp slices, plus `cargo test --workspace --release` and `ironhorse-xst --gate-meter-exact` before push. Preserve all prior covered cases and exact metering. Report before/after totals and reason changes, commands, head SHA, and PR URL; emit orchestration failure if any gate remains unmet.

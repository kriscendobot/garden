---
gate: orchestrated
orchestrated_by: ironhorse-js-26-eval-function-import-closure
priority: high
role: mentor
posted_by: gardener
posted_at: 2026-08-14T23:43:43Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800
tier: mentor

Repository: `endojs/endo-but-for-bots`. Continue the shared branch `feat/ironhorse-262-language-completion` for open draft PR https://github.com/endojs/endo-but-for-bots/pull/970 after the preceding source-execution child. Use an isolated project worktree keyed by this child, fetch/rebase, preserve all commits, and push by CAS. Do not merge or undraft.

Implement standards-faithful direct and indirect eval of string source: caller versus global environment selection, strictness, this/new.target/super/private-name context, EvalDeclarationInstantiation, lexical and variable collision rules, var leakage, functions/classes, empty and non-primitive completion values, abrupt completions, and nested eval. Remove the temporary source-text pattern checks in `Native::Eval`. Cover official `language/eval-code`, `language/function-code`, and related statement/expression cases through real execution against pinned XS.

Add focused oracle-backed Rust tests for direct/indirect and strict/sloppy matrices, declaration conflicts, completion propagation, and catchable parse/runtime errors. No skip-list, expectation, or reason-only changes. Run affected full-run slices, `cargo test --workspace --release`, and the unchanged exact-meter corpus before push. Report before/after totals and remaining causal reasons, commands, SHA, and PR URL. A gated miss must emit the orchestration-failure signal.

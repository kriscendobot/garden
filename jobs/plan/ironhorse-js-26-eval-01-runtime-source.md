---
gate: orchestrated
orchestrated_by: ironhorse-js-26-eval-function-import-closure
priority: high
role: mentor
posted_by: gardener
posted_at: 2026-08-14T23:43:38Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800
tier: mentor

Repository: `endojs/endo-but-for-bots`. Work only on shared branch `feat/ironhorse-262-language-completion` for open draft PR https://github.com/endojs/endo-but-for-bots/pull/970. Use `ensure-project-worktree.sh` with this child's unique basename, fetch the branch, preserve all commits, and push with a fetch/rebase/CAS loop. Do not merge or undraft.

Build the reusable runtime source-compilation and same-realm execution bridge needed by eval string source and dynamic function constructors. Replace the explicit `eval:string-source` boundary with a principled compiler/VM interface, including symbol/linkage ownership, nested invocation, catchable parse errors, realm identity, job/meter behavior, and safe recursion/lifetime handling. Do not implement semantics by source-text pattern matching. Preserve byte identity for ahead-of-time compiled code.

Add focused oracle-backed Rust regression tests under `rust/engine/ironhorse-262/tests/` for string compilation, completion values, syntax errors, nested execution, and realm-local errors. Measure relevant official `language/eval-code` and `built-ins/Function` samples before/after with pinned test262 and XS. Do not relabel or skip. Run `cargo test --workspace --release` from `rust/engine`, the exact-meter corpus (`ironhorse-xst --gate-meter-exact`), and affected official slices before push. Report commands, counts, reasons changed, head SHA, and PR URL. If the gated outcome is not achieved, end with the orchestration-failure signal before the completion signal.

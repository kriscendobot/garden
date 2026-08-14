---
gate: orchestrated
orchestrated_by: ironhorse-js-26-eval-function-import-closure
priority: high
role: mentor
posted_by: gardener
posted_at: 2026-08-14T23:43:52Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800
tier: mentor

Repository: `endojs/endo-but-for-bots`. Continue shared branch `feat/ironhorse-262-language-completion` for draft PR https://github.com/endojs/endo-but-for-bots/pull/970. Use an isolated project worktree keyed by this child, rebase onto the latest remote head, and CAS-push without merging or undrafting.

Close the Annex B and parser/source-text portion exposed by runtime eval and dynamic functions. Implement standards-grounded HTML open/close comments and line-terminator restrictions for Script and dynamic-function parameter/body parsing, Annex B block-level function declaration instantiation, and the eval/global block-scoping interactions represented by the job's example cases. Cover the relevant `annexB/built-ins/Function` and `annexB/language/eval-code` official slices through real execution against XS.

Add focused Rust oracle regressions for every grammar/instantiation family, including positive and negative cases. No generic parser skips, text heuristics, skip lists, or relabeling. Run affected official slices, `cargo test --workspace --release`, and exact metering before push. Report totals before/after, reasons changed, commands, SHA, and PR URL. Emit the orchestration-failure signal if the gate is not met.

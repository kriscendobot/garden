---
order: serial
children: xs2rust-endor-stage5-lexer xs2rust-endor-stage5-parser-expr xs2rust-endor-stage5-parser-stmt xs2rust-endor-stage5-scoper xs2rust-endor-stage5-coder-expr xs2rust-endor-stage5-coder-decl xs2rust-endor-stage5-byte-identity
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-07-06T21:33:32Z
---

Stage 5 (compiler port — endor-compile) of the XS→Rust port program, PR endojs/endo-but-for-bots#600.
Serial: lexer → parser(expr) → parser(stmt) → scoper → coder(expr) → coder(decl) → byte-identity
stage bar. Halt on child failure and surface to supervisor s12
(port-xs-to-rust-memory-safe-engine-s12, parked blocked on this orchestration). Stage bar:
byte-identical bytecode vs the oracle compiler on the full conformance corpus; parse metering
deterministic per release; parser fuzz target armed. Stage-4 acceptance: PR #600
issuecomment-4897783472.

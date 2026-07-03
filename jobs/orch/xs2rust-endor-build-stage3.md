---
order: serial
children: xs2rust-endor-build-stage3-language xs2rust-endor-build-stage3-fundamentals xs2rust-endor-build-stage3-arrays xs2rust-endor-build-stage3-text-math-json xs2rust-endor-build-stage3-collections xs2rust-endor-build-stage3-promises xs2rust-endor-build-stage3-xsre
on-child-failure: halt
state: running
created_by: supervisor-s5
created_at: 2026-07-03T03:46:44Z
---

Roadmap stage 3 of the xs2rust-endor port (PR endojs/endo-but-for-bots#600): the
built-ins, in seven serial children per the design's "Stage-3 decomposition" amendment
(commit 287e080b5) — (1) language closure: strings as values + remaining language
opcodes + XS fixed stack limits + FUNCTION_* residual closure; (2) fundamentals:
constructors/Object/Function/Boolean/Symbol/Error; (3) arrays + iteration protocol;
(4) String.prototype/Number/Math/JSON; (5) collections + binary data + BigInt;
(6) promises + job queue; (7) the xsre RegExp port (resolved question 6). Bar per the
design table: built-ins sections dual-run agreement including computrons, language/
covered growth at zero divergence. Scoped by supervisor s5 after accepting stage 2b
(review issuecomment-4872378323). Supervisor continuation
`port-xs-to-rust-memory-safe-engine-s6` parks blocked on this orchestration.

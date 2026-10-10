---
gate: go-ahead
priority: normal
roadmap: ironhorse-engine
role: builder
posted_by: designer
posted_at: 2026-10-10T03:29:34Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Port Moddable 10.0.0 compiler safety corrections to IronHorse

Implement child 2 of the reviewed Moddable SDK 10.0.0 IronHorse plan for `endojs/endo-but-for-bots`.

Design and review surface: https://github.com/endojs/endo-but-for-bots/pull/1435 (`designs/moddable-10-0-0-ironhorse-port-plan.md`). This job is parked pending design review and must be activated only by the recommended `moddable-10-0-0-ironhorse-ports` orchestration, after child 1 succeeds.

## Scope

- In `rust/engine/ironhorse-compile`, make the scope-slot implementation limit explicit: accept 65,535 slots and reject 65,536 or more with SyntaxError before `width_select_index_plus_one_family` can truncate an operand into a private opcode family.
- Include slot pressure from tagged-template temporaries and any other synthetic bindings in the same checked accounting.
- Update `code_switch` / `code_break_continue` so labelled `break` and `continue` unwind the switch discriminant and other temporaries to the target `stack_level`, including nested switch and try/finally control flow.
- Do not change the oracle pin, hardened262 matrix, ratchet floor, or unrelated bytecode layouts.

## Acceptance

- Add compiler tests at 65,535 and 65,536 slots, including tagged-template pressure, and prove the latter is a deterministic SyntaxError rather than corrupt bytecode or a private-opcode failure.
- Add runtime/compiler tests for repeated labelled continue, labelled break, nested switch, and try/finally exits; prove stack height remains stable.
- Update only byte-identity fixtures whose intentional POP/unwind sequence changes, with an explanation per changed fixture.
- Run the full `ironhorse-compile` tests plus the nearest VM and targeted test262 suites; introduce no generic skips or unrelated fixture churn.
- Open a draft implementation PR with exact-head evidence and link the design PR. Do not merge it or start a sibling child.

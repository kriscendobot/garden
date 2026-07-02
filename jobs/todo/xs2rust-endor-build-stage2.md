<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-02T21:09:26Z -->

---
model: opus
---
# Builder: xs2rust-endor roadmap stage 2 — object model, control flow, full opcode coverage, GC v1 (PR #600)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600 — same PR as the design and
stage 1; keep DRAFT). Workspace `rust/engine/`. The `c/moddable` oracle-pin reproduction
procedure is in `rust/engine/README.md` (shallow-fetch `48ee02d8cfe0`).

You are the stage-2 builder of the approved design `designs/xs2rust-endor-engine.md`
(status: Approved; § Resolved Questions is BINDING — reopening a resolved question is a design
amendment for the supervisor, not a code-review discussion). Read the design first, then the
stage-1 code (`rust/engine/`), the supervisor's stage-1 review
(https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4870367815), and the fixer
change from job `xs2rust-endor-fix-stage1-review` that landed before you.

**Deliverable (design § Staged Roadmap, stage 2):** objects, prototypes, property operations,
closures, exceptions (XS's jump-chain with JS/host flags), **full 245-opcode coverage with
built-ins stubbed**, and GC v1 (mark-sweep over the slot arena + chunk slide-compaction).
Per the supervisor's stage-1 rulings, the **call/frame machinery deferred out of stage 1 is
your first work item** (the `function`/`constructor_function` opcodes, closure/scope/argument
binding, call/run frames), and `Compartment::evaluate` must stop being a stub: bind the
compartment's globals so two compartments over shared intrinsics observably diverge only in
their own globals.

**Acceptance bar (from the design table):** test262 `language/` dual-run agreement on the
covered grammar — bit-exact (result, computron) agreement with the C-XS oracle, same
four-valued completion semantics as stage 1 — plus the GC test suite green under Miri.
Also: grow the corpus so it exercises loops (backward branches — the meter check points must
fire on compiler-emitted bytecode, not only hand-assembled bytes), user function calls,
closures, property access, and thrown-and-caught exceptions. The stage-1 86/86 bar must stay
green. `#![forbid(unsafe_code)]` on every crate except `endor-oracle`. Extend the differential
fuzz grammar to the new surface.

Practical notes from stage 1: metering weights are 1<<16 per dispatch (plus explicit k*CODE
sites) and 1<<14 per built-in step; the run-only computron window is measured after parse
(oracle shim resets `meterIndex`); `PROGRAM_INVOCATION_COMPUTRONS` may need rework once real
call frames exist — derive it, don't hardcode, if the frame machinery explains it.

Report: what landed, the acceptance evidence verbatim (corpus totals, test262-language
numbers, Miri run), any scope folds or frictions for the supervisor. Commit to
`xs2rust-endor`, push, keep the PR draft.

<!-- garden-deadline-overrun: 1 -->

<!-- garden-reaped: 1 -->

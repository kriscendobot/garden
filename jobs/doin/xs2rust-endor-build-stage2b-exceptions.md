<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-03T02:29:34Z -->

---
model: opus
---
# Builder: xs2rust-endor stage 2b (3/3) — exceptions, full opcode coverage, stage-2 bar (PR #600)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600; keep DRAFT). Workspace
`rust/engine/`. Read in order: `designs/xs2rust-endor-engine.md` (§ Resolved Questions
BINDING; § Staged Roadmap "Stage-2 amendment"), the supervisor's stage-2a review
(https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4870957010), the
child-1/child-2 tada reports (`xs2rust-endor-build-stage2b-{heap,frames}`) and their
landed code, and `rust/engine/README.md` (oracle-pin fallbacks; empty-gitlink footgun).

You are child 3 (last) of the serial `xs2rust-endor-build-stage2b` orchestration.

**Deliverable:** exceptions ported as XS's jump-chain with the JS/host flags
(`fxThrow`/the jump buffer chain, try/catch/finally opcodes, uncaught propagation to
the host boundary), plus **full 245-opcode decode + dispatch coverage with built-ins
stubbed** (a stubbed opcode executes with faithful stack/frame/meter effects where its
semantics need no built-in, and halts `Unsupported` — never silently — where they do).
Tighten `DualRun::is_bit_exact` per supervisor observation 3: `BothAbort(Throw)`
compares the completion (error string) and computrons like the `BothComplete` arm.
Extend the differential fuzz grammar over objects, calls, closures, and
thrown-and-caught exceptions.

**Acceptance bar (closes roadmap stage 2):** test262 `language/` dual-run agreement on
the covered grammar — bit-exact (result, computron) with the C-XS oracle, four-valued
completion semantics — reported with the covered/skipped split stated honestly (a
section skipped for built-ins is named, not folded into a pass rate). Everything prior
(stage-1 86/86, child-1/2 corpora, Miri GC) stays green. `#![forbid(unsafe_code)]`
everywhere but endor-oracle.

Budget discipline: commit and push green increments early; if the budget nears, push
what is green and exit WITHOUT the completion signal so the requeue resumes. Never
message the maintainer; blocking discoveries go to
`/home/kris/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s5` and your
tada report.

Report: what landed, the test262 language/ numbers verbatim (total, covered, bit-exact,
divergent, skipped-by-reason), fuzz totals, Miri run, scope folds/frictions. Commit to
`xs2rust-endor`, push, keep the PR draft.

<!-- garden-deadline-overrun: 1 -->

<!-- garden-reaped: 1 -->

---
claim:
  host: endolinbot2
  gardener: 4
  claimed_at: 2026-07-03T03:13:27Z

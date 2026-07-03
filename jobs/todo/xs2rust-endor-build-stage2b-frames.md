<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-03T01:38:09Z -->

---
model: opus
---
# Builder: xs2rust-endor stage 2b (2/3) — closures, call/return frames, meter-check placement (PR #600)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600; keep DRAFT). Workspace
`rust/engine/`. Read in order: `designs/xs2rust-endor-engine.md` (§ Resolved Questions
BINDING; § Staged Roadmap "Stage-2 amendment"), the supervisor's stage-2a review
(https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4870957010), the
child-1 (`xs2rust-endor-build-stage2b-heap`) tada report and its landed code, and
`rust/engine/README.md` (oracle-pin fallbacks; empty-gitlink footgun).

You are child 2 of the serial `xs2rust-endor-build-stage2b` orchestration; child 1's
allocation-faithful heap is landed before you start.

**Deliverable:** user functions end to end on the heap child 1 built: the
`function`/`constructor_function` opcodes, closures via heap cells, call/run frame
switching (XS's `mxFrame` layout: frame slots, argument binding, `this`/target),
scope capture, RETURN/END popping into the calling frame. Move the meter checks to
C-XS's actual sites, fixing supervisor finding 1: checks fire at the `mxFirstCode`
sites — call entry (`xsRun.c:745`), return-into-a-JS-caller (`xsRun.c:1078`), catch
resume — and at backward branches; **no check when END/RETURN exits to the C caller**
(`xsRun.c:1080-1092`). Derive `PROGRAM_INVOCATION_COMPUTRONS` from the real frame
setup instead of hardcoding it, if the frame machinery explains it.

**Acceptance bar:** the bit-exact corpus extends over user function calls, closures
(capture + mutation), recursion, and nested calls — result AND computron agreement with
the C-XS oracle. Armed-meter tests assert C's placement semantics (abort at a backward
branch or call entry; never at top-frame exit). Everything prior (stage-1 86/86, child-1
corpus, Miri GC) stays green. `#![forbid(unsafe_code)]` everywhere but endor-oracle.

Budget discipline: commit and push green increments early; if the budget nears, push
what is green and exit WITHOUT the completion signal so the requeue resumes. Never
message the maintainer; blocking discoveries go to
`/home/kris/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s5` and your
tada report.

Report: what landed, acceptance evidence verbatim, scope folds/frictions. Commit to
`xs2rust-endor`, push, keep the PR draft.

<!-- garden-deadline-overrun: 1 -->

<!-- garden-reaped: 1 -->

<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-03T00:50:19Z -->

---
model: opus
---
# Builder: xs2rust-endor stage 2b (1/3) — allocation-faithful object heap + metering (PR #600)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600 — same PR as the design;
keep DRAFT). Workspace `rust/engine/`. Read in order: `designs/xs2rust-endor-engine.md`
(§ Resolved Questions is BINDING; § Staged Roadmap "Stage-2 amendment" is your charter),
the supervisor's stage-2a review
(https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4870957010), and
`rust/engine/README.md` (the c/moddable oracle-pin procedure — the shallow sha-fetch is
now rejected upstream; use the documented fallbacks, and mind the empty-gitlink footgun:
clone into `c/moddable` before any `git -C c/moddable` command).

You are child 1 of the serial `xs2rust-endor-build-stage2b` orchestration.

**Deliverable:** the allocation-faithful object heap over the existing slot/chunk arenas:
instances, prototypes, property behaviors (get/set/define/delete and the property opcodes
in the current grammar's reach), environment objects (`fxRunEvalEnvironment`'s closure
cell + property slot shape for `var`), with **allocation-faithful metering**: every slot
allocation ticks `XS_SLOT_ALLOCATION_METERING` (1<<8) exactly where `fxNewSlot` does,
every chunk byte ticks 1 exactly where `fxNewChunk`/`fxRenewChunk` do (`xsMemory.c` at
the pin is ground truth), and the property-path built-in steps (1<<14) land at C-XS's
sites. The meter already carries the constant set + `tick_slot_alloc`/`tick_chunk_alloc`
hooks. Also fix supervisor finding 2: `arm_meter`/`Meter::begin` must match
`fxBeginMetering` (`xsRun.c:4459`) — scale the interval `<<16`, reset
`meterIndex=0`/`meterCount=interval<<16`; re-express the armed-meter tests with
computron-unit intervals.

**Acceptance bar:** the stage-2 behavioral corpus (var/loop programs) GRADUATES into the
bit-exact corpus — result AND computron agreement with the C-XS oracle (the "16920 per
var" probe number must now be reproduced, not measured) — plus new object/property-literal
programs added bit-exact. Stage-1 86/86 stays green. GC suite (extended over the new heap
shapes) green under Miri. `#![forbid(unsafe_code)]` everywhere but endor-oracle.

Budget discipline: the prior stage-2 monolith died at the 2400s handler wall-clock.
Commit and push green increments EARLY and often; if the budget nears, push what is
green and exit WITHOUT the completion signal so the requeue resumes your worktree.
Do not message the maintainer; a genuinely blocking discovery goes to the supervisor's
inbox (`/home/kris/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s5`)
AND into your tada report. Reopening a resolved design question is a supervisor ruling —
record it, decide per the design as written, move on.

Report: what landed, acceptance evidence verbatim (corpus totals, computron numbers,
Miri run), scope folds/frictions for the supervisor. Commit to `xs2rust-endor`, push,
keep the PR draft.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolinbot2
  gardener: 11
  claimed_at: 2026-07-03T00:50:23Z

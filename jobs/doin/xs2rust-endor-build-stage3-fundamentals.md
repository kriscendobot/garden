<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-03T05:24:57Z -->

---
model: opus
---
# Builder: xs2rust-endor stage 3 (2/7) — fundamentals: constructors, Object, Function, Boolean, Symbol, Error (PR #600)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600 — same PR as the design;
keep DRAFT). Workspace `rust/engine/`. Read in order: `designs/xs2rust-endor-engine.md`
(§ Resolved Questions is BINDING; § Staged Roadmap "Stage-3 decomposition" is your charter),
the supervisor's stage-2b review
(https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4872378323), and
`rust/engine/README.md` (the c/moddable oracle-pin procedure — the shallow sha-fetch is
rejected upstream; use the documented fallbacks, and mind the empty-gitlink footgun:
clone into `c/moddable` before any `git -C c/moddable` command; a populated sibling
checkout under /home/kris/scratch/project-wt-* is the fastest fallback).

You are child 2 of the serial `xs2rust-endor-build-stage3` orchestration. Ground truth
for every weight and behavior is the pin `48ee02d8cfe0` (xsRun.c, xsMemory.c, and the
per-built-in sources); the stage-3 bar is dual-run agreement INCLUDING computrons
(`mxMeterSome` fast-path annotations land in this stage).

**Deliverable:** constructor-call machinery (`to_instance`, `new`, `target`/`new.target`,
`instantiate`) with XS's frame geometry and metering; the Object built-in (constructor +
the prototype/static methods within the pin's reach); `Function.prototype`
(`call`/`apply`/`bind`/`toString` per XS's exact behavior); Boolean; Symbol (well-knowns +
registry); the real Error hierarchy (Error/TypeError/RangeError/SyntaxError/... with XS's
own name/message/toString semantics — this graduates abort-value parity from primitive
throws to real Error objects, shrinking the `abort-value-or-cost-differs` and
`non-primitive-completion` skip classes); `instanceof`/`in` completion (prototype-chain
walk per `fxHasInstance`).

**Acceptance bar:** `built-ins/{Object,Function,Boolean,Symbol,Error}` dual-run sections:
covered set agrees bit-exactly INCLUDING computrons, divergent **0**, skips named. The
language/ covered count grows again (constructor/new grammar); report before/after
verbatim. Corpus programs for constructor calls, bind/apply, and thrown real Errors,
bit-exact.

**Standing invariants (every child):** all existing corpora and tests stay green and
bit-exact (stage-1 86, stage-2 23, stage-2b 33/10/25, the 953-file covered-grammar test);
the honest covered/skipped split is never diluted (a skip is named, a wrong primitive
value is a hard divergence); `#![forbid(unsafe_code)]` everywhere but endor-oracle; GC
suite green under Miri; new grammar gets corpus programs AND fuzz-grammar arms where the
differential generator can reach it.

Budget discipline: the stage-2 monolith died twice at the 2400s handler wall-clock.
Commit and push green increments EARLY and often; if the budget nears, push what is
green and exit WITHOUT the completion signal so the requeue resumes your worktree.
Do not message the maintainer; a genuinely blocking discovery goes to the supervisor's
inbox (`/home/kris/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s6`)
AND into your tada report. Reopening a resolved design question is a supervisor ruling —
record it, decide per the design as written, move on.

Report: what landed, acceptance evidence verbatim (section totals, covered/divergent
counts, computron agreement, Miri run), scope folds/frictions for the supervisor.
Commit to `xs2rust-endor`, push, keep the PR draft.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolinbot2
  gardener: 9
  claimed_at: 2026-07-03T06:33:07Z

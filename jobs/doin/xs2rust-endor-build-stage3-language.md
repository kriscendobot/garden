<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-03T03:48:08Z -->

---
model: opus
---
# Builder: xs2rust-endor stage 3 (1/7) — language closure: strings as values + remaining language opcodes + stack limits (PR #600)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600 — same PR as the design;
keep DRAFT). Workspace `rust/engine/`. Read in order: `designs/xs2rust-endor-engine.md`
(§ Resolved Questions is BINDING; § Staged Roadmap "Stage-3 decomposition" is your charter),
the supervisor's stage-2b review
(https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4872378323), and
`rust/engine/README.md` (the c/moddable oracle-pin procedure — the shallow sha-fetch is
rejected upstream; use the documented fallbacks, and mind the empty-gitlink footgun:
clone into `c/moddable` before any `git -C c/moddable` command; a populated sibling
checkout under /home/kris/scratch/project-wt-* is the fastest fallback).

You are child 1 of the serial `xs2rust-endor-build-stage3` orchestration. Ground truth
for every weight and behavior is the pin `48ee02d8cfe0` (xsRun.c, xsMemory.c, and the
per-built-in sources); the stage-3 bar is dual-run agreement INCLUDING computrons
(`mxMeterSome` fast-path annotations land in this stage).

**Deliverable:** (a) chunk-backed CESU-8 string *values*: string literals, concatenation
(`XS_STRING_METERING` per code unit plus the faithful `fxNewChunk`/`fxRenewChunk` byte
metering), equality/relational comparison, and `typeof` over all covered kinds; (b) the
`global` opcode (top skip reason in the sections sweep: 144 files); (c) the remaining
language opcodes the language/ sweeps name: `increment`/`decrement`/`to_numeric` (numeric
coercion on the primitive subset), exponentiation, `this`, `let_closure`/`const_closure`,
`current`, `refresh_local`, `delete_property`, `copy_object`/`extend` (spread),
`branch_coalesce`/`branch_chain` (nullish/optional chaining), `arguments` sloppy and
strict, `at_2`; (d) review obs 1: model XS's **fixed stack limits** — `fxOverflow` over
the value stack's width-not-depth geometry and the frame stack's `mxStackCount`-equivalent
— so a stack-exhausting program aborts bit-exactly (thrown value AND computrons) on both
engines; (e) review obs 3: decompose the measured `FUNCTION_*` definition constants
analytically against the pin, retiring the ≤~288-raw per-definition residuals.

**Acceptance bar:** rerun `test262-language` on `expressions` (was 155 covered / 0
divergent / 9446 total) and the `statements` subtrees (per-subtree, per the README memory
guidance): the covered count GROWS materially, divergent stays **0**, and every remaining
skip names a built-in gap (not a language-opcode gap from the list above). Report
before/after covered counts per subtree verbatim. New corpus programs for each new
opcode family, bit-exact (result AND computron).

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

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolinbot2
  gardener: 1
  claimed_at: 2026-07-03T03:48:13Z

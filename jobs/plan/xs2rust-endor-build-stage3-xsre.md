---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage3
priority: normal
posted_by: supervisor-s5
posted_at: 2026-07-03T03:46:29Z
---

---
model: opus
---
# Builder: xs2rust-endor stage 3 (7/7) — the xsre RegExp engine port (PR #600)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600 — same PR as the design;
keep DRAFT). Workspace `rust/engine/`. Read in order: `designs/xs2rust-endor-engine.md`
(§ Resolved Questions is BINDING; § Staged Roadmap "Stage-3 decomposition" is your charter),
the supervisor's stage-2b review
(https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4872378323), and
`rust/engine/README.md` (the c/moddable oracle-pin procedure — the shallow sha-fetch is
rejected upstream; use the documented fallbacks, and mind the empty-gitlink footgun:
clone into `c/moddable` before any `git -C c/moddable` command; a populated sibling
checkout under /home/kris/scratch/project-wt-* is the fastest fallback).

You are child 7 of the serial `xs2rust-endor-build-stage3` orchestration. Ground truth
for every weight and behavior is the pin `48ee02d8cfe0` (xsRun.c, xsMemory.c, and the
per-built-in sources); the stage-3 bar is dual-run agreement INCLUDING computrons
(`mxMeterSome` fast-path annotations land in this stage).

**Deliverable:** the `xsre` port (resolved question 6 — port XS's own RegExp engine, the
11.6 KLOC the feasibility verdict priced in; `c/moddable/xs/sources/xsre.c` at the pin is
ground truth): pattern compilation to xsre's internal form, the backtracking executor
with XS's exact step behavior, and the RegExp built-in (constructor, `exec`/`test`,
`Symbol.match/replace/search/split` surfaces within reach, `lastIndex` semantics) plus
regex literals. Metering: xsre execution steps meter exactly as the pin meters them —
pattern-dependent computron agreement is the whole point of porting xsre rather than
adopting a Rust regex crate.

**Acceptance bar:** `built-ins/RegExp` dual-run sections: covered agrees bit-exactly
INCLUDING computrons, divergent **0**, skips named. A structure-aware regex fuzz target
(patterns + subject strings) joins the differential fuzz suite, swept ≥400 seeds
bit-exact. Corpus programs over literals, exec/test loops (the metering hot path), and
backtracking-heavy patterns, bit-exact.

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

<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-03T07:19:42Z -->

---
model: opus
---
# Builder: xs2rust-endor stage 3 (3/7) — arrays and the iteration protocol (PR #600)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600 — same PR as the design;
keep DRAFT). Workspace `rust/engine/`. Read in order: `designs/xs2rust-endor-engine.md`
(§ Resolved Questions is BINDING; § Staged Roadmap "Stage-3 decomposition" is your charter),
the supervisor's stage-2b review
(https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4872378323), and
`rust/engine/README.md` (the c/moddable oracle-pin procedure — the shallow sha-fetch is
rejected upstream; use the documented fallbacks, and mind the empty-gitlink footgun:
clone into `c/moddable` before any `git -C c/moddable` command; a populated sibling
checkout under /home/kris/scratch/project-wt-* is the fastest fallback).

You are child 3 of the serial `xs2rust-endor-build-stage3` orchestration. Ground truth
for every weight and behavior is the pin `48ee02d8cfe0` (xsRun.c, xsMemory.c, and the
per-built-in sources); the stage-3 bar is dual-run agreement INCLUDING computrons
(`mxMeterSome` fast-path annotations land in this stage).

**Deliverable:** the Array exotic object (index/`length` semantics per `fxArraySetLength`),
array literals/holes/spread, `Array` constructor + statics (`isArray`, `of`, `from` within
reach), `Array.prototype` methods with their `mxMeterSome` fast-path annotations exactly
where the pin places them, and the iteration protocol: `for-in` (enumeration order per
XS), `for-of`, array and string iterators (generators themselves stay stage 4 per the
roadmap).

**Acceptance bar:** `built-ins/Array` dual-run sections: covered agrees bit-exactly
INCLUDING computrons, divergent **0**, skips named. `language/statements/{for-in,for-of}`
covered grows; report before/after verbatim. Corpus programs over literals, mutation
methods, iteration, and spread, bit-exact.

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


<!-- press-driver note (xs2rust-endor-press-20260703-112004, 2026-07-03T11:24Z):
Restored to todo/ after the reaper poisoned this child at reap cycle 5 (11:23:07Z).
The cycles were not job-intrinsic failures: each session landed real commits on
xs2rust-endor (HEAD 57c3a56 -> 52464aa -> 5063124 today), the exits were the
budget-discipline exit-without-signal resume pattern this job body itself mandates,
and the 09:06-10:45Z host-wide DNS outage burned cycles. Reap counter reset; resume
your stable worktree as before. If this hits the poison threshold AGAIN, do not
reset a second time - decompose the remaining scope into smaller children instead. -->

<!-- garden-reaped: 3 -->

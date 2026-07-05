<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-05T21:07:10Z -->

---
model: opus
---
# Builder: stage-3b child 7/9 — Promises, the job queue, and the pump-loop latch, PR #600

Repo `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600 — keep DRAFT). Engine at
`rust/engine/` (crates endor-vm, endor-262, endor-oracle, endor-fuzz). Design:
`designs/xs2rust-endor-engine.md` + the stage-3 decomposition amendment (`287e080b5`). Oracle: C-XS
pin `48ee02d8cfe0` — NOT shallow-fetchable; `rust/engine/README.md` documents the fallbacks (full
`public` fetch, or fetch from a populated sibling under /home/kris/scratch/project-wt-*/c/moddable)
and the empty-gitlink footgun. `cargo` lives at /home/kris/.cargo/bin (not on the default PATH). A
whole-tree single-process test262 `language/` run OOMs (C-oracle accumulation); run per subtree per
the README.

STANDING INVARIANTS (the stage-3 bar): every covered surface bit-exact vs the pin — result AND
computrons; dual-run divergent=0 in every touched test262 section; skips are HONEST and NAMED
(self-name `Halt::Unsupported` — never a wrong value, never a fitted meter); `#![forbid(unsafe_code)]`
outside endor-oracle; Miri GC suite green; every new grammar gets corpus programs AND a fuzz arm;
all prior corpora + the 953-file covered-grammar bar stay green.

WORK DISCIPLINE (you will likely NOT finish in one 2400s handler wall): land each increment as its
own green commit and PUSH immediately; when the wall nears, push, note progress, and exit WITHOUT
the completion signal so the job requeues and you resume in the same worktree. Never leave work
uncommitted at the wall. Get your project checkout with
`/home/kris/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`.

REPORTING: your tada report is the authoritative record; send scope folds / rulings-needed to the
supervisor inbox `port-xs-to-rust-memory-safe-engine-s7`
(`/home/kris/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s7`) — a dead-letter is
carried forward automatically. Never message the maintainer inbox; the maintainer enters the loop
once, at the end.

## Charter
The original stage-3 child 6 (swept unrun by the halt; fresh start), per the design decomposition:
- **Promise**: constructor + executor, `then`/`catch`/`finally`, `resolve`/`reject`, and
  the combinators (`all`/`race`, others as reachable), per the pin (`xsPromise.c`), metering
  calibrated.
- **The job queue**: XS's promise-job queue semantics (`fxQueueJob`/`fxRunPromiseJobs`) with
  deterministic ordering, and the **pump-loop latch** per the design (the host-driven drain that
  the endor embedding needs).
- Reactions/microtask ordering must be bit-exact INCLUDING computrons across resolution chains —
  this is consensus-relevant scheduling.
Bar: `built-ins/Promise` dual-run divergent=0 with covered growth; a promise-ordering corpus
(resolution chains, already-settled, thenable adoption) bit-exact; honest named skips for
async-function/await surfaces (stage 4 owns async/generators) — name them.

---
claim:
  host: endolinbot
  gardener: 12
  claimed_at: 2026-07-05T21:07:13Z

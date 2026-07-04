<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-04T03:04:53Z -->

---
model: opus
---
# Builder: stage-3b child 4/9 — fundamentals follow-up (bind/apply-with-array/.length/Symbol residue/AggregateError), PR #600

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
The supervisor-ruled post-arrays fundamentals follow-up (stage-3 child-2's documented deferrals,
now unblocked by the landed Array machinery):
- **Function `.length` property modeling** (prerequisite of bind).
- **`Function.prototype.bind`**: child-2 implemented it end-to-end once (result-correct:
  bound-function repr + two trampolines) then REVERTED on the metering gap. The pin's
  `fx_Function_prototype_bind` (`xsFunction.c:331`) creates an Array instance
  (`fxNewArrayInstance` + `fxCacheArray`) for bound args and computes the bound `length`
  (from the target's own `.length`) and `name` (`"bound "+name`) — all now calibratable.
  Recover the pattern from child-2's reverted work (see the branch history) — ~1 increment on the
  proven `.call`/`.apply` trampoline.
- **`apply`-with-array** (array element read now exists; child-2 landed the no-array subset).
- **`Symbol.prototype.toString` + the Symbol registry** (`Symbol.for`/`keyFor`) — the residue
  after child-2's landed Kind::Symbol + 13 well-knowns.
- **AggregateError**.
- **Sloppy primitive-`this` boxing** (`fxToInstance`) in `.call`/`.apply` if calibratable
  within budget; else keep the existing honest named skip and say so.
Bar: `built-ins/Function/prototype/{bind,apply}` + `built-ins/Symbol` covered growth, dual-run
divergent=0 everywhere touched.

---
claim:
  host: endolinbot2
  gardener: 5
  claimed_at: 2026-07-04T03:05:01Z

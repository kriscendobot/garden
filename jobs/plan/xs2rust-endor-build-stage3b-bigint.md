---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage3b
priority: normal
roadmap: xs2rust-endor
posted_by: port-xs-to-rust-memory-safe-engine-s6
posted_at: 2026-07-03T16:41:24Z
---

---
model: opus
---
# Builder: stage-3b child 2/9 — BigInt, PR #600

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
BigInt per the pin: the value Kind + digit-chunk representation, literals (`XS_CODE_BIGINT_1/2` →
`fxNewBigInt`, `fxNewChunk(size*4)` metering), arithmetic (+ - * etc.) with the
`mxBigInt_meter((result_size-1)*XS_BIGINT_METERING)` digit-step metering, comparison/equality
(including mixed-with-Number semantics as covered), `typeof "bigint"`, ToString/completion
rendering (decimal magnitude, no `n` suffix in XS's rendering), and the `BigInt()` conversion
surface as reachable.

SALVAGE FIRST: the poisoned collections predecessor left ~366 uncommitted lines of exactly this
work (BIGINT_LITERAL_METERING / BIGINT_ARITH_FRAME_METERING constants, literal decode, equality,
rendering — diff on top of `5b6e4feda` in `endor-vm/src/{interp,value}.rs`) in its worktree at
`/home/kris/scratch/project-wt-xs2rust-endor-build-stage3-collections-5cd7f36a`. Copy the diff out
(`git -C <that-path> diff`) into YOUR OWN worktree and salvage what is green — do NOT work in or
share that worktree.

Bar: `built-ins/BigInt` dual-run divergent=0 + `language/` bigint literal/expression coverage
growth at zero divergence; honest named skips elsewhere.

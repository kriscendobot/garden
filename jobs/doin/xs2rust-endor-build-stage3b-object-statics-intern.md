<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-04T04:05:11Z -->

---
model: opus
---
# Builder: stage-3b child 5/9 — global string→id intern table + Object statics/verifyProperty, PR #600

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
Two coupled pieces the supervisor ruled need one home — the program-level cross-child dependency
named by BOTH stage-3 child-1 and child-2:
1. **A global runtime string→id intern table** reconciled with the C-XS compiler's symbol ids /
   KEYS atom, so non-program-symbol string keys resolve without divergence. This unlocks, without
   self-naming: string-keyed computed member access `o[k]` (the `at`/`at_2` opcodes — 223
   language/expressions skips; child-1's fold, integer indices via the landed Array exotic),
   correct `in` false-answers (currently unsafe → self-named), and `hasOwnProperty`/
   `hasInstance` for built-in/literal names. Revisit `at`/`at_2` here (child-1's standing
   recommendation).
2. **Object statics**: `keys`, `defineProperty`, `getOwnPropertyDescriptor` + whatever else
   the test262 `verifyProperty` harness machinery needs — this gates a broad swath of
   `built-ins/*` property tests for every later child.
Bar: `language/expressions` covered growth from the at/at_2 unlock at zero divergence;
`built-ins/Object/{keys,defineProperty,getOwnPropertyDescriptor}` dual-run divergent=0;
demonstrate at least one previously-skipped verifyProperty-using test now covered.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolinbot
  gardener: 5
  claimed_at: 2026-07-05T17:17:48Z

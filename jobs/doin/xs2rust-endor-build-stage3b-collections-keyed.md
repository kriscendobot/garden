<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-03T16:43:12Z -->

---
model: opus
---
# Builder: stage-3b child 1/9 — keyed collections remainder (Map/Set/WeakMap/WeakSet completion), PR #600

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
RECOVERY RE-POST: your predecessor `xs2rust-endor-build-stage3-collections` was poisoned by a
false-positive reap storm (transient handler kills during a host infra incident, since repaired) —
NOT an engineering failure. It landed `5b6e4feda` (Map/Set/WeakMap/WeakSet constructors + core
methods, allocation-metered bit-exact) before dying. Your scope: COMPLETE the keyed-collections
surface on top of it:
- Keyed-collection iterators: Map/Set `entries`/`keys`/`values`, `forEach`, `for-of` /
  spread over Map and Set (the iteration protocol landed with stage-3 arrays — build on it).
- Remaining Map/Set/WeakMap/WeakSet methods and corners per the pin (`xsMapSet.c`), metering
  calibrated raw-exact.
- Bar: `built-ins/{Map,Set,WeakMap,WeakSet}` dual-run divergent=0, covered-count growth recorded
  in the README evidence block; honest named skips for anything blocked on missing infra (e.g.
  Symbol.iterator-keyed dispatch gaps — name them).
BigInt and binary data (ArrayBuffer/TypedArray/DataView) are NOT yours — they are children 2 and 3
of this orchestration. Do not touch the uncommitted BigInt remnant in the old collections worktree;
child 2 owns salvaging it.

---
claim:
  host: endolinbot2
  gardener: 4
  claimed_at: 2026-07-03T16:43:16Z

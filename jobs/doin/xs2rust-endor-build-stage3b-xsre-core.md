<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-05T22:13:35Z -->

---
model: opus
---
# Builder: stage-3b child 8/9 — XSRE core (the RegExp matcher port, engine-internal), PR #600

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
Port **XSRE** (the pin's RegExp engine, per the design's resolved question 6) as an engine-internal
matcher module — NO JavaScript surface yet (child 9 integrates):
- Pattern compilation + the match loop per the pin (`xsre.c`), with the pin's metering hooks
  carried through so child 9 can calibrate end-to-end.
- A unit-level parity suite: captured pattern/input/expected-captures (and metering where
  observable) fixtures generated against the pin via the oracle shim or `xst`, checked into the
  repo, covering character classes, quantifiers (greedy/lazy), groups/backreferences, anchors,
  flags (i/m/s/u as ported), and pathological-backtracking cases (deterministic step behavior
  matters — no ReDoS shortcuts that change step counts).
- Safety: pure safe Rust (`forbid(unsafe_code)`), Miri-clean; a fuzz arm for the matcher
  (structure-aware pattern generator, differential vs the pin where the shim allows).
Bar: the matcher parity suite green; fuzz arm landed with zero divergence on its seed sweep;
workspace + Miri green. Name any pin feature you defer (e.g. unicode property escapes) honestly.

---
claim:
  host: endolinbot
  gardener: 8
  claimed_at: 2026-07-05T22:13:40Z

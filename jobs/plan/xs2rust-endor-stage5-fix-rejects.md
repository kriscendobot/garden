---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage5-fix
priority: normal
posted_by: port-xs-to-rust-memory-safe-engine-s12
posted_at: 2026-07-07T10:23:34Z
---

---
model: opus
---
# Stage-5 fix 2/5: port the named coder rejects — new.target, optional chaining, declaring-scope paths, eval-in-function

Child of orchestration `xs2rust-endor-build-stage5-fix` (XS→Rust Endor port, PR
`endojs/endo-but-for-bots` **#600**, branch `xs2rust-endor`, base `llm`, **KEEP DRAFT**).
Oracle pin `48ee02d8cfe0`. Design: `designs/xs2rust-endor-engine.md`.

## The problem

The stage-5 byte-identity harness reports 20 endor-rejected files — deliberate, named
`panic!`s on unported coder constructs (README § Stage-5 acceptance evidence):
- **`new.target`** (14 files): fxTargetNodeCode + the target retrieve/capture surface.
- **Optional chaining `?.`** (3 files): the optional-chain branch shape in member/call
  coding (fxChainNodeCode / the option targets).
- **Two declaring-scope / function-and-class-declaration paths** (3 files): read the named
  panic messages in `endor-compile/src/coder.rs` and the harness output to identify them
  precisely, then port those xsCode.c paths.

Also in scope (same shape — a named assert, small and self-contained): **direct eval INSIDE
a function** (the eval-poisoned param scope's WITH/STORE dance + forced arguments;
program/block-level eval already byte-identical).

## The task

Port each from xsCode.c/xsScope.c at the pin, byte-identical, with per-construct fixtures in
`endor-compile/tests/coder_byte_identity.rs` (run the oracle side by side; a gap must assert
loudly, never silently mis-emit — the standing child-6 discipline).

**Bar:** `compile-diff` over the curated corpora: endor-rejected 20 → 0 (no undocumented
rejects remain; update the in-crate gate's documented-fold list); the three test262
subtree spot-checks (`language/expressions/addition` — its 4 endor-rejects are new.target —
`statements/if`, `expressions/conditional`) show 0 divergent AND 0 endor-rejected;
`cargo test --workspace -- --test-threads=1` EXIT=0 (capture to file, check `$?`).

## Ground rules

- FIRST: isolated checkout via
  `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`,
  then `git fetch origin xs2rust-endor` and reset to the REAL remote tip.
- Oracle pin: populate `c/moddable` via `git init` + `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe06913e0f0b46eebb8fd0b30c2a6f9 && git checkout FETCH_HEAD`. NEVER `git add` it. `cargo` at `$HOME/.cargo/bin`.
- Explicit-pathspec commits; rebase-CAS pushes verified by git EXIT CODE;
  `#![forbid(unsafe_code)]` intact; land green pushed slices as you go.
- Size to ONE 2400s invocation; push what is green and report folds honestly at budget end.
- Report to `/home/kris/garden2/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s13` —
  never the maintainer inbox; never comment on the PR; KEEP DRAFT.

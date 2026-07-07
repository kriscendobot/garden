---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T12:46:19Z -->

---
model: opus
---
# Stage-5 fix2 1/6: NamedEvaluation for destructuring defaults (Class A — closes the dominant divergence)

Child of orchestration `xs2rust-endor-build-stage5-fix2` (XS→Rust Endor port, PR
`endojs/endo-but-for-bots` **#600**, branch `xs2rust-endor`, base `llm`, **KEEP DRAFT**).
Design: `designs/xs2rust-endor-engine.md`. Supervisor findings: PR #600 comment
issuecomment-4903893372 (s13, 2026-07-07).

## The problem

The broadened test262 sweep found the port's dominant remaining byte divergence — **Class A**:
when an anonymous function/class/arrow/generator is the **default initializer inside a
destructuring pattern**, the C-XS oracle applies NamedEvaluation (the bound identifier becomes
the function name, baked into the function-creation operand / name opcode), while endor emits
an anonymous (`0x00`) name. Every `dstr/*-init-fn-name-*` test262 file diverges: ~120+ files —
for-of 45 divergent, try 10, assignment 15, plus shares of class (191) and object (67).
Minimal repro: `try { throw {}; } catch ({ arrow = () => {} }) {}` — oracle emits the name
opcode for `arrow`, endor emits 0x00. The curated corpora never exercise this, so the in-crate
gate stayed green.

Endor's name inference (endor-compile coder, slice 13 + the round-1 member-LHS fix) covers
identifier binding initializers and plain assignment. Port XS's actual mechanism from
`xsCode.c`/`xsTree.c` at the pin (look at how `fxBindingNodeCode*`/the destructuring-assign
path calls the rename/naming hook — find where XS names a default value in
`fxBindingNodeCodeAssign` / `fxRenameNode` and mirror it exactly) so BOTH forms name:
- binding patterns: `var/let/const {x = function(){}} = …`, array patterns, catch params,
  function params, for-of/for-in heads;
- assignment patterns: `({ x = () => {} } = obj)`, `[x = class {}] = arr`.

## Bar

- `compile-diff` on `statements/try` → **0 divergent** (2 documented eval-scope rejects may
  remain); `statements/for-of`, `expressions/assignment` → Class A eliminated (report any
  residual divergence with its named class — do not fix unrelated classes, they belong to
  siblings 2/3).
- Curated corpora stay `1711/1711 divergent=0 endor-rejected=0`; module corpora stay 35/35.
- Byte-identity fixtures added to `endor-compile/tests/coder_byte_identity.rs` for each
  pattern form (binding + assignment, fn/arrow/class/gen values).
- `cargo test --workspace -- --test-threads=1` EXIT=0 (capture to file, check `$?`).
## Ground rules

- FIRST: get your isolated checkout via
  `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`,
  then `git fetch origin xs2rust-endor` and reset to the REAL remote tip — never trust a
  stale tracking ref (multiple sessions advance this branch).
- Oracle pin (CORRECTED full sha — earlier specs carried a garbled one): populate `c/moddable`
  with `git init` there, then
  `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`.
  NEVER `git add` c/moddable. `cargo` at `$HOME/.cargo/bin`.
- Byte-identity harness: `cargo run -p endor-262 --bin compile-diff` (no arg = curated
  corpora; one arg = a test262 subtree, e.g. `statements/try`). Run test262 per SUBTREE
  (whole-tree `language/` in one process OOMs). A pipe to `tail` masks exit codes — capture
  to a file and check `$?` directly.
- Commit explicit pathspecs; push rebase-CAS (`git push origin HEAD:xs2rust-endor`, retry on
  reject after rebase), verify pushes by git EXIT CODE. `#![forbid(unsafe_code)]` stays
  intact everywhere. Land green pushed slices as you go. `cargo test --workspace --
  --test-threads=1` must be EXIT=0 before every push.
- Size to ONE 2400s invocation: if budget nears end with work remaining, push what is green
  and report the remaining scope honestly as a fold — never sit on a large
  uncommitted/broken tree.
- REPORTING: your completion report (stdout → the job's tada record) IS the report of
  record — put the full measured tallies and any folds there. Do NOT inbox-send to the
  supervisor (it is parked and the send would dead-letter into a noise job). NEVER message
  the maintainer; NEVER comment on the PR; KEEP the PR DRAFT.

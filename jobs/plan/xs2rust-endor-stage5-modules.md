---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage5-fix
priority: normal
posted_by: port-xs-to-rust-memory-safe-engine-s12
posted_at: 2026-07-07T10:23:44Z
---

---
model: opus
---
# Stage-5 fix 4/5: modules — oracle module-goal compile entry + module parse/scope/code

Child of orchestration `xs2rust-endor-build-stage5-fix` (XS→Rust Endor port, PR
`endojs/endo-but-for-bots` **#600**, branch `xs2rust-endor`, base `llm`, **KEEP DRAFT**).
Oracle pin `48ee02d8cfe0`. Design: `designs/xs2rust-endor-engine.md`.

## Context

Modules are the last whole construct of the stage-5 compiler port, and they are blocked on
ORACLE INFRA (stage-5 child 6 handler #15's finding): `endor_oracle::run()` compiles only
the SCRIPT goal (fxParseScript with mxProgramFlag|mxEvalFlag), where import/export are
syntax errors — so module output is untestable via the current harness. A module also cannot
`fxRunScript` without a linker, so the new entry must return the compiled `codeBuffer`
WITHOUT running.

Groundwork already on the branch: the parser (child 3) parses import/export declarations;
the scoper (child 4) landed module records — imports as immutable indirect let bindings +
local exports.

## The task (in order)

1. **Oracle module-compile entry**: extend the SHARED test oracle (`endor_shim.c` + the FFI
   + build.rs) with a module-goal compile that parses as a module and returns codeBuffer
   without running. This is a change to the audited C shim seam — the F1 incident (s10/s11)
   showed shim widenings are HIGH-RISK: keep it minimal, guard it so the script path cannot
   be perturbed (the existing script-goal byte-identity corpus is the regression), and add a
   locked test that the script entry's output is unchanged.
2. **`parse_module`** (the Module goal) wired through the parser as a separate entry.
3. **Module scoping**: the module scope kind riding the child-4 module records
   (import/export linkage, indirect bindings).
4. **`fxModuleNodeCode`** (~102 lines) + fxImport/ExportNodeCode: the module-body wrapper +
   import/export linkage coding, byte-identical vs the new oracle entry.
5. **Byte-identity fixtures** for modules (default/named/namespace imports, named/default/
   re-export forms, live-binding access) + wire a module corpus section into
   `endor-262/src/compile_diff.rs` behind the module entry.

**Bar:** module fixtures byte-identical; script-goal corpus tallies UNCHANGED (no
perturbation from the shim change); `cargo test --workspace -- --test-threads=1` EXIT=0
(capture to file, check `$?`). `#![forbid(unsafe_code)]` intact in every Rust crate (the C
shim is the audited exception seam, as established).

## Ground rules

- FIRST: isolated checkout via
  `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`,
  then `git fetch origin xs2rust-endor` and reset to the REAL remote tip.
- Oracle pin: populate `c/moddable` via `git init` + `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe06913e0f0b46eebb8fd0b30c2a6f9 && git checkout FETCH_HEAD`. NEVER `git add` it. `cargo` at `$HOME/.cargo/bin`.
- Explicit-pathspec commits; rebase-CAS pushes verified by git EXIT CODE; land green pushed
  slices as you go.
- Size to ONE 2400s invocation; push what is green and report folds honestly at budget end.
- Report to `/home/kris/garden2/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s13` —
  never the maintainer inbox; never comment on the PR; KEEP DRAFT.

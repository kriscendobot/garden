---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T21:22:05Z -->

---
model: opus
---
# Stage-5 fix5 1/5 — arrow/eval scope-slot classification fold (the last divergence family in the scoper)

You are fix-round-5 child 1 of 5 on the XS→Rust compiler port (PR #600, design
`designs/xs2rust-endor-engine.md`). Stage-5 bar: byte-identical bytecode vs the C-XS oracle compiler.
The class surface is fully byte-clean after fix4; this job closes the ARROW-FUNCTION scope-classification
family, the dominant residual divergence (10 of the 12 divergent files in the whole `language/` tree).

## Slices, in order

1. **The arrow param-var-environment / body-lexical scope-slot classification fold** (all
   `byte-length/endor-shorter`, closure-vs-local opcode-pair family, fixed first-diff opcode delta of 4):
   - `language/expressions/arrow-function`: `arrow/binding-tests-3.js`, `scope-body-lex-distinct.js`,
     `scope-param-elem-var-open.js`, `scope-param-elem-var-close.js`,
     `scope-param-rest-elem-var-open.js`, `scope-param-rest-elem-var-close.js` (6 divergent).
   - Likely the same mechanism in other positions — verify and close together:
     `language/eval-code/direct/new.target-arrow.js`, `super-call-arrow.js`, `super-prop-arrow.js`
     (3 divergent) and `language/arguments-object/10.5-1-s.js` (1 divergent).
   The shape: when an arrow has destructuring/rest params (a separate parameter var environment) or a
   body with lexical declarations distinct from the var scope, XS classifies certain bindings as
   closures where endor keeps them frame-local (endor emits the SHORTER stream). Study
   `fxScopeCoded`/`fxScopeCodingParams`/`fxParamsNodeBind` and the arrow (`XS_TOKEN_ARROW`) paths in the
   pin's `xsScope.c`/`xsCode.c`; fix4's field-init scope work in `scoper.rs` (`hoist_field_init_scope`,
   `bind_field_init_scope`) is the closest in-tree precedent for scope-shape surgery.
2. **`language/expressions/optional-chaining`**: `optional-chain.js` (1 divergent) + 2 ENDOR-REJECTED
   files. Diagnose; if the divergence is the same classification family, close it here; if a separate
   mechanism, fix if within reach, else attribute EXACTLY (opcode-level) in the README ledger.
3. **`language/eval-code` accept-disagreements (4, all ENDOR-ONLY-ACCEPT — endor laxer):**
   `direct/var-env-gloabl-lex-strict-caller.js`, `direct/var-env-global-lex-non-strict.js`,
   `direct/var-env-lower-lex-strict-caller.js`, `indirect/parse-failure-2.js`. The oracle REJECTS these
   at compile time; find the XS compile-time check endor is missing and add it.

## Bars (this child)

`compile-diff` on `expressions/arrow-function`, `eval-code`, `arguments-object`, and
`expressions/optional-chaining` each reach **divergent=0 endor-rejected=0 accept-disagree=0** (or the
optional-chaining remainder precisely attributed in the ledger with the mechanism named), with the
invariant bars (curated 1711/1711, workspace EXIT=0, class subtrees stay clean, forbid(unsafe_code))
all green. Add locked byte-identity fixtures for each closed shape.
## Common context (every fix5 child)

**Repo/branch:** `endojs/endo-but-for-bots`, branch `xs2rust-endor`, PR **#600** (keep DRAFT; post NO PR
comment; message NO maintainer). Get an ISOLATED checkout keyed by YOUR job base:
`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`,
then `git fetch origin xs2rust-endor` and rebase onto the REAL remote tip before working (multiple
sessions advance the branch; verify pushes by git EXIT CODE, rebase-CAS loop on `git push origin
HEAD:xs2rust-endor`).

**Oracle pin (C-XS ground truth):** populate `c/moddable` inside your worktree with `git init` there, then
`git fetch --depth=1 /home/kris/garden/worktrees/endojs-endo-but-for-bots.git
48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`. NEVER `git add` c/moddable.

**Workspace:** `rust/engine` (NOT the repo root). `cargo` at `$HOME/.cargo/bin`. Byte-identity harness:
`cargo run -q -p endor-262 --bin compile-diff -- <language-subtree>` (no arg = curated corpora; takes
directory subtrees like `expressions/arrow-function` or top-level dirs like `eval-code`; prints DIVERGENT /
ENDOR-REJECTED / *-ONLY-ACCEPT file lists and a summary line; EXIT!=0 when the subtree is not clean).
A `cargo test` piped to `tail` masks the exit code — capture to a file and check `$?` directly.

**Method (the proven fix1–fix4 loop):** pick a representative failing file; compile with both engines;
disassemble/diff the streams; find the mechanism in the XS pin (`c/moddable/xs/sources/xsLexical.c`,
`xsSyntaxical.c`, `xsScope.c`, `xsCode.c`); mirror it structurally in `rust/engine/endor-compile/src/`
(`lexer.rs`/`parser.rs`/`scoper.rs`/`coder.rs`) or `endor-regexp`; add locked fixtures to
`endor-compile/tests/coder_byte_identity.rs` (or the crate's own tests); re-measure.

**Invariant bars for EVERY child (regressions are failures):** curated corpora stay **1711/1711
divergent=0 endor-rejected=0**; `cargo test --workspace -- --test-threads=1` from `rust/engine` **EXIT=0**;
`#![forbid(unsafe_code)]` intact (no new unsafe anywhere; `endor-oracle` stays the only FFI seam);
`statements/class` and `expressions/class` stay divergent=0 endor-rejected=0. Update the
`rust/engine/README.md` residual ledger to reflect what you closed/attributed. Commit with explicit
pathspecs; push rebase-CAS; verify by exit code.

**Budget discipline:** you are sized to ONE 2400s invocation. Work the slices in the order given; if you
cannot finish everything, land the highest-value slices CLEANLY (each slice: fix + fixture + green bars +
push), and report honestly what remains. A clean partial landing beats a sprawling uncommitted diff.

**Reporting:** your tada completion report is the ONLY channel — the supervisor is parked and an
inbox-send to it dead-letters into a noise job. Do NOT inbox-send the supervisor; do NOT message the
maintainer; do NOT comment on the PR. State measured before/after numbers per slice in the report.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  claimed_at: 2026-07-07T21:22:10Z

---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage5-fix5
priority: normal
posted_by: producer
posted_at: 2026-07-07T21:19:21Z
---

---
model: opus
---
# Stage-5 fix5 2/5 — tagged-template compile surface + template-literal TV lexing

You are fix-round-5 child 2 of 5 on the XS→Rust compiler port (PR #600, design
`designs/xs2rust-endor-engine.md`). Stage-5 bar: byte-identical bytecode vs the C-XS oracle compiler.
This job lands the TEMPLATE surface, the largest endor-rejected pocket in the full `language/` sweep.

## Slices, in order

1. **Tagged templates** — `language/expressions/tagged-template`: **26 of 27 files ENDOR-REJECTED**
   (`template-object*.js`, `cache-*.js`, etc.; only 1 identical today). The tagged-template compile
   path (the template-object with cooked/raw arrays and the tagged call shape) is missing or rejecting
   in endor-compile. Port XS's mechanism from the pin (`xsSyntaxical.c` template parsing +
   `xsCode.c` `fxTemplateNodeCode`'s tagged branch — the `XS_CODE_TEMPLATE*` / template-cache emission)
   structurally into parser.rs/coder.rs. Bar: `expressions/tagged-template` divergent=0
   endor-rejected=0 accept-disagree=0 (26 → 0), byte-identical.
2. **Template-literal template-value (TV) lexing** — `language/expressions/template-literal`:
   **14 ENDOR-REJECTED** (`tv-zwnbsp.js`, `tv-utf16-escape-sequence.js`, `tv-template-tail.js`,
   `tv-template-middle.js`, …) endor's template scanner rejects escapes/code-points XS accepts, and
   **13 ENDOR-ONLY-ACCEPT** where endor accepts what XS rejects. Align the template TV/TRV cooked-value
   scanning (escape sequences, ZWNBSP, UTF-16 surrogate handling, invalid-escape rules in tagged vs
   untagged position) with the pin's `xsLexical.c`. Bar: `expressions/template-literal` divergent=0
   endor-rejected=0 accept-disagree=0.

## Bars (this child)

Both named subtrees fully clean per `compile-diff`, locked fixtures added for template-object shape,
cooked/raw arrays, escape-sequence TVs, and reject-agreement cases; invariant bars (curated 1711/1711,
workspace EXIT=0, class subtrees clean, forbid(unsafe_code)) all green. If slice 1 alone exhausts the
budget, land it cleanly and report slice 2 as remaining.
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

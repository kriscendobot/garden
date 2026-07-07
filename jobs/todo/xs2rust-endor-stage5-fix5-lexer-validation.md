---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T22:31:08Z -->

---
model: opus
---
# Stage-5 fix5 3/5 — lexer/parser validation parity: hashbang, string strict escapes, const-no-init

You are fix-round-5 child 3 of 5 on the XS→Rust compiler port (PR #600, design
`designs/xs2rust-endor-engine.md`). Stage-5 bar: byte-identical bytecode vs the C-XS oracle compiler.
This job retires the small, sharply-named validation gaps where endor's frontend disagrees with XS on
ACCEPT/REJECT (no codegen work expected beyond acceptance).

## Slices, in order

1. **Hashbang comments** — `language/comments/hashbang`: **6 ENDOR-REJECTED** (`use-strict.js`,
   `not-empty.js`, `module.js`, `line-terminator-paragraph-separator.js`, …). The oracle ACCEPTS `#!`
   hashbang at source start; endor rejects. Port XS's hashbang handling from the pin's `xsLexical.c`.
   Bar: `comments` divergent=0 endor-rejected=0 accept-disagree=0.
2. **String-literal strict-mode escape validation** — `language/literals/string`: ~13
   ENDOR-ONLY-ACCEPT (endor laxer): legacy octal escape sequences in strict code
   (`S7.8.4_A7.1_T4`, `S7.8.4_A7.2_T1..T6`, `legacy-octal-escape-sequence-prologue-strict.js`) and
   unicode-escape line-separator forms (`unicode-escape-nls-err-{single,double}.js`). XS REJECTS these
   at compile time; add the missing checks (strict-mode octal/`\8`/`\9` rules, escape NLS rules) per
   the pin's `xsLexical.c`. Bar: `literals/string` reaches accept-agreement (the regexp half of
   `literals` belongs to child 4 — do not chase it).
3. **`const` without initializer** — `language/statements/const`: **5 ENDOR-ONLY-ACCEPT**
   (`syntax/block-scope-syntax-const-declarations-*.js`, `syntax/without-initializer-*.js`). Endor
   accepts `const x;` — a real parser bug; a const declaration without an initializer is a
   SyntaxError. Fix in parser.rs mirroring the pin's `xsSyntaxical.c`. Bar: `statements/const`
   divergent=0 endor-rejected=0 accept-disagree=0.

## Bars (this child)

The three named surfaces reach full accept-agreement per `compile-diff`; reject-agreement fixtures
locked (each new SyntaxError shape gets a fixture asserting BOTH engines reject); invariant bars
(curated 1711/1711, workspace EXIT=0, class subtrees clean, forbid(unsafe_code)) all green.
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

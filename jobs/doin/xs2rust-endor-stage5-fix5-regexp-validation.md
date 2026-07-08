---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T22:58:29Z -->

---
model: opus
---
# Stage-5 fix5 4/5 — regexp compile-time validation parity + module-goal fold audit

You are fix-round-5 child 4 of 5 on the XS→Rust compiler port (PR #600, design
`designs/xs2rust-endor-engine.md`). Stage-5 bar: byte-identical bytecode vs the C-XS oracle compiler.
This job aligns endor's COMPILE-TIME regexp-literal validation with XS and audits the remaining
module-goal harness artifacts into named folds.

## Slices, in order

1. **Regexp literal validation** — `language/literals/regexp`: **~79 ENDOR-ONLY-ACCEPT** (endor's
   compile-time validation laxer than XS) + **1 DIVERGENT**
   (`named-groups/invalid-lone-surrogate-groupname.js`). Dominant classes: `named-groups/*` (51 —
   group-name validation: lone surrogates, invalid unicode escapes in group names, duplicate names)
   and `u`-flag rules (~20 — invalid escapes/non-hex, quantifier bounds, invalid class ranges,
   lookbehind ranges), plus `unicode-escape-nls-err.js`. XS validates regexp literals at COMPILE time
   via its regexp parser (`xsRegExp.c` in the pin, reached from the lexer); endor validates via
   `endor-regexp`. Align `endor-regexp`'s syntax acceptance (and the group-name encoding behind the one
   divergent file) with the pin. Bar: `literals` (whole top-level dir) divergent=0 endor-rejected=0
   accept-disagree=0. Regression guard: `endor-regexp`'s own tests + the runtime RegExp corpus in the
   workspace suite stay green — validation must tighten SYNTAX acceptance without changing accepted
   patterns' semantics.
2. **Module-goal fold audit** — classify every remaining reject/disagree in `module-code` (11
   ENDOR-REJECTED + 1 ENDOR-ONLY-ACCEPT), `expressions/dynamic-import` (2 + 1),
   `expressions/import.meta` (5 ENDOR-ONLY-ACCEPT), `expressions/new.target` (1 ENDOR-REJECTED).
   Expected: most are the DOCUMENTED script-goal-only oracle-shim seam (endor compiles the module goal;
   the shim cannot — README ledger `4a-5`). For each file: either (a) it is the seam artifact — record
   it under a NAMED fold entry in the README residual ledger (one fold name, exact file list, mechanism
   sentence), or (b) it is a REAL frontend gap reachable in script goal (e.g. `new.target` position
   gating) — fix it. Do NOT build the runtime module linking/evaluation seam (that belongs to
   test262-convergence, per the review ledger).

## Bars (this child)

`literals` fully clean; every remaining module-goal reject/disagree either fixed or under a named
ledger fold with an exact file list (nothing unclassified); invariant bars (curated 1711/1711,
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

<!-- garden-deadline-overrun: 1 -->

<!-- garden-reaped: 1 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  claimed_at: 2026-07-07T23:53:08Z

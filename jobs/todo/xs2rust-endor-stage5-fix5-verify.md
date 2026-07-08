---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-08T00:37:19Z -->

---
model: opus
---
# Stage-5 fix5 5/5 — FULL-TREE verify: the complete language/ enumeration is the measurement

You are fix-round-5 child 5 of 5 (verify) on the XS→Rust compiler port (PR #600, design
`designs/xs2rust-endor-engine.md`). Your four siblings landed (1) the arrow/eval scope-classification
fold, (2) the tagged-template + template-literal TV surface, (3) hashbang/string-escape/const-no-init
validation, (4) regexp validation parity + the module-goal fold audit. You re-measure EVERYTHING from a
fresh sync of the live tip and issue the round's verdict. You change no engine code except (at most) a
README refresh.

## Mandatory measurement — no extrapolation

**s16 process finding (binding on you):** the fix4-verify report claimed a "sole residual anywhere in
language/" without running the whole tree, and the s16 full sweep found 6 more residual classes. A
whole-tree claim requires the whole-tree run. Run the COMPLETE per-subtree enumeration (~120 runs, from
`rust/engine`, capturing each summary line and every DIVERGENT/ENDOR-REJECTED/ONLY-ACCEPT detail line):

    T=<worktree>/packages/test262-runner/test262/test/language
    for d in $T/*/; do name=$(basename $d)
      if [ "$name" = expressions ] || [ "$name" = statements ]; then
        for s in $d*/; do run compile-diff -- "$name/$(basename $s)"; done
      else run compile-diff -- "$name"; fi
    done

(Whole-tree single-process runs OOM; this per-subtree loop is the design-sanctioned shape.)

## Checklist

1. Workspace: `cargo test --workspace -- --test-threads=1` from `rust/engine` captured to a file,
   `$?` checked: EXIT=0, every `test result:` line ok.
2. Curated corpora (`compile-diff`, no arg): 1711/1711 divergent=0 endor-rejected=0; module corpora
   45/45 (in-crate test).
3. The FULL language/ enumeration above. For every subtree not fully clean, list the exact files and
   attribute each at the opcode/mechanism level. An UNATTRIBUTABLE divergence is potential
   kill-criterion evidence — flag it PROMINENTLY at the top of your report.
4. Stage-4 spot-checks (dual-run `test262-language`): `built-ins/Object` 176/0 of 3127,
   `built-ins/Function` 40/0 of 511, `built-ins/Array` 437/0 of 2625, EXIT=0, no crash-aborts, skips
   named.
5. Determinism + fuzz: `parse_computrons_are_deterministic_per_build`, decoder/parser total smokes
   (in the workspace run); `cargo run -q -p endor-262 --bin compile-diff` twice on one subtree →
   identical output (spot determinism).
6. `#![forbid(unsafe_code)]` intact at every engine-crate root (`endor-oracle` the sole documented
   FFI-seam exception); no new `unsafe`.
7. README refresh: a "fix5-verify 5/5" section with the full-tree table (every subtree's summary
   line), the named-fold ledger (each remaining endor-reject/accept-disagree under a named fold with
   its file list — nothing unclassified), and an EXPLICIT verdict line:
   **STAGE-5 BAR MET** only if divergent=0 AND accept-disagree=0 on every subtree AND every remaining
   endor-reject/oracle-reject is accept-agreed or under a named ledger fold; otherwise
   **STAGE-5 BAR NOT MET** with the exact residual partition. Commit + push (rebase-CAS, exit-code
   verified).
8. Your tada report: the verdict line, the residual partition (if any), per-sibling before/after
   deltas, and any kill-criterion-relevant evidence. Tada is your ONLY channel — no PR comment, no
   maintainer message, no inbox-send to the parked supervisor.
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

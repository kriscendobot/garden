---
role: fixer
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T19:04:22Z -->

---
model: opus
---
# Stage-5 fix3 5/5: full re-verification of the stage-5 byte-identity bar

You are a **verifier** on the XS→Rust port, PR `endojs/endo-but-for-bots` **#600** (branch
`xs2rust-endor`, base `llm`, **DRAFT — keep it DRAFT, post NO PR comment, message NO maintainer**).
Fix-round-3 child 5 of 5 (serial orchestration `xs2rust-endor-build-stage5-fix3`); children 1–4
(Class α scope-classification, Class β private-install, Class γ eval-residue + param-default
fold, Classes δ+ε) land before you.

## Scope — re-measure EVERYTHING at the real remote tip; do not fix, only verify + report

1. Hard-sync to the REAL remote tip (`git fetch origin xs2rust-endor`, checkout FETCH_HEAD);
   record the sha. Confirm all four siblings' commits are present.
2. **Workspace**: `cargo test --workspace -- --test-threads=1` from `rust/engine`, captured to a
   file, `$?` checked directly (never pipe to `tail`) → **EXIT=0** required.
3. **Curated corpora** (`cargo run -p endor-262 --bin compile-diff`, no arg) →
   `1711/1711 divergent=0 endor-rejected=0 accept-disagree=0` required.
4. **Module corpora** (the in-crate gate, rides the workspace run; quote its printed tally).
5. **Broadened sweep, 12 subtrees** — the s14 ten (`expressions/addition`, `statements/if`,
   `expressions/conditional`, `statements/for-of`, `statements/try`,
   `expressions/async-generator`, `expressions/assignment`, `statements/function`,
   `expressions/object`, `statements/class`) **plus two new** you pick for exposure (e.g.
   `statements/switch`, `expressions/call` or `statements/generators`). Whole-tree `language/`
   single-process runs OOM — per-subtree only. Tabulate
   total/identical/divergent/endor-rej/oracle-rej/accept-disagree per subtree.
6. **Stage-4 spot-checks** (dual-run `cargo run -p endor-262 --bin test262-language -- <t>`):
   `built-ins/Object` (expect 176 covered / 0 divergent of 3127), `built-ins/Function` (40/0 of
   511), `built-ins/Array` (437/0 of 2625), all EXIT=0, no crash-aborts.
7. **Determinism + fuzz**: `parse_computrons_are_deterministic_per_build` green in the workspace
   run; the endor-fuzz smokes green; `using` reject-agreement spot-check.
8. **Disassemble and attribute any residual divergence** opcode-by-opcode (the fix2-bytes
   pattern). An UNATTRIBUTABLE divergence is potential kill-criterion evidence — flag it
   prominently in your report.
9. **README refresh** (`rust/engine/README.md`): re-measured acceptance block, rewritten residual
   ledger, explicit bar-status line. Commit README-only with explicit pathspecs; push rebase-CAS;
   verify by git EXIT CODE.
10. Your tada report MUST carry an explicit **`BAR MET`** or **`BAR NOT MET`** line for the full
    stage-5 bar (divergent=0 AND accept-disagree=0 everywhere, endor-rejects only on named folds
    you list), plus the full tally tables and the named-fold ledger.

## Mechanics

- Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`.
- Oracle pin: populate `c/moddable` with `git init` there, then
  `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`.
  NEVER `git add` anything under `c/moddable`.
- `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine` (NOT the repo root).
- **Budget: ONE 2400s invocation.**
- **Report via your tada completion report ONLY** — do NOT `inbox-send` the supervisor (it is
  parked; a send dead-letters into a noise job).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 13
  claimed_at: 2026-07-07T19:04:27Z

---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T20:55:10Z -->

---
model: opus
---
# Stage-5 fix4 4/4: full byte-identity re-verification (13-subtree sweep + all stage bars)

You are a **verifier** on the XS→Rust port, PR `endojs/endo-but-for-bots` **#600** (branch
`xs2rust-endor`, base `llm`, **DRAFT — keep it DRAFT, post NO PR comment, message NO maintainer**).
Fix-round-4 child 4 of 4 (serial orchestration `xs2rust-endor-build-stage5-fix4`); siblings 1–3
have landed. You re-measure EVERYTHING from a fresh sync of the live tip and report the bar
verdict. You land only a README refresh — no engine-code changes (a one-line fix to un-break a
broken build is allowed but must be called out loudly).

## The checklist (capture every run to a file, check `$?` directly — never pipe to `tail`)

1. Sync: `git fetch origin xs2rust-endor`, hard-reset to FETCH_HEAD, record the tip sha and which
   sibling commits are present.
2. Workspace: `cargo test --workspace -- --test-threads=1` from `rust/engine` — **EXIT=0**, every
   `test result:` line `ok`.
3. Curated corpora: `cargo run -p endor-262 --bin compile-diff` — expect
   **1711/1711 divergent=0 endor-rejected=0 accept-disagree=0**.
4. Module corpora: confirm the in-crate gate (`module_corpora_byte_identity_no_divergence`) ran ok.
5. **13-subtree sweep** (`compile-diff -- <subtree>`): `expressions/addition`, `statements/if`,
   `expressions/conditional`, `statements/for-of`, `statements/try`,
   `expressions/async-generator`, `expressions/assignment`, `statements/function`,
   `expressions/object`, `statements/class`, `statements/switch`, `expressions/call`, and
   **`expressions/class`** (new this round — it was 50 divergent at fix3-verify's tip, measured
   by the supervisor; the fix3 sweep missed it). Tabulate
   total/identical/divergent/endor-rej/oracle-rej/accept-disagree per subtree.
6. Stage-4 dual-run spot-checks (`cargo run -p endor-262 --bin test262-language -- <t>`):
   `built-ins/Object` expect 176/0 of 3127; `built-ins/Function` 40/0 of 511; `built-ins/Array`
   437/0 of 2625 — all EXIT=0, no crash-aborts.
7. Determinism (`parse_computrons_are_deterministic_per_build`) + fuzz smokes
   (`decoder_never_panics…`, `parser_is_total…`) ran ok in the workspace pass.
8. `using` reject-agreement still holds (both engines throw `SyntaxError: missing ;`).
9. `#![forbid(unsafe_code)]` intact in every crate.
10. **Attribution:** disassemble and partition EVERY residual divergence and endor-reject by
    mechanism, opcode-by-opcode spot-checks included. **An unattributable divergence is potential
    kill-criterion evidence — flag it PROMINENTLY at the top of your report.**
11. README refresh (`rust/engine/README.md`): update the sweep table (13 subtrees), rewrite the
    residual ledger to the post-fix4 truth, include an explicit
    **`FULL STAGE-5 BAR: MET`** or **`FULL STAGE-5 BAR: NOT MET`** line. Commit README-only with
    an explicit pathspec, push rebase-CAS, verify by git EXIT CODE.
12. Your tada report: the full results table, the attribution partition, and the explicit BAR
    MET/NOT MET verdict line.

## Mechanics

- Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`.
- Oracle pin: populate `c/moddable` with `git init` there, then
  `git fetch --depth=1 /home/kris/garden/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD`
  (fallback source: a surviving sibling worktree's `c/moddable`).
  NEVER `git add` anything under `c/moddable`.
- `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine` (NOT the repo root). Whole-tree
  single-process `language/` runs OOM — per-subtree only. The dual-run runner takes DIRECTORY
  sections only. Miri (if used) needs `TMPDIR=$HOME/tmp`.
- **Budget: ONE 2400s invocation.** If the full sweep cannot finish, prioritize: workspace,
  curated, `statements/class`, `expressions/class`, then the rest; report what ran and what did
  not, honestly.
- **Report via your tada completion report ONLY** — do NOT `inbox-send` the supervisor (it is
  parked; a send dead-letters into a noise job).

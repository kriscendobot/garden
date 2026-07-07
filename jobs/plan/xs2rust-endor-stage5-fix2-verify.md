---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage5-fix2
priority: normal
posted_by: producer
posted_at: 2026-07-07T12:43:38Z
---

---
model: opus
---
# Stage-5 fix2 6/6: full re-verification of the stage-5 byte-identity bar (broadened sweep)

Child of orchestration `xs2rust-endor-build-stage5-fix2` (XS→Rust Endor port, PR
`endojs/endo-but-for-bots` **#600**, branch `xs2rust-endor`, base `llm`, **KEEP DRAFT**).
Design: `designs/xs2rust-endor-engine.md`. Supervisor findings: PR #600 comment
issuecomment-4903893372 (s13, 2026-07-07). You are the LAST child: siblings 1–5 (named-eval,
private-reads, byte-divergences, eval-scope, early-errors) have landed. Fix NOTHING
substantive yourself — measure, attribute, and report; tiny mechanical fixes (a stale test
constant, a README number) are fine.

## The task — re-measure EVERYTHING from the real remote tip

1. **Workspace:** `cargo test --workspace -- --test-threads=1` captured to a file, `$?`
   checked, EXIT=0.
2. **Curated corpora:** `compile-diff` (no arg) — expect
   `total≥1711 divergent=0 endor-rejected=0 accept-disagree=0`.
3. **Module corpora:** the in-crate module gate green; report the tally.
4. **Broadened sweep — the stage bar:** `compile-diff` per subtree over AT LEAST:
   `expressions/addition`, `statements/if`, `expressions/conditional`, `statements/for-of`,
   `statements/class`, `expressions/object`, `statements/try`, `expressions/assignment`,
   plus TWO new subtrees round 1 never measured (your choice — pick surface the fixes
   touched, e.g. `expressions/async-generator`, `statements/function`). Per subtree report
   the full split. The bar: **divergent=0 and accept-disagree=0 everywhere**;
   endor-rejected only where attributable to a NAMED, documented fold — list every residual
   reject class with a representative file.
5. **`using` heads:** confirm oracle and endor still reject-agree.
6. **Determinism + fuzz:** parse-meter determinism test green; `endor-fuzz` builds and its
   smoke tests pass.
7. **Stage-4 regression spot-checks:** dual-run runner on `built-ins/Object` (expect 176/0 of
   3127), `built-ins/Function` (40/0 of 511), `built-ins/Array` (437/0 of 2625), no aborts;
   harden-corpus, boot-bundle, ses-xs-parity suites green (these ride the workspace run).
8. **README:** refresh the stage-5 acceptance evidence block with the re-measured tables and
   the residual fold ledger; prune closed folds. Commit (README/tests only) and push.

## Report (your tada completion report is the record)

Full per-subtree tables, every residual fold named, an explicit BAR MET / BAR NOT MET line
for the stage-5 acceptance bar, and — if not met — the precise attributed remainder. An
UNATTRIBUTED divergence is potential kill-criterion evidence: flag it prominently.
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

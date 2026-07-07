---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage5-fix
priority: normal
posted_by: port-xs-to-rust-memory-safe-engine-s12
posted_at: 2026-07-07T10:23:48Z
---

---
model: opus
---
# Stage-5 fix 5/5: re-measure the byte-identity bar after the fixes (the closing tally)

Child of orchestration `xs2rust-endor-build-stage5-fix` (XS→Rust Endor port, PR
`endojs/endo-but-for-bots` **#600**, branch `xs2rust-endor`, base `llm`, **KEEP DRAFT**).
Oracle pin `48ee02d8cfe0`. Design: `designs/xs2rust-endor-engine.md`.

You run AFTER the four fix children (CESU-8 strings, coder rejects, class tail, modules).
Your job is measurement and evidence, like stage-5 child 7 — do not port new constructs;
report what you find. A byte-identity failure you cannot attribute to a prior child's
documented fold is KILL-CRITERION evidence (design § Feasibility Verdict) — report it
precisely, never skip or hide it.

## The task

From a fresh sync of the REAL remote tip:
1. `cargo test --workspace -- --test-threads=1` EXIT=0 — capture to a file, check `$?`.
2. **Full-corpus `compile-diff` over the curated corpora**: expect
   **divergent=0, endor-rejected=0** (or ONLY folds a fix child explicitly documented as
   remaining — reconcile against their reports in the git log / README).
3. **Broaden the real test262 sweep**: re-run the three existing subtrees
   (`language/expressions/addition`, `language/statements/if`,
   `language/expressions/conditional`) and ADD at least five more meaty `language/` subtrees
   (suggest: `language/statements/for-of`, `language/statements/class`,
   `language/expressions/object`, `language/statements/try`,
   `language/expressions/assignment`), per-subtree (whole-`language/` single-process OOMs —
   documented). Bar: divergent=0 and accept/reject agreement per subtree; investigate and
   name every rejection class.
4. **`using` heads**: check whether the oracle at the pin accepts `using x = a` (script
   goal). If it rejects: record reject-AGREEMENT (no gap). If it accepts: report the parser
   gap with a file count — do not port it yourself.
5. **Parse-metering determinism test** still present and green; **fuzz targets**
   (`endor-fuzz`) still build.
6. **Stage-4 regression spot-checks** (the s11 acceptance numbers must hold): dual-run
   runner on `built-ins/Object` (was 176/0 of 3127), `built-ins/Function` (40/0 of 511, no
   abort), `built-ins/Array` (437/0 of 2625, no abort); harden-corpus + boot-bundle +
   ses-xs-parity bars green. The dual-run runner takes DIRECTORY sections only.
7. **Update the README stage-5 acceptance evidence block** with the new measured tables
   (and prune folds that closed), commit + push.

Report the full tally tables to the supervisor inbox — they are the acceptance evidence.

## Ground rules

- FIRST: isolated checkout via
  `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`,
  then `git fetch origin xs2rust-endor` and reset to the REAL remote tip.
- Oracle pin: populate `c/moddable` via `git init` + `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git 48ee02d8cfe06913e0f0b46eebb8fd0b30c2a6f9 && git checkout FETCH_HEAD`. NEVER `git add` it. `cargo` at `$HOME/.cargo/bin`. Miri needs `TMPDIR=$HOME/tmp`.
- Explicit-pathspec commits; rebase-CAS pushes verified by git EXIT CODE.
- Size to ONE 2400s invocation; if the sweep cannot finish, report what you measured and the
  exact remainder honestly.
- Report to `/home/kris/garden2/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s13` —
  never the maintainer inbox; never comment on the PR; KEEP DRAFT.

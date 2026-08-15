---
gate: orchestrated
orchestrated_by: ironhorse-js-26-ch-async-fromasync-sub
priority: normal
posted_by: producer
posted_at: 2026-08-15T01:43:33Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Async child D: `await` / `async function` language residue + `AsyncFunction`

Nested child of `ironhorse-js-26-ch-async-fromasync-sub`. **Runs last** — it sweeps
the remaining async cluster residue across the `language/` subtrees after children A–C
have landed the built-in surfaces they own, so its scope is whatever async cases still
skip/diverge.

**Causal scope (measured async + unsupported-opcode residue at branch head,
oracle-gated):**
- `language/statements/async-function` and `language/expressions/await` — the residual
  `async`-family failures not owned by an async-generator (child B).
- `built-ins/AsyncFunction` — 1 case.
- The remaining **`unsupported-opcode`** reason-family residue within
  `language/statements` + `language/expressions` that is async in nature
  (e.g. `await`-in-live-`try` jump-chain rebase, async-arrow surfaces), which the
  handoff note (`rust/engine/ASYNC-AWAIT-HANDOFF.md`) flagged as folded skips
  (`await:await-in-try`).

Diagnose each remaining case against the XS oracle and implement the real semantics on
the existing async-function substrate (`step_async`, `AWAIT`/`BRANCH_STATUS`,
`async_instances`), including the try/catch-across-await jump-chain snapshot/rebase the
generator path already performs for `yield`-in-`try`.

**Acceptance bar (non-negotiable):** convert to **covered** via real XS-oracle
execution (`full-run.sh`/`ironhorse-xst` on the affected DIRECTORY sections —
whole-tree `language/` OOMs, so run per-directory — `--test262-dir` pinned checkout).
Add focused Rust regression tests under `rust/engine/ironhorse-262/tests/`. No
relabel/suppress/skip-list/expectation-file. Zero generic `ironhorse-aborted`,
`parse-or-decode`, `unsupported-opcode:*`, `abort-value-differs`,
`non-primitive-completion` in scope.

**Regression invariant:** baseline + earlier-child cases must not regress; no new
`ironhorse-failure`/`infrastructure`; `cases/**` exact-metering corpus stays passing
(`ironhorse-xst --gate-meter-exact` + `cargo test --workspace --release`). Gate before
every push.

**Shared branch/PR:** `feat/ironhorse-262-language-completion` (PR #970, OPEN draft,
keep open, do NOT merge). Fetch+rebase before every push.

**Pins:** test262 `be13516fb6441b950ba8a3df97eb34062c186972`
(`/home/kris/garden/scratch/test262-pin-be13516f`); XS oracle
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. PATH `$HOME/.cargo/bin`;
`TMPDIR=/home/kris/garden/tmp`.

**If too large:** sub-decompose into bounded causal children under a nested
halt-on-failure orchestration and hand off; do not partially relabel.

**Report:** commands, before/after totals, changed reasons, head SHA, PR URL. Keep PR
open.

issue_spine: issue-kriscendobot-garden-51
submitter: kriscendobot

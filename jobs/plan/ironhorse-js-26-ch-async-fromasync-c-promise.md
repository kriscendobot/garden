---
gate: orchestrated
orchestrated_by: ironhorse-js-26-ch-async-fromasync-sub
priority: normal
posted_by: producer
posted_at: 2026-08-15T01:43:28Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Async child C: `built-ins/Promise` residue

Nested child of `ironhorse-js-26-ch-async-fromasync-sub`.

**Causal scope (measured async residue at branch head, oracle-gated):**
- `built-ins/Promise` — **108 cases** in the async cluster still unsupported/failing
  (`async` reason family), the residual after the keystone, the async-function
  surface, `finally`, and the `all/race/allSettled/any` combinators already landed.

These are the subtle Promise edges the current implementation still skips or diverges
on — likely subclassing/`@@species` derivation, resolve/reject thenable-adoption
corner cases, combinator iterator-protocol edges, and unhandled-rejection tracking.
Diagnose each remaining case against the XS oracle and implement the real semantics on
the existing promise substrate (`rust/engine/ironhorse-vm/src/interp.rs`:
`promises`/`promise_functions`/`promise_then*`/`run_promise_job`/`ReactionKind`).

**Acceptance bar (non-negotiable):** convert to **covered** via real XS-oracle
execution (`full-run.sh --subtree built-ins/Promise` / `ironhorse-xst`, `--test262-dir`
pinned checkout). Note metering is advisory for `covered` (value/completion agreement
gates). A specifically-justified, standards-grounded host-only/proposal exclusion is
allowed only where XS itself cannot serve as authority (cite the spec). Add focused
Rust regression tests under `rust/engine/ironhorse-262/tests/`. No
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

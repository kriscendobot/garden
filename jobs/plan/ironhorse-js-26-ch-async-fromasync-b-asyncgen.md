---
gate: orchestrated
orchestrated_by: ironhorse-js-26-ch-async-fromasync-sub
priority: normal
posted_by: producer
posted_at: 2026-08-15T01:43:23Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Async child B: async-generator + `for-await-of` + async-dispose residue

Nested child of `ironhorse-js-26-ch-async-fromasync-sub`.

**Causal scope (measured async/unsupported residue at branch head, oracle-gated):**
- `built-ins/AsyncGeneratorPrototype` — 5 cases.
- `language/statements/async-generator` (and its `for-await-of` companions across
  `language/`) — the residual async-generator + `for await (… of …)` failures within
  the async cluster (`async` reason family).
- `built-ins/AsyncDisposableStack` — 1 case (async dispose / `await using`).

The async-generator suspend/resume machinery, `for-await-of` opcode handling, and the
`AsyncGeneratorAwait/Yield/Return` native reactions already exist
(`rust/engine/ironhorse-vm/src/interp.rs`, `async_generators` table + `step_async_generator`);
this child closes the **residual** edges the current implementation still skips or
diverges on (e.g. `.return()`/`.throw()` interleavings, `for-await` over a sync
iterable wrapped as async, async-dispose sequencing). Diagnose each remaining case
against the oracle and implement the real semantics.

**Acceptance bar (non-negotiable):** convert to **covered** via real XS-oracle
execution (`full-run.sh`/`ironhorse-xst` on the affected subtrees, `--test262-dir`
the pinned checkout). Add focused Rust regression tests under
`rust/engine/ironhorse-262/tests/`. No relabel/suppress/skip-list/expectation-file.
Zero generic `ironhorse-aborted`, `parse-or-decode`, `unsupported-opcode:*`,
`abort-value-differs`, `non-primitive-completion` in scope.

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

---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T01:46:19Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Async child A: implement `Array.fromAsync` + `%AsyncFromSyncIteratorPrototype%`

Nested child of the `ironhorse-js-26-ch-async-fromasync-sub` orchestration (itself
the handed-off decomposition of `ironhorse-js-26-ch-async-fromasync`, child 8 of the
`ironhorse-js-26-residual-closure` arc). **This is the headline deliverable of the
async cluster.**

**Causal scope (measured unsupported at branch head, oracle-gated):**
- `built-ins/Array/fromAsync` — **89 cases** currently
  `unsupported-opcode:Array.fromAsync:async-iteration` + 3 `ironhorse-aborted` + 1
  `async:reported-failure` (95 files total, 2 covered today).
- `built-ins/AsyncFromSyncIteratorPrototype` — **16 cases** (the create-async-from-sync-
  iterator abstraction `fromAsync` leans on for a sync-iterable input).

**What to build.** `Array.fromAsync` is currently a bare
`Halt::Unsupported("Array.fromAsync:async-iteration")` at
`rust/engine/ironhorse-vm/src/interp.rs` (`NativeMethod::ArrayFromAsync`). It is
purely additive — nothing depends on it, so regression risk is low. Implement it as
a **native async state machine** driven by the existing native-reaction substrate
(`schedule_native_await`, `ReactionKind`, `run_promise_job`, `new_promise_capability`,
`register_native_reaction`) that already powers `async`/`await`, async generators,
`finally`, and the Promise combinators. Add a `FromAsyncData` side table plus new
`ReactionKind` variant(s) for its await points, joined to the GC root set exactly as
`async_instances`/`async_generators` are. Cover the full spec surface (proposal
`Array.fromAsync`, now Stage 4 / ES2026): async-iterable input (`@@asyncIterator`),
sync-iterable input wrapped through **CreateAsyncFromSyncIterator**
(`%AsyncFromSyncIteratorPrototype%.next/return/throw`), array-like fallback, `mapfn`
(awaited per element) + `thisArg`, this-constructor behavior, and the error/close
semantics (reject the result promise; `IteratorClose`/`AsyncIteratorClose` on a mapfn
throw). Note: **metering is advisory** for test262 `covered` (only value/completion
agreement gates; `--gate-meter-exact` is off for the sweep), so exact computron
calibration is NOT required here — meter approximately/reasonably and get the
observable async behavior right.

**Acceptance bar (non-negotiable, identical to the js-XX arc):** convert these cases
to **covered** via real execution against the XS oracle
(`rust/engine/ironhorse-262/scripts/full-run.sh --subtree built-ins/Array/fromAsync`
and `--subtree built-ins/AsyncFromSyncIteratorPrototype --test262-dir <pinned>`), or
via `ironhorse-xst --test262-dir <pinned> <subtree>`. Add focused Rust
unit/regression tests under `rust/engine/ironhorse-262/tests/` for the fromAsync
causal features. Do NOT relabel, suppress, skip-list, or add expectation files. Zero
generic `ironhorse-aborted`, `parse-or-decode`, `unsupported-opcode:*`,
`abort-value-differs`, or `non-primitive-completion` reasons may remain in this scope.

**Regression invariant:** no case in `rust/engine/ironhorse-262/baseline/baseline.json`
or landed by an earlier child may regress; no new `ironhorse-failure`/`infrastructure`
result; every exact-metering case under `rust/engine/ironhorse-262/cases/**` stays
passing with unchanged computron expectation (`ironhorse-xst --gate-meter-exact` +
`cargo test --workspace --release`). Run the affected slice, the full Rust workspace
gates, and the exact-metering corpus before every push.

**Shared branch/PR (do not create a new one):** `feat/ironhorse-262-language-completion`
(PR endojs/endo-but-for-bots#970 — OPEN, draft; keep open, do NOT merge). Fetch+rebase
before every push (rebase CAS loop; peers push serially).

**Pins:** test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972` (pinned
checkout at `/home/kris/garden/scratch/test262-pin-be13516f`); Moddable XS oracle
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1
c/moddable`). Rust: prepend `$HOME/.cargo/bin` to PATH; set `TMPDIR=/home/kris/garden/tmp`
(off noexec).

**If too large for one handler:** do NOT partially relabel — sub-decompose into
bounded causal children (e.g. async-iterable path / sync-iterable+AsyncFromSync path /
array-like+mapfn+errors) under a nested halt-on-failure orchestration and hand off.

**Report:** commands run, before/after totals for the affected slices, changed skip
reasons, head SHA, PR URL. Keep the PR open; do not merge.

issue_spine: issue-kriscendobot-garden-51
submitter: kriscendobot

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-15T04:43:16Z

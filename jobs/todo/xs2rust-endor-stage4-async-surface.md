---
role: builder
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T19:22:02Z -->

---
model: opus
---
# Stage-4b child: the async-function surface (from ASYNC-AWAIT-HANDOFF.md) + Promise.prototype.finally + the combinators

**Program context (read first).** You are one serial child of the `xs2rust-endor-build-stage4b`
orchestration (Hardened JavaScript) in the supervised program `port-xs-to-rust-memory-safe-engine`.
Repo `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor`, base `llm`. **Keep the PR
DRAFT.** Get your ISOLATED worktree with
`<garden-root>/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`
(never share a tree; concurrent pushes race safely at the git-push CAS — rebase and retry).
The engine lives in `rust/engine/` (independent cargo workspace; `cargo` at `$HOME/.cargo/bin`).
Read `rust/engine/README.md` first: oracle pin `48ee02d8cfe0` population fallbacks (the empty-gitlink
footgun — `git init` in `c/moddable` first, then fetch from a sibling
`<garden-root>/scratch/project-wt-*/c/moddable`), harness invocation, evidence blocks. Read the design
`designs/xs2rust-endor-engine.md` §§ Value and heap model, Metering, Hardened JavaScript and
Compartment, Staged Roadmap, and the GC-roots contract note.

**Stage-4b context.** The first stage-4 orchestration ran children 1-4 (accessors-attributes,
classes, generators, async-await/promise-keystone) to completion, then HALTED at child 5
(modules): that child LANDED its full static-half scope (commit `e08b83ac3` — `endor_vm::module`:
records, module map + static resolve hook, live indirect bindings, namespace exotics, cyclic
Link/Evaluate, TDZ, ModuleSource; 14 cargo-locked unit tests; folds honestly named — the oracle
shim compiles the script goal only, so `language/module-code` dual-run is a named structural skip
certified instead by the endor-side corpus + manual-xst method in the README; runtime
`XS_CODE_MODULE`/`XS_CODE_TRANSFER`, dynamic `import()`, `import.meta` are named skips) but
overran its handler twice and was retired. You are a child of the REMAINDER orchestration
`xs2rust-endor-build-stage4b`.

**Doctrine (binding): accuracy over parity (2026-07-04).** Result agreement gates; the C-XS oracle
certifies RESULTS only. The meter is endor's own frozen release-versioned cost table —
deterministic per release, recalibrated only deliberately, NEVER back-fit to oracle computrons or
CESU-8 byte lengths. Computron-vs-oracle is advisory telemetry. The branch's dual-run runner still
gates computrons (stricter than the bar): keep it green via calibrated constants or honest named
skips; do NOT relax the runner to result-gating (that belongs to the test262-convergence work).
An unimplementable or oversized surface becomes an **honest named skip** (`Halt::Unsupported`
self-naming), never a wrong value or a silent divergence.

**GC-roots contract (standing ledger item).** If your work wires GC into the run loop or adds
allocation pressure triggers, the root set MUST cover the interpreter side tables
(`functions[*].closures`, `CallerState`, `CatchJump`, `global_props`, and the newer
regexp/bound/promise side tables — note `FuncInfo.body_start` is now `Option<usize>` with bound
functions gated at the `enter_call` choke point), with deterministic trigger points. If you do not
touch GC scheduling, carry the note forward untouched.

**Bar (every child).** `cargo test --workspace -- --test-threads=1` green in `rust/engine/`;
`#![forbid(unsafe_code)]` intact on all engine crates; affected test262 sections dual-run
(per-subtree — whole-tree `language/` runs OOM; the runner takes DIRECTORY sections only, a
single-file arg silently runs 0 files) with **divergent=0** and every skip named; new coverage
locked into `cargo test` as a section-bar test; corpus fixtures for new grammar; Miri on touched
allocation/GC paths (`TMPDIR=$HOME/tmp` — /tmp is noexec for the sysroot build); commit with
explicit pathspecs and push to `origin/xs2rust-endor` (rebase-CAS loop); update
`rust/engine/README.md`'s evidence block with your numbers.

**Sizing.** You are sized to ONE 2400s handler invocation. If the scope does not fit, land what is
green, self-name the remainder as honest skips, and report the **scope fold** explicitly — never a
half-implemented surface. Report completion (numbers + skips + scope folds) via
`<garden-root>/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s10` — the supervisor's
next stage. NEVER message the maintainer inbox; PR #600 comments only if you land a
notable milestone. Drain your own inbox at checkpoints.

**Budget discipline (two stage-4 children died to this — read it).** Your handler is hard-killed
at 2400s wall-clock, builds included (~5-10 min per endor build/calibrate cycle). Land and PUSH
the first green slice EARLY (target: inside the first half of your budget), then commit
incrementally after each green cycle — never hold work uncommitted through a second build cycle.
If you are resumed with too little time left for even one build cycle, do not start code: land a
documentation handoff (as `rust/engine/ASYNC-AWAIT-HANDOFF.md` did) and report the fold.

## Scope (stage-4b child 2/5 — the async-await child's dead-lettered fold, now its own full-budget child)

**Start from `rust/engine/ASYNC-AWAIT-HANDOFF.md`** — the complete C-XS -> endor implementation
map the stage-4a async child landed precisely so you can EXECUTE instead of re-deriving. The
promise keystone (native-handler double-settle calibration, two-level [[AlreadyResolved]] guard,
thenable adoption, `Promise.resolve(nativePromise)` identity) is LANDED bit-exact at `49e27a89b`;
`built-ins/Promise` stands at total=474 covered=9 divergent=0. Your work:

- **The async-function surface**: `XS_CODE_ASYNC_FUNCTION` (function instance re-chained to a new
  `%AsyncFunction.prototype%` intrinsic), `XS_CODE_START_ASYNC` (`new_async_instance` cloning the
  frame like `new_generator_instance`, result promise via `new_promise_instance` +
  `make_resolving_functions`, synchronous run to first await, return the result promise),
  `XS_CODE_AWAIT` (the YIELD-shaped suspend reading from the new `async_run_stack`), and the
  `BRANCH_STATUS` status plumbing — per the handoff's opcode-by-opcode map. `step_async` modeled
  on `resume_generator`; `await_schedule`'s native-promise fast path vs general-capability branch.
- **Metering**: freeze the `fxNewAsyncInstance` allocation cluster as a calibrated
  `ASYNC_INSTANCE_METERING` constant (the handoff enumerates the slots) and the per-opcode deltas,
  endor-own frozen costs per the doctrine — oracle computrons advisory, dual-run runner kept green
  via calibration or honest named skips.
- **The 5-slot native-reaction path** (`PromiseReaction.kind` = AsyncAwait/Finally/Combine per the
  handoff) — the shared prerequisite that ALSO unblocks:
- **`Promise.prototype.finally`** and **the combinators `Promise.all` / `race` / `allSettled` /
  `any`** (the stage-4a fold that rode on the same missing native-reaction infra). Land them on
  that path with their own calibrated costs.
- **Designated folds (carry, do not attempt)**: async generators
  (`XS_CODE_ASYNC_GENERATOR_FUNCTION`), `for-await-of` — they stay honest named skips; also leave
  `await`-inside-live-`try` gated per the handoff's v1 note if the jump-chain snapshot does not
  fit, as a named skip rather than a wrong unwind.

## Acceptance focus

`built-ins/Promise` dual-run per-subtree with **divergent=0** and covered growing well past the
keystone's 9 (finally + combinators + async-driven tests move from named-skip to covered);
`built-ins/AsyncFunction` dual-run; an async/await corpus (plain awaits, await-of-thenable,
rejection paths, long chains, combinator matrices) locked as cargo bars; Miri
(`TMPDIR=$HOME/tmp`) on the new instance/reaction allocation paths; the handoff doc updated or
retired (fold paragraph in README updated to point at the landed surface); GC-roots note: the new
`async_run_stack` and async-instance side tables join the roots ledger.

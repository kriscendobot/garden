---
role: builder
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T20:13:07Z -->

---
model: opus
---
# Stage-4 child: lockdown, harden, petrify, mutabilities; intrinsics freeze

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

## Scope (stage-4b child 4/5; originally 7/8 — depends on stage-4a child 1 (freeze descriptors) and the previous child (Compartment))

Port `xsLockdown.c`:

- **`lockdown()`**: transitively freeze the shared intrinsics exactly as the pin does (the
  intrinsics whitelist/walk XS implements), error taming (`stackTraceLimit` behaviors on the XS
  surface), `Date.now`/`Math.random` compartment-safety per the pin (xsnap already tames these
  at build config — match the pin's xst-with-lockdown behavior), repeated-lockdown idempotence
  and the throw-on-second-call shape XS chooses (match the pin's RESULT).
- **`harden(x)`**: the transitive freeze worklist over the slot arena (design § Hardened
  JavaScript names this seam), returning x; pre-lockdown behavior matching the pin.
- **`petrify` / `mutabilities`**: the pin's semantics from `xsLockdown.c` (petrify freezing
  through own data, mutabilities reporting the mutable residue).
- **Metering**: lockdown/harden walk costs as endor's own calibrated frozen entries — these
  walks are large; determinism per release is the bar, oracle computrons advisory.
- GC note: harden's worklist and any frozen-intrinsics tables must be visible to the GC roots
  contract if they become side tables.

## Acceptance focus

A lockdown/harden differential corpus vs the pin's xst (`xst` builds with lockdown in the
harness — verify how the oracle shim exposes it; extend the audited FFI seam minimally if
needed): post-lockdown intrinsic mutation TypeErrors, harden transitive reach, petrify/
mutabilities results — result agreement, named skips, cargo bars, README evidence block.
Re-run one earlier section (e.g. `built-ins/Object`) to confirm freeze machinery introduced no
regression.

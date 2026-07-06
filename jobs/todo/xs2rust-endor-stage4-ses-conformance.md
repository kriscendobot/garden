---
role: builder
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T20:34:20Z -->

---
model: opus
---
# Stage-4 child: stage-4 closure: daemon boot bundles + ses-xs-parity

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

## Scope (stage-4b child 5/5 — the stage-4 acceptance bar itself; depends on ALL stage-4 children, 4a and 4b)

Close the design's stage-4 bar (§ Staged Roadmap row 4, § Hardened JavaScript and Compartment):

- **The endor daemon boot sequence runs identically on both engines**: `polyfills.js`, then
  `ses_boot.js` lockdown, then the HandledPromise shim, per `daemon-endor-architecture.md`
  § Unified runner. Locate the actual bundles the daemon boots (`rust/endo/...`; they may be
  build artifacts — generate them the way the daemon build does, or use the committed sources;
  document the provenance). Run each on endor and on the pin (via the oracle/xst), compare
  completions — result agreement is the bar. Divergences are triaged: fix in-tree if small,
  otherwise a named, ledgered gap reported to s10 (do NOT silently narrow the bundle).
- **SES conformance (`ses-xs-parity`)**: find and run the SES test suites XS is exercised
  against in this repo (search for `ses-xs-parity` and the `packages/ses` test lanes that run
  under xst). Run the applicable set against endor; record pass/fail/skip honestly per test
  with named reasons.
- **Stage-4 evidence block**: a consolidated README section — per-child covered/divergent
  numbers, the boot-bundle verdict, the SES-conformance tally, outstanding named gaps — the
  material the supervisor's whole-stage-4 acceptance review (s10) will independently reproduce.
- If earlier children folded scope (async generators, dynamic import, private fields), verify
  each fold is still an honest named skip at this closure point and enumerate them in one
  consolidated ledger for s10.

## Acceptance focus

The boot-bundle identical-run verdict + the ses-xs-parity tally, both locked as cargo-test bars
where mechanically runnable (a bundle-run test that asserts the completion), full
`cargo test --workspace` green, and the consolidated evidence block pushed.

**Fold ledger to consolidate (updated by the supervisor, 2026-07-06).** The known named folds
entering this closure child: async generators / `for-await-of` (designated fold, stage-4a child
4); the module-goal oracle seam (`language/module-code` dual-run structurally skipped; endor-side
corpus + manual-xst certification per README), runtime `XS_CODE_MODULE`/`XS_CODE_TRANSFER`,
dynamic `import()`, `import.meta` (stage-4a child 5); `compartment:dynamic-import` if the
Compartment child named it; anything the async-surface child (stage-4b child 2) reports. Verify
each is STILL an honest named skip at closure and enumerate them in the consolidated ledger for
s10's whole-stage-4 acceptance review.

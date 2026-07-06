---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage4
priority: normal
posted_by: producer
posted_at: 2026-07-06T03:44:03Z
---

---
model: opus
---
# Stage-4 child: stage-4 closure: daemon boot bundles + ses-xs-parity

**Program context (read first).** You are one serial child of the `xs2rust-endor-build-stage4`
orchestration (Hardened JavaScript) in the supervised program `port-xs-to-rust-memory-safe-engine`.
Repo `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor`, base `llm`. **Keep the PR
DRAFT.** Get your ISOLATED worktree with
`/home/kris/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`
(never share a tree; concurrent pushes race safely at the git-push CAS — rebase and retry).
The engine lives in `rust/engine/` (independent cargo workspace; `cargo` at `/home/kris/.cargo/bin`).
Read `rust/engine/README.md` first: oracle pin `48ee02d8cfe0` population fallbacks (the empty-gitlink
footgun — `git init` in `c/moddable` first, then fetch from a sibling
`/home/kris/scratch/project-wt-*/c/moddable`), harness invocation, evidence blocks. Read the design
`designs/xs2rust-endor-engine.md` §§ Value and heap model, Metering, Hardened JavaScript and
Compartment, Staged Roadmap, and the GC-roots contract note.

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
allocation/GC paths (`TMPDIR=/home/kris/tmp` — /tmp is noexec for the sysroot build); commit with
explicit pathspecs and push to `origin/xs2rust-endor` (rebase-CAS loop); update
`rust/engine/README.md`'s evidence block with your numbers.

**Sizing.** You are sized to ONE 2400s handler invocation. If the scope does not fit, land what is
green, self-name the remainder as honest skips, and report the **scope fold** explicitly — never a
half-implemented surface. Report completion (numbers + skips + scope folds) via
`/home/kris/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s9` — the supervisor's
next stage. NEVER message the maintainer inbox; PR #600 comments only if you land a
notable milestone. Drain your own inbox at checkpoints.

## Scope (child 8/8 — the stage-4 acceptance bar itself; depends on all prior children)

Close the design's stage-4 bar (§ Staged Roadmap row 4, § Hardened JavaScript and Compartment):

- **The endor daemon boot sequence runs identically on both engines**: `polyfills.js`, then
  `ses_boot.js` lockdown, then the HandledPromise shim, per `daemon-endor-architecture.md`
  § Unified runner. Locate the actual bundles the daemon boots (`rust/endo/...`; they may be
  build artifacts — generate them the way the daemon build does, or use the committed sources;
  document the provenance). Run each on endor and on the pin (via the oracle/xst), compare
  completions — result agreement is the bar. Divergences are triaged: fix in-tree if small,
  otherwise a named, ledgered gap reported to s9 (do NOT silently narrow the bundle).
- **SES conformance (`ses-xs-parity`)**: find and run the SES test suites XS is exercised
  against in this repo (search for `ses-xs-parity` and the `packages/ses` test lanes that run
  under xst). Run the applicable set against endor; record pass/fail/skip honestly per test
  with named reasons.
- **Stage-4 evidence block**: a consolidated README section — per-child covered/divergent
  numbers, the boot-bundle verdict, the SES-conformance tally, outstanding named gaps — the
  material the supervisor's whole-stage-4 acceptance review (s9) will independently reproduce.
- If earlier children folded scope (async generators, dynamic import, private fields), verify
  each fold is still an honest named skip at this closure point and enumerate them in one
  consolidated ledger for s9.

## Acceptance focus

The boot-bundle identical-run verdict + the ses-xs-parity tally, both locked as cargo-test bars
where mechanically runnable (a bundle-run test that asserts the completion), full
`cargo test --workspace` green, and the consolidated evidence block pushed.

---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T15:10:25Z -->

---
model: opus
---
# Stage-4 child: module machinery: ModuleSource, module records, namespaces

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

## Scope (child 5/8)

Port the module machinery from the pin's `xsModule.c` (static half first):

- `XS_CODE_MODULE`, import/export linkage: module records, module environment (indirect
  bindings — live re-export semantics), module namespace exotic objects (sorted keys, no-set,
  `@@toStringTag`), cyclic module graphs (DFS instantiate/evaluate ordering), TDZ on
  un-evaluated bindings.
- **ModuleSource** as a first-class constructable (the XS/Compartment shape: compile-only,
  bindings reflection) to the extent the oracle compiler seam supports feeding module source —
  establish how the oracle compiles a module (xst compiles modules via its runner; if the
  oracle shim cannot drive module compilation, extend it minimally on the audited FFI seam, or
  self-name the differential gap honestly and verify module semantics with endor-side unit
  corpora + the pin run manually via xst, documenting the method in the README).
- **Module maps** (specifier → module) as the machine-level seam Compartment (child 6) will
  consume; a minimal host resolve hook (static specifiers; no filesystem).
- Dynamic `import()` and `import.meta`: named skips (`module:dynamic-import`, `module:import-meta`)
  unless they fit trivially.

## Acceptance focus

`language/module-code/` dual-run per-subtree IF the oracle seam supports module goal parsing —
divergent=0 with named skips; otherwise the documented endor-side corpus + manual-xst method,
plus namespace/linkage unit tests locked in cargo. Record honestly which path was achieved.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  claimed_at: 2026-07-06T15:10:30Z

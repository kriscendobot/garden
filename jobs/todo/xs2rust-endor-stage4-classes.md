---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T11:55:37Z -->

---
model: opus
---
# Stage-4 child: class definitions, super, new.target

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

## Scope (child 2/8 — depends on child 1's accessor/attribute model)

Port the `class` opcode family (the pin's `xsRun.c`/`xsFunction.c` class construction path):

- `XS_CODE_CLASS` and its companion opcodes: class definition evaluation, constructor kind,
  prototype wiring (`constructor` non-enumerable, methods non-enumerable), static members,
  class expressions vs declarations, TDZ of the class binding.
- **Methods**: concise methods, getters/setters in class bodies (on child 1's accessor slots),
  computed method names, `Symbol.iterator`-keyed methods.
- **Inheritance**: `extends` (including `extends null`), `super.method()` home-object dispatch,
  `super(...)` constructor calls, derived-constructor `this` TDZ semantics, implicit constructor
  synthesis, `new.target` (the `target` opcode already decodes — give it real semantics).
- **Private fields/methods and class static blocks**: implement if they fit; otherwise honest
  named skips (`class:private-field`, `class:static-block`) — never a wrong value.

## Acceptance focus

Dual-run `language/statements/class` per-subtree (it is large — walk subtrees like
`definition/`, `subclass/`, then aggregate) and `language/expressions/class` similarly;
divergent=0, every skip named, covered counts recorded in the README evidence block and locked
as cargo-test bars. Re-run `built-ins/Function` (39 baseline) to confirm no regression.

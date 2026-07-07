---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-07T10:16:54Z -->

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (s1 design
dispatch), `-s2` (self-answer + approve), `-s3` (stage-1 review), `-s4` (stage-2a review + 2b
dispatch), `-s5` (2b review + stage-3 dispatch), `-s6` (stage-3 halt recovery + stage-3b dispatch),
`-s7` (whole-stage-3 acceptance review with full independent reproduction), `-s8` (UTF-16 strings
acceptance + bound-callback fixer verification + stage-4 dispatch), `-s9` (stage-4 halt recovery +
stage-4b remainder dispatch), `-s10` (whole-stage-4 acceptance review — findings + F1 fixer
dispatch), and `-s11` (F1 fix verification + stage-4 ACCEPTANCE + stage-5 dispatch, completed
2026-07-06). You were parked `blocked_on: xs2rust-endor-build-stage5` (a serial ORCHESTRATION,
7 children, on-child-failure=halt) and promoted because it reached a terminal state. **FIRST:**
sync your journal worktree (`git -C journal pull --ff-only origin journal2`), read the
orchestration's completion/progress record and `journal/jobs/tada/xs2rust-endor-stage5-*.md`
(if a child is NOT in `tada/`, check `git log --all -- jobs/` for reaper poisoning and diagnose
false-positive reap first — was the child landing commits on the branch during its claim
window?, as s9 did), and drain your inbox `port-xs-to-rust-memory-safe-engine-s12` (all seven
children report scope folds there). Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, and stage 4: done and
  ACCEPTED** (s7: PR #600 issuecomment-4888517639; s8: issuecomment-4888883354; s11:
  **issuecomment-4897783472**, findings half issuecomment-4897621932). Stage-4 tip facts s11
  independently reproduced at `8f61d5fa6` from a fresh checkout: `cargo test --workspace --
  --test-threads=1` EXIT=0 **172/0**; whole-tree `built-ins/Function` 40/0 of 511 no abort,
  `built-ins/Array` 437/0 of 2625 no abort, `built-ins/Object` 176/0 of 3127; harden-corpus +
  boot-bundle + ses-xs-parity bars green; F1 (oracle-shim SIGSEGV — missing `mxPush(mxGlobal)`
  before `fxNextHostFunctionProperty`, garbage HOME pointers dereferenced by the GC
  `XS_HOME_KIND` marker and the toString walk) fixed C-only in the audited shim seam with 3
  locked regression tests (`shim_intrinsic_walk_and_gc_survive_installed_globals`,
  `shim_lockdown_call_fails_safely_not_segv`, `shim_mutabilities_call_fails_safely_not_segv`);
  `forbid(unsafe_code)` intact everywhere.
- **Stage 5 (Compiler port — `endor-compile`): DISPATCHED by s11** as orchestration
  `xs2rust-endor-build-stage5` (serial, halt, all children `model: opus`, each sized to one
  2400s invocation, each reporting to YOUR inbox): (1) `xs2rust-endor-stage5-lexer` — crate
  skeleton + `xsLexical.c` port + parse-meter hook threaded from the start; (2)
  `-stage5-parser-expr` — txNode-mirroring AST + expression grammar; (3) `-stage5-parser-stmt` —
  statements/declarations/functions/classes/modules + whole-corpus parse smoke; (4)
  `-stage5-scoper` — `xsScope.c` hoisting + exact slot numbering (locked by fixtures, the coder
  contract); (5) `-stage5-coder-expr` — emitter framework (two-pass branch sizing, atom/constant
  order, decoder-compatible chunk layout) + expression emission + first byte-identity fixtures +
  a triage disassembler; (6) `-stage5-coder-decl` — functions/classes/control-flow/generators/
  async/modules emission, byte-identity per construct; (7) `-stage5-byte-identity` — THE STAGE
  BAR: full-corpus compile-differential harness (divergent=0 + accept/reject agreement, per
  subtree; a failure here is KILL-CRITERION evidence reported to you, never skipped), parse-
  metering determinism locked test, parser + differential fuzz targets armed, an explicit
  compiler-selection seam in the runner (default stays oracle-compile until YOU accept stage 5),
  README evidence block.
- **Your job now:**
  1. **If the orchestration halted on a child failure:** diagnose (child report/poison,
     false-positive reap, budget overrun with partial landing — the branch may carry green
     landed slices even when a child's job failed), post a follow-up fixer/builder (opus)
     carrying the child's remaining scope, park s13 blocked on it carrying this spec.
  2. **If all seven children completed: run the whole-stage-5 acceptance review** (the s7/s10
     pattern — independent reproduction from YOUR fresh checkout at the tip via
     `ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`): workspace
     green EXIT=0 (capture to file, check `$?`); re-run the full-corpus byte-identity harness
     per subtree and confirm divergent=0 + the accept/reject tally; parse-metering determinism
     test present and green; fuzz targets build; spot-check that stage-4 bars did not regress
     (`built-ins/Object` 176/0, Function 40/0, Array 437/0, harden corpus). Post findings; if
     bad/partial, dispatch fixers (opus) and park s13 blocked on them; on green POST the stage-5
     ACCEPTANCE as a PR #600 comment (reproduction numbers, fold ledger carried).
  3. **Then dispatch stage 6 (design § roadmap row 6 — read it from the live tree)** as
     orchestration `xs2rust-endor-build-stage6` (serial, halt, opus children, one-invocation
     sizing, budget-discipline paragraph, reports to `port-xs-to-rust-memory-safe-engine-s13`),
     decomposed by YOU from the design row + the live tree + the fold ledger. Park s13
     `--blocked --blocked-on xs2rust-endor-build-stage6` carrying this spec with an updated
     Supervisor state.
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed, 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS
  (and stage-5 BYTES) only; computron-vs-oracle is advisory telemetry; the meter is endor's own
  frozen release-versioned cost table (`endor-meter-N`). Never back-fit meters to CESU-8 byte
  lengths or oracle computrons. The branch's dual-run runner still gates computrons (stricter
  than the bar) — children may keep it green via calibrated constants or honest skips; a
  deliberate runner-relaxation to result-gating belongs to the test262-convergence work.
- **Review ledger (carry forward):** GC-roots contract (side tables functions[*].closures /
  CallerState / CatchJump / global_props + regexp/bound/promise side tables + async_instances/
  async_run_stack + generators + module records/maps + harden worklist/frozen-intrinsics tables
  must be roots when GC wires into the run loop, deterministic trigger points — verify at
  whichever child/stage first does it); FUNCTION_* analytic decomposition (advisory);
  sub-computron construct-`this` + object-literal construction drifts (advisory telemetry,
  stage-8 ledger); generator saved-slice metering residual (advisory); module-goal oracle seam
  DECIDED at s10 — endor-side corpus + manual-xst certification sufficed for stage 4; opening
  the shim seam moves to test262-convergence (F1 reinforced: shim widenings are high-risk,
  separately audited); BothAbort same-value/different-cost should graduate to covered under the
  result bar (test262-convergence); dual-run runner must survive an ORACLE crash and report it
  as a named class (test262-convergence; F1 is the second standing example after the RegExp
  fixed-stack overflow — stage 5's differential fuzz target names the outcome too); stage-8
  items (sort/toSorted/from/of, string residuals); pre-existing cosmetic warnings in interp.rs
  (unused `argc`, redundant `mut push_segment`); post-stage-4 engine intrinsics ledger
  (`globalThis` live global-object binding — unblocks the boot-bundle chain — then Reflect,
  typed-array-from-iterable, symbol-keyed defineProperty, class-instance construction,
  `Compartment`/`lockdown` as guest globals); a `Promise.prototype.finally` + combinators child
  rides the landed 5-slot native-reaction path (fold into a stage where it fits); `lockdown()`
  full + `mutabilities` remain folds on the harden substrate.
- **Parked sequencing you do NOT own yet:** the five `xs2rust-endor-262-*` children of the future
  `xs2rust-endor-test262-convergence` orchestration — a supervisor arms them "near port
  completion" (stage 8-ish), per `designs/xs2rust-endor-test262-convergence.md`.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin `48ee02d8cfe0` not shallow-fetchable from upstream, but IS
  depth-1-fetchable from the garden's bare clone — populate `c/moddable` with `git init` there,
  then `git fetch --depth=1 /home/kris/garden2/worktrees/endojs-endo-but-for-bots.git
  48ee02d8cfe06913e0f0b46eebb8fd0b30c2a6f9 && git checkout FETCH_HEAD` (a full fetch dies on
  missing parents; the committed gitlink `55167268…` is stale — build against `48ee02d8cfe0`).
  `cargo` at `$HOME/.cargo/bin` (the garden root IS `$HOME` on this fleet). Whole-tree
  single-process `language/` runs OOM — run per subtree (`built-ins/*` whole-trees are fine).
  The dual-run runner takes DIRECTORY sections only (a single-file arg silently runs 0 files).
  Miri on this host needs `TMPDIR=$HOME/tmp`. A `cargo test` piped to `tail` masks the exit
  code — capture to a file and check `$?` directly. If the bare clone's local branch ref is
  pinned stale by a dead worktree, detach that worktree's HEAD and
  `git fetch origin xs2rust-endor:xs2rust-endor` (s10's fix).
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox.
- **Kill criteria:** if tripped (design § Feasibility Verdict — stage 5's byte-identity bar is
  one), stop the program: journal + surface to the maintainer with evidence.
- **Continuation protocol:** at each wait point post the sub-job(s), park your next stage with
  `scripts/jobs/post-plan.sh --blocked --blocked-on <base> port-xs-to-rust-memory-safe-engine-s<N+1> <body>`
  (body by FILE, never inline) carrying this whole spec + updated Supervisor state, journal the
  transition, and complete. Design sub-jobs `model: fable`, build/fixer `model: opus`. Sub-jobs
  report to YOU, never the maintainer inbox — the maintainer enters the loop ONCE, at the end.

The original program spec follows, unabridged.

---
You are a **long-running Fable supervisor**. Your job is not to design or build the port yourself, but to
**orchestrate the full lifecycle** — design, self-answer every open question, approve the design, build it
end-to-end on the same PR, and review the implementation to completion — and to involve the maintainer
**only once, at the very end**, when the PR is complete and ready for their attention.

**Repo:** `endojs/endo-but-for-bots` (bot-pushable; standing comment auth). This is DESIGN/RESEARCH plus
**fork-scoped** build only — **no upstream `endojs/endo` or `agoric/agoric-sdk` interaction** (no comments,
PRs, issue/PR links, merges). The metering-equivalence requirement below exists precisely because XS feeds
agoric consensus, but any real upstream landing is a separately authorized program, not this job.

## The design brief (hand this verbatim to the designer)

Port **XS** (Moddable's interpreted JS engine, as consumed by Endo's xs-worker / agoric-sdk `xsnap`) to
**Rust**, as a crate **endor** embeds, to raise confidence in memory safety while preserving what makes XS
uniquely suited to Endo/agoric. The design must carry ALL of these hard requirements:
1. **Preserve metering, debugger, snapshot-persistence.** Metering = deterministic CPU+memory metering
   reproduced EXACTLY vs C-XS (a consensus requirement; a divergence is a consensus fault) or a stated
   determinism-equivalence proof. Debugger = the XS debugger protocol/inspection surface. Snapshot = heap
   save/restore (the xsnap lifecycle); decide the FORMAT question (read existing XS snapshots vs a
   Rust-native format + migration).
2. **Minimize `unsafe`** — an `unsafe` budget + per-use justification, isolated behind audited modules.
3. **Increase memory-safety confidence** — the headline metric, weighed against perf.
4. **No JIT, ever** — interpreter-only (bytecode/threaded) for determinism, metering, security, footprint.
5. **HardenedJS / Compartment first-class** — native `Compartment`, `lockdown`/SES, hardening primitives.
6. **High test262 coverage → parity with C-XS.** A conformance harness, the coverage bar, and how coverage
   is bootstrapped and tracked to parity. **test262 parity is the acceptance bar for the build phase.**
7. **Fuzzability** — cargo-fuzz/libFuzzer, structure-aware parser+interpreter fuzzing, differential fuzzing
   vs C-XS.
8. **Better endor integration** — embed as a Rust crate instead of the C `xsnap` subprocess; reconcile with
   the `daemon-endor-architecture.md`, `daemon-rust-xs-performance.md`, `daemon-endo-rust-sqlite.md`, and
   `daemon-xs-worker-{metering,debugger,snapshot}.md` design cluster.
Investigation to weigh: build approaches (from-scratch vs extend a Rust engine like Boa vs hybrid), the
determinism/metering bar (the crux; validate equivalence via differential testing on test262 + agoric
contract corpora), snapshot compatibility + debugger protocol, and the footprint/perf envelope. Deliverable
is a feasibility verdict + architecture design + a STAGED roadmap (a thin first slice proving the
metering-determinism + Compartment bar and bootstrapping test262 coverage, then iterate). Design doc lands
under `designs/` on `endojs/endo-but-for-bots`.

## Your supervision loop

Use the job board (`scripts/jobs/post-job.sh`), the message bus, and PR state to dispatch and await each
stage. Set the sub-jobs' model explicitly: **design sub-jobs `model: fable`, build/fixer sub-jobs
`model: opus`.**

1. **DESIGN.** Post a `designer` job (`model: fable`) carrying the brief above, to open a design PR under
   `designs/`. — **DONE, stage 1.**
2. **SELF-ANSWER + APPROVE (loop).** Repeatedly read the design's **open questions**, answer each one
   yourself, post design revisions until no open questions remain, record approval. — **DONE, stage 2.**
3. **BUILD (same PR).** Post `builder` jobs (`model: opus`) to implement the port **end-to-end on the SAME
   PR as the design**. Acceptance bar: **test262 parity** plus the metering-determinism + Compartment bars
   the design set (as amended by the accuracy-over-parity doctrine, 2026-07-04). — **IN PROGRESS: roadmap
   stages 1–5 dispatched (stage 5 building; stages 1–4 ACCEPTED); stages 6–9 remain.**
4. **REVIEW (loop).** As implementation lands, **review it yourself**: post concrete review findings, then
   post `fixer` jobs (`model: opus`) to address them, and iterate build → review → fix until the
   implementation is **complete and passing** (test262 parity met, `unsafe` budget honored, determinism
   validated).
5. **HAND OFF.** Only when complete: mark the PR ready-for-review (un-draft) and surface it to the
   **maintainer** (a bulletin entry + a maintainer-inbox note with the PR URL and a status summary). This is
   the single point a human enters the loop.

## Surviving across invocations

This is a multi-quarter program; you will not finish in one run. Between stages you WAIT on sub-jobs
(block on their completion messages / poll the board and PR). If your invocation is ending with work still
outstanding, **persist your progress and re-post a continuation of yourself** (same basename with the next
`-sN` stage suffix, `model: fable`, with a short state note of which stage you are in and what you are
waiting on) so the supervision survives a restart — never drop the lifecycle on the floor. Journal each
stage transition.

## Definition of done

A single PR on `endojs/endo-but-for-bots` carrying the **approved** design plus the **end-to-end
implementation at test262 parity**, reviewed to completion by you, un-drafted, and surfaced to the
maintainer with a status summary. The maintainer is asked to look **once**, at the end. Journal the full
lifecycle (design PR, approval, build, review rounds, hand-off).

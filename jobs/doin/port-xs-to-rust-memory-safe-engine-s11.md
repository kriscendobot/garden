---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-06T21:23:37Z -->

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
stage-4b remainder dispatch), and `-s10` (whole-stage-4 acceptance review — findings + fixer
dispatch, completed 2026-07-06). You were parked
`blocked_on: xs2rust-endor-stage4-fix-oracle-shim-crash` (an opus fixer, NOT an orchestration)
and promoted because it reached a terminal state. **FIRST:** sync your journal worktree
(`git -C journal pull --ff-only origin journal2`), read
`journal/jobs/tada/xs2rust-endor-stage4-fix-oracle-shim-crash.md` (if it is NOT in `tada/`, the
reaper may have poisoned it — check `git log --all -- jobs/` history and diagnose false-positive
reap first, as s9 did: was the fixer landing commits on the branch during its claim window?),
and drain your inbox `port-xs-to-rust-memory-safe-engine-s11` (the fixer reports there). Program
state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), and the UTF-16 strings rework: done and ACCEPTED**
  (s7: PR #600 issuecomment-4888517639; s8: issuecomment-4888883354).
- **Stage 4 (both orchestrations, 9 children): BUILT and s10-REVIEWED; acceptance WITHHELD on one
  finding.** s10's review (PR #600 **issuecomment-4897621932**, 2026-07-06) independently
  reproduced at tip `1b449a1f0d` from a fresh checkout: `cargo test --workspace` **169/0 fresh in
  23.2s** (decoder fuel bound verified real — `Halt::StepLimit`, `DECODER_STEP_LIMIT=2_000_000`,
  regression cases locked); ALL nine children's headline tallies exact and `divergent=0`
  (`built-ins/Object` 176, `statements/class` 1, `expressions/class` 1, `statements/generators`
  74, `expressions/generators` 79, `for-of` 118, `built-ins/Promise` 9, `statements/async-function`
  6, `expressions/await` 6, `built-ins/AsyncFunction` 1); boot-bundle + ses-xs-parity closure bars
  green (honest abort at `boot:no-globalThis-global-object-binding`, `total=2 covered=0
  divergent=0`); keystone `49e27a89b` ancestry verified with the 4b async-surface on top; every
  ledgered fold self-names in code; `forbid(unsafe_code)` intact.
  **Finding F1 (the blocker): oracle-shim SIGSEGV regression at `63e6017999`** (the harden child's
  shim extension installing harden/lockdown/petrify/mutabilities into the bare boot). Whole-tree
  `built-ins/Function` and `built-ins/Array` dual-runs SIGSEGV (rc=139): the two
  `Function/prototype/toString` intrinsic-graph-walker files AND a second non-walker class under
  `Array/prototype/{concat,map,sort}` (typed-array + spreadable-sparse concat files) — both
  classes clean at parent `c6de4a8468`, both crash at `63e6017999`. Blocks re-certifying the
  Function=40 and Array=437 no-abort baselines. Fixer
  `xs2rust-endor-stage4-fix-oracle-shim-crash` (opus) carries the full repro, bars (both
  whole-trees complete no-abort at >= baselines, harden corpus stays green, locked walker
  regression bar, workspace green), and budget discipline; it reports to YOUR inbox.
- **Your job now:**
  1. **Verify the fixer**: read its report + inbox message; independently re-run at the new tip
     from YOUR fresh checkout (`ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots
     xs2rust-endor` — if the bare clone's local branch ref is pinned stale by a dead worktree,
     detach that worktree's HEAD and `git fetch origin xs2rust-endor:xs2rust-endor`, as s10 had
     to): `cargo test --workspace -- --test-threads=1` (capture to file, check `$?`), whole-tree
     `built-ins/Function` (expect covered>=40 divergent=0 NO abort) and `built-ins/Array`
     (covered>=437 divergent=0 NO abort), spot-check `built-ins/Object` 176/0 and the harden
     corpus bar. If the fix is bad or partial: post findings + a follow-up fixer (opus), park
     s12 blocked on it carrying this spec.
  2. **On green: POST the stage-4 ACCEPTANCE as a PR #600 comment** (the s7/s8 pattern —
     reproduction numbers, F1 fix verified, fold ledger carried; reference
     issuecomment-4897621932 as the findings half).
  3. **Then dispatch stage 5 (Compiler port — `endor-compile`)**: lexer/parser/scoper/coder
     replacing the oracle compiler; byte-identical bytecode vs the oracle compiler on the full
     conformance corpus; parse metering deterministic per release; parser fuzz target armed.
     Orchestration `xs2rust-endor-build-stage5`, serial, on-child-failure=halt, children
     `model: opus`, each sized to ONE 2400s handler invocation (the s9/s10 sizing hard lesson:
     a child with two independently-landable halves gets cut into two children up front), each
     carrying the budget-discipline paragraph (land+push the first green slice inside the first
     half of the 2400s budget), each reporting scope folds to inbox
     `port-xs-to-rust-memory-safe-engine-s12`. YOU own the decomposition — decompose from the
     live tree + design § roadmap row 5. A reasonable cut: (a) lexer+tokens, (b) parser/AST per
     grammar family (likely 2 children), (c) scoper/hoisting, (d) coder/bytecode emission in
     slices (likely 2 children), (e) the byte-identity differential harness vs the oracle
     compiler over the conformance corpus (the stage bar child, last). Consider whether stage 6
     snapshots could overlap; default serial. Park `port-xs-to-rust-memory-safe-engine-s12`
     `--blocked --blocked-on xs2rust-endor-build-stage5` carrying this spec with an updated
     Supervisor state.
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed, 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS
  only; computron-vs-oracle is advisory telemetry; the meter is endor's own frozen
  release-versioned cost table (`endor-meter-N`), recalibrated via the opcode-cost-instrumentation
  plan. Never back-fit meters to CESU-8 byte lengths or oracle computrons. The branch's dual-run
  runner still gates computrons (stricter than the bar) — children may keep it green via
  calibrated constants or honest skips; a deliberate runner-relaxation to result-gating belongs
  to the test262-convergence work, not ad hoc.
- **Review ledger (carry forward):** GC-roots contract (side tables functions[*].closures /
  CallerState / CatchJump / global_props + regexp/bound/promise side tables + async_instances/
  async_run_stack + generators + module records/maps + harden worklist/frozen-intrinsics tables
  must be roots when GC wires into the run loop, deterministic trigger points — verify at
  whichever child/stage first does it); FUNCTION_* analytic decomposition (advisory);
  sub-computron construct-`this` + object-literal construction drifts (advisory telemetry,
  stage-8 ledger); generator saved-slice metering residual (~408 raw/resume on loop-heavy
  yields — advisory, a follow-up could scale the constant by saved-slice length);
  **module-goal oracle seam: DECIDED at s10 — endor-side corpus + manual-xst certification
  suffices for stage 4; opening the shim seam moves to test262-convergence** (F1 reinforces:
  shim widenings are high-risk, separately audited); BothAbort same-value/different-cost should
  graduate to covered under the result bar (test262-convergence); dual-run runner must survive an
  ORACLE crash and report it as a named class (test262-convergence; F1 is the second standing
  example after the RegExp fixed-stack overflow); stage-8 items (sort/toSorted/from/of, string
  residuals); pre-existing cosmetic warnings in interp.rs (unused `argc`, redundant `mut
  push_segment`); post-stage-4 engine intrinsics the ses child ledgered (`globalThis` live
  global-object binding — unblocks the boot-bundle chain — then Reflect,
  typed-array-from-iterable, symbol-keyed defineProperty, class-instance construction,
  `Compartment`/`lockdown` as guest globals); the async child's recommendation: a
  `Promise.prototype.finally` + combinators child rides the landed 5-slot native-reaction path
  (fold it into a stage where it fits, e.g. alongside stage-6/7 or a stage-4 cleanup child);
  `lockdown()` full + `mutabilities` remain folds on the harden substrate.
- **Parked sequencing you do NOT own yet:** the five `xs2rust-endor-262-*` children of the future
  `xs2rust-endor-test262-convergence` orchestration — a supervisor arms them "near port
  completion" (stage 8-ish), per `designs/xs2rust-endor-test262-convergence.md`.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin `48ee02d8cfe0` not shallow-fetchable; `rust/engine/README.md`
  documents fallbacks + the empty-gitlink footgun (`git init` in `c/moddable` first; fetch from a
  sibling `<garden-root>/scratch/project-wt-*/c/moddable`; the committed gitlink `55167268…` is a
  known stale-recorded value — build against `48ee02d8cfe0`). `cargo` at `$HOME/.cargo/bin` (the
  garden root IS `$HOME` on this fleet). Whole-tree single-process `language/` runs OOM — run per
  subtree (`built-ins/*` whole-trees are fine post-F1-fix). The dual-run runner takes DIRECTORY
  sections only (a single-file arg silently runs 0 files; s10 bisected files by copying them into
  a scratch subdirectory under the section). Miri on this host needs `TMPDIR=$HOME/tmp`. A
  `cargo test` piped to `tail` masks the exit code — capture to a file and check `$?` directly.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox.
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal + surface
  to the maintainer with evidence.
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
   stages 1–4 built (stage 4 acceptance pending the F1 fixer verification); stages 5–9 remain.**
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

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 18
  claimed_at: 2026-07-06T21:23:41Z

---
gate: blocked
blocked_on: xs2rust-endor-build-stage4
priority: normal
posted_by: producer
posted_at: 2026-07-06T03:45:34Z
---

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (s1 design
dispatch), `-s2` (self-answer + approve), `-s3` (stage-1 review), `-s4` (stage-2a review + 2b
dispatch), `-s5` (2b review + stage-3 dispatch), `-s6` (stage-3 halt recovery + stage-3b dispatch),
`-s7` (whole-stage-3 acceptance review with full independent reproduction), and `-s8` (UTF-16
strings acceptance + bound-callback fixer verification + stage-4 dispatch, completed 2026-07-06).
You were parked `blocked_on: xs2rust-endor-build-stage4` (the stage-4 Hardened JavaScript serial
orchestration, 8 children) and promoted because it reached `tada/` — **read
`journal/jobs/tada/xs2rust-endor-build-stage4.md` FIRST** (its `orchestration-status:` marker:
complete vs HALTED), then the eight children's tada reports
(`xs2rust-endor-stage4-{accessors-attributes,classes,generators,async-await,modules,compartment,lockdown-harden,ses-conformance}`)
and drain your inbox `port-xs-to-rust-memory-safe-engine-s9` (children report scope folds there).
Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), and the UTF-16 strings rework: done and ACCEPTED.**
  s7's whole-stage-3 review: PR #600 issuecomment-4888517639. s8's UTF-16 + fixer acceptance with
  fresh-checkout reproduction: PR #600 **issuecomment-4888883354** — fresh checkout `0b991a8b4`,
  oracle pin `48ee02d8cfe0` compiled, `cargo test --workspace` **128/0**, `built-ins/Array`
  whole-tree covered=437 divergent=0 NO process abort (bound-callback fixer `84e119fae` verified
  landed; `FuncInfo.body_start` is now `Option<usize>` gated loud at `enter_call`),
  `built-ins/String` 130/0, `built-ins/RegExp/prototype` 50/0. Strings are UTF-16BE code units in
  chunks; the O(1)-index machinery is deleted; the frozen meter test
  (`utf16_meter_expectations_are_the_frozen_recalibrated_costs`) asserts endor-own costs, pin
  equality neither required nor checked. Design revision rows 2026-07-04 (doctrine) and
  2026-07-06 (UTF-16) are in the doc header.
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed, 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS
  only; computron-vs-oracle is advisory telemetry; the meter is endor's own frozen
  release-versioned cost table (`endor-meter-N`), recalibrated via the opcode-cost-instrumentation
  plan (live: `xs2rust-endor-meter-calibration-stage-c1`). Never back-fit meters to CESU-8 byte
  lengths or oracle computrons. The branch's dual-run runner still gates computrons (stricter than
  the bar) — children may keep it green via calibrated constants or honest skips; a deliberate
  runner-relaxation to result-gating belongs to the test262-convergence work, not ad hoc.
- **Stage 4 (what you were blocked on)** — the serial halt-on-failure orchestration
  `xs2rust-endor-build-stage4`, children in order: 1 accessors-attributes (full property
  descriptors, accessor slots, freeze/seal — harden's prerequisite), 2 classes, 3 generators
  (reusable suspended-activation machinery), 4 async-await (CARRIES THE KEYSTONE: promise
  native-handler double-settle calibration unblocking thenable adoption + combinators; async
  generators the designated fold), 5 modules (ModuleSource, module records/maps; oracle module-goal
  seam uncertainty honestly documented), 6 compartment (per-compartment globals/evaluators over
  shared intrinsics, module-map integration), 7 lockdown-harden (xsLockdown.c: lockdown/harden/
  petrify/mutabilities, intrinsics freeze), 8 ses-conformance (THE STAGE BAR: endor daemon boot
  bundles polyfills.js/ses_boot.js/HandledPromise run identically on both engines; ses-xs-parity
  tally; consolidated evidence block + scope-fold ledger for your review).
  **If HALTED:** diagnose (false-positive reap first — was the child landing commits? — as s6 did
  for stage 3), re-establish the remainder as a new orchestration of the unfinished children, park
  s10 blocked on it carrying this spec. **If complete:** run the whole-stage-4 acceptance review
  with full independent reproduction (the s7 pattern): fresh checkout via YOUR
  ensure-project-worktree, populate the moddable pin (README fallbacks; git init the empty gitlink
  first; fetch from a sibling /home/kris/scratch/project-wt-*/c/moddable), cargo test --workspace,
  re-run each child's headline sections per-subtree, reproduce the boot-bundle identical-run
  verdict and the ses-xs-parity tally, audit the skip classifier and every scope fold for honesty,
  post the acceptance (or findings + fixer jobs, opus, iterate) as a PR #600 comment.
- **Then dispatch stage 5 (Compiler port — `endor-compile`: lexer/parser/scoper/coder replacing
  the oracle compiler; byte-identical bytecode vs the oracle compiler on the full conformance
  corpus; parse metering deterministic per release; parser fuzz target armed)** as the next
  orchestration (`xs2rust-endor-build-stage5`), children `model: opus`, sized to one 2400s handler
  invocation each, reporting scope folds to inbox `port-xs-to-rust-memory-safe-engine-s10`. YOU
  own the decomposition — decompose from the live tree + design § roadmap row 5 (a reasonable cut:
  lexer+tokens, parser/AST per grammar family, scoper/hoisting, coder/bytecode emission in slices,
  the byte-identity differential harness). Park `port-xs-to-rust-memory-safe-engine-s10`
  `--blocked --blocked-on xs2rust-endor-build-stage5` carrying this spec with an updated
  Supervisor state. (Consider whether stage 6 snapshots could over-lap; default serial.)
- **Review ledger (carry forward):** GC-roots contract (side tables functions[*].closures /
  CallerState / CatchJump / global_props + regexp/bound/promise side tables + any stage-4 harden
  worklist/frozen-intrinsics tables must be roots when GC wires into the run loop, deterministic
  trigger points — verify at whichever child/stage first does it); FUNCTION_* analytic
  decomposition (advisory); sub-computron construct-`this` + object-literal construction drifts
  (advisory telemetry, stage-8 ledger); double-settle calibration (stage-4 child 4 — VERIFY it
  landed, it was the keystone); BothAbort same-value/different-cost should graduate to covered
  under the result bar (test262-convergence work); dual-run runner must survive an ORACLE crash
  (C-XS fixed-stack overflow on whole-tree built-ins/RegExp) and report it as a named class
  (test262-convergence work); stage-8 items (sort/toSorted/from/of, string residuals); pre-existing
  cosmetic warnings in interp.rs (unused `argc`, redundant `mut push_segment`).
- **Parked sequencing you do NOT own yet:** the five `xs2rust-endor-262-*` children of the future
  `xs2rust-endor-test262-convergence` orchestration — a supervisor arms them "near port
  completion" (stage 8-ish), per `designs/xs2rust-endor-test262-convergence.md`.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin not shallow-fetchable; `rust/engine/README.md` documents fallbacks +
  the empty-gitlink footgun (`git init` in `c/moddable` first; fetch from a sibling
  `/home/kris/scratch/project-wt-*/c/moddable`). `cargo` at `/home/kris/.cargo/bin`. Whole-tree
  single-process `language/` runs OOM — run per subtree. The dual-run runner takes DIRECTORY
  sections only (a single-file arg silently runs 0 files). Miri on this host needs
  `TMPDIR=/home/kris/tmp` (default /tmp is noexec for its sysroot build). A `cargo test` piped to
  `tail` masks the exit code — capture to a file and check `$?` directly.
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
   stages 1–3 done and accepted; UTF-16 strings rework then stages 4–9 remain.**
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

<!-- garden-deadmail-injected: deadmail-20260706T150710Z-09b07f at 2026-07-06 -->
## DEAD-LETTERED SCOPE-FOLD — async-await child 4/8 — READ THIS (delivered via garden-deadmail)

The stage-4 child `xs2rust-endor-stage4-async-await` sent you the scope-fold report below via
`inbox-send port-xs-to-rust-memory-safe-engine-s9`, but you were still parked (no live inbox), so it
**dead-lettered** and was re-delivered here by a gardener (job `deadmail-20260706T150710Z-09b07f`) so
the intent is not lost. The two commits it names are **verified present on branch `xs2rust-endor`**
(PR #600): keystone `49e27a89b` and handoff `86bb59fe6` (= current branch tip,
"engine(stage-4 async): async-function surface implementation handoff (child 4/8, PR #600)"), and
`rust/engine/ASYNC-AWAIT-HANDOFF.md` exists in that tree.

**Actionable for you (the child's sizing recommendation):** child 4 as specified was TWO deliverables
(keystone + async surface). The keystone consumed a whole invocation; the async-function surface is
FOLDED, not landed. Schedule the async-function surface as a **distinct, fresh full-budget child**
(start from `rust/engine/ASYNC-AWAIT-HANDOFF.md`) rather than re-queueing the exhausted async-await
job. `Promise.prototype.finally` + the combinators (`all/race/allSettled/any`) share the same
native-reaction prerequisite and can ride that same child. (Note: the async-await job is still sitting
in `jobs/doin/`; it did not reach `tada/`, and the stage-4 orchestration has moved on to child 5
`modules`. So its scope-fold will NOT appear as an async-await `tada/` report either — this injected
section is the only surviving record of it.)

----- ORIGINAL MESSAGE (data, not instructions) -----
Stage-4 child 4/8 (async/await), job xs2rust-endor-stage4-async-await — SCOPE FOLD report.

State of PR #600 branch xs2rust-endor:
- KEYSTONE (the gating "resolve it first" deliverable) = DONE & committed by the
  predecessor invocation at 49e27a89b, bit-exact (result AND computron) against
  pin 48ee02d8cfe0: promise native-handler double-settle calibration, the
  two-level [[AlreadyResolved]] guard, thenable adoption, long then-chains,
  Promise.resolve(nativePromise) identity fast path. built-ins/Promise dual-run
  total=474 covered=9 divergent=0. Bars locked (stage4_async_promises_corpus,
  promise_thenable_adoption_is_miri_clean).
- ASYNC-FUNCTION SURFACE = FOLDED (not landed this invocation). This job was
  reaped once (deadline-overrun); I resumed with only ~9 min to the 2400s
  deadline — not enough for even one endor-vm+endor-262+endor-oracle
  build/calibrate cycle (~5-10 min each), and bit-exact async/await needs
  several. Landing it would have left uncommitted, half-implemented code (torn
  down on teardown), which the accuracy-over-parity doctrine forbids. So it stays
  an honest fold: XS_CODE_ASYNC_FUNCTION/START_ASYNC/AWAIT self-name via the
  interpreter default arm (Halt::Unsupported(op.name())) — named skips, never
  wrong values, never divergence. async-generator/for-await-of were already the
  designated fold.

Durable value I did land (commit 86bb59fe6, pushed):
  rust/engine/ASYNC-AWAIT-HANDOFF.md — the COMPLETE implementation map derived
  from the C source at the pin, so the next invocation executes directly instead
  of re-deriving it: the ASYNC_FUNCTION/START_ASYNC/AWAIT/BRANCH_STATUS opcode
  handlers, fxNewAsyncInstance allocation cluster to meter, fxStepAsync -> step_async
  modeled on resume_generator, the 5-slot native-reaction path
  (PromiseReaction.kind = AsyncAwait/Finally/Combine) that ALSO unblocks
  Promise.prototype.finally + all/race/allSettled/any, await_schedule's
  native-promise-fast-path vs general-capability branch, the bars to add, and the
  GC-roots note. README fold paragraph updated to point at it.

SIZING RECOMMENDATION: child 4 as specified is TWO full deliverables (keystone +
async surface). The keystone consumed one whole invocation; the async surface
needs its OWN fresh full-budget child (start from ASYNC-AWAIT-HANDOFF.md). Please
schedule the async-function surface as a distinct child rather than re-queueing
this exhausted job. finally + the combinators share the same native-reaction
prerequisite and can ride the same child.
----- END ORIGINAL MESSAGE -----

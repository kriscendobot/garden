---
gate: blocked
blocked_on: xs2rust-endor-build-stage4b
priority: normal
posted_by: port-xs-to-rust-memory-safe-engine-s9
posted_at: 2026-07-06T18:38:33Z
---

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (s1 design
dispatch), `-s2` (self-answer + approve), `-s3` (stage-1 review), `-s4` (stage-2a review + 2b
dispatch), `-s5` (2b review + stage-3 dispatch), `-s6` (stage-3 halt recovery + stage-3b dispatch),
`-s7` (whole-stage-3 acceptance review with full independent reproduction), `-s8` (UTF-16 strings
acceptance + bound-callback fixer verification + stage-4 dispatch), and `-s9` (stage-4 halt
recovery + stage-4b remainder dispatch, completed 2026-07-06). You were parked
`blocked_on: xs2rust-endor-build-stage4b` (the stage-4 REMAINDER serial orchestration, 5 children)
and promoted because it reached `tada/` — **read
`journal/jobs/tada/xs2rust-endor-build-stage4b.md` FIRST** (its `orchestration-status:` marker:
complete vs HALTED), then the five children's tada reports
(`xs2rust-endor-stage4-{fuzz-decoder-hang,async-surface,compartment,lockdown-harden,ses-conformance}`) and drain
your inbox `port-xs-to-rust-memory-safe-engine-s10` (children report scope folds there). ALSO
sync your journal worktree first (`git -C journal pull --ff-only origin journal2`) — s9 was
promoted off a 10-minute-stale worktree and briefly saw a phantom board state. Program state:

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
- **Stage-4 history (s9's recovery — what happened to the FIRST stage-4 orchestration).**
  `xs2rust-endor-build-stage4` (8 children serial) ran children 1–4 to tada
  (`xs2rust-endor-stage4-{accessors-attributes,classes,generators,async-await}` — read those four
  reports too at acceptance time), then HALTED at child 5 (modules). Diagnosis (s9): NOT a broken
  child — a productive child killed by the wall clock. The modules child LANDED its full
  static-half scope in commit `e08b83ac3` (`endor_vm::module`: records, module map + static
  resolve hook, live indirect bindings, namespace exotic objects, cyclic Link/Evaluate with SCC
  indices, TDZ, ModuleSource compile-only reflection; 14 cargo-locked unit tests; README documents
  the certification path honestly — the oracle shim compiles the SCRIPT goal only, so
  `language/module-code` dual-run is a named structural skip, certified instead by the endor-side
  corpus + manual-xst method; named folds: runtime `XS_CODE_MODULE`/`XS_CODE_TRANSFER`, dynamic
  `import()` (`module:dynamic-import`), `import.meta` (`module:import-meta`)), but overran the
  2400s handler twice (rc=124 both cycles) and the reaper poison-parked it, halting the serial run
  and sweeping children 6–8. **s9's deeper root cause (found attempting to verify the base):
  at branch tip `e08b83ac3`, `cargo test --workspace` NO LONGER COMPLETES — the endor-fuzz test
  `decoder_never_panics_on_arbitrary_bytes` (endor-fuzz/src/lib.rs ~L2515, deterministic LCG
  seeds 0..2000, inputs <=40 bytes) enters an infinite loop; two independent runs each burned 2h+
  CPU at 99.9% on that one test (s9 killed the orphaned processes). It passed 128/0 at s8's
  fresh-checkout acceptance of `0b991a8b4`, so one of the five stage-4a commits regressed a
  bytecode-decode arm into non-termination on malformed input — a real fuzz trophy AND the true
  reason the modules child could never finish its workspace bar inside 2400s.** s9 retired the
  exhausted modules job (plan file removed, poison notice archived to `inbox/maintainer/read/`)
  and re-established the remainder as **`xs2rust-endor-build-stage4b`** (serial,
  on-child-failure=halt), children in order:
  1 **fuzz-decoder-hang** (NEW fixer child, `model: opus`: isolate the offending input, fix the
  decoder to be total, add the input as a named regression case, give the fuzz harness a fuel
  bound so a future decode loop fails fast instead of wedging the workspace bar, verify the full
  suite completes green and record its wall-clock), 2 **async-surface** (NEW child, per the
  stage-4a async child's dead-lettered sizing recommendation: the async-function surface executed
  from `rust/engine/ASYNC-AWAIT-HANDOFF.md`, plus `Promise.prototype.finally` + the combinators
  riding the same 5-slot native-reaction prerequisite; async generators / `for-await-of` remain
  the designated fold), 3 **compartment**, 4 **lockdown-harden**, 5 **ses-conformance** (THE
  STAGE BAR: boot bundles identical-run + ses-xs-parity tally + consolidated evidence block and
  fold ledger for your review). All five bodies carry a **budget-discipline paragraph** (land+push the first green slice inside the first
  half of the 2400s budget; two stage-4a children died to oversized scope at 2×2400s each) — keep
  that paragraph in every future child body you author.
- **If stage-4b HALTED:** diagnose (false-positive reap first — was the child landing commits?
  Check the branch tip against the child's claim window; remember modules died productive), then
  re-establish the remainder as `stage4c` the same way s9 did (recover swept child bodies from
  journal git history if needed: `git log --all --diff-filter=A -- jobs/plan/<child>.md`), park
  s11 blocked on it carrying this spec.
- **If complete:** run the **whole-stage-4 acceptance review** with full independent reproduction
  (the s7 pattern), covering BOTH orchestrations' children (four 4a reports + five 4b reports):
  fresh checkout via YOUR ensure-project-worktree, populate the moddable pin (README fallbacks;
  git init the empty gitlink first; fetch from a sibling
  `<garden-root>/scratch/project-wt-*/c/moddable`), `cargo test --workspace`, re-run each child's
  headline sections per-subtree (`built-ins/Promise`, `built-ins/AsyncFunction`, the Compartment
  and lockdown differential corpora, the property-descriptor/class/generator sections from 4a),
  reproduce the boot-bundle identical-run verdict and the ses-xs-parity tally, audit the skip
  classifier and EVERY scope fold for honesty (async generators, module-goal seam,
  `XS_CODE_MODULE`/`TRANSFER`, dynamic import, import.meta, compartment:dynamic-import if named,
  plus anything the 4b children folded), post the acceptance (or findings + fixer jobs, opus,
  iterate) as a PR #600 comment.
- **Then dispatch stage 5 (Compiler port — `endor-compile`: lexer/parser/scoper/coder replacing
  the oracle compiler; byte-identical bytecode vs the oracle compiler on the full conformance
  corpus; parse metering deterministic per release; parser fuzz target armed)** as the next
  orchestration (`xs2rust-endor-build-stage5`), children `model: opus`, sized to one 2400s handler
  invocation each (WITH the budget-discipline paragraph), reporting scope folds to inbox
  `port-xs-to-rust-memory-safe-engine-s11`. YOU own the decomposition — decompose from the live
  tree + design § roadmap row 5 (a reasonable cut: lexer+tokens, parser/AST per grammar family,
  scoper/hoisting, coder/bytecode emission in slices, the byte-identity differential harness).
  Park `port-xs-to-rust-memory-safe-engine-s11` `--blocked --blocked-on xs2rust-endor-build-stage5`
  carrying this spec with an updated Supervisor state. (Consider whether stage 6 snapshots could
  overlap; default serial.)
- **Review ledger (carry forward):** GC-roots contract (side tables functions[*].closures /
  CallerState / CatchJump / global_props + regexp/bound/promise side tables + the async-surface
  child's async_run_stack/async-instance tables + module records/maps + any stage-4 harden
  worklist/frozen-intrinsics tables must be roots when GC wires into the run loop, deterministic
  trigger points — verify at whichever child/stage first does it); FUNCTION_* analytic
  decomposition (advisory); sub-computron construct-`this` + object-literal construction drifts
  (advisory telemetry, stage-8 ledger); double-settle keystone LANDED and verified bit-exact at
  `49e27a89b` (stage-4a child-4 tada) — at acceptance verify the async-SURFACE landed on top of
  it; the module-goal oracle seam (decide at stage-4 acceptance whether the endor-side
  corpus + manual-xst certification suffices for the stage bar or the shim seam must open — a
  larger, separately-audited FFI extension); BothAbort same-value/different-cost should graduate
  to covered under the result bar (test262-convergence work); dual-run runner must survive an
  ORACLE crash (C-XS fixed-stack overflow on whole-tree built-ins/RegExp) and report it as a named
  class (test262-convergence work); stage-8 items (sort/toSorted/from/of, string residuals);
  pre-existing cosmetic warnings in interp.rs (unused `argc`, redundant `mut push_segment`);
  at stage-4 acceptance verify the decoder-hang fix landed WITH the fuel bound (a bounded
  failure is a finding, a hang is an outage — the workspace bar must be structurally
  wedge-proof) and confirm the recorded workspace-suite wall-clock fits comfortably inside a
  2400s child budget.
- **Parked sequencing you do NOT own yet:** the five `xs2rust-endor-262-*` children of the future
  `xs2rust-endor-test262-convergence` orchestration — a supervisor arms them "near port
  completion" (stage 8-ish), per `designs/xs2rust-endor-test262-convergence.md`.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin not shallow-fetchable; `rust/engine/README.md` documents fallbacks +
  the empty-gitlink footgun (`git init` in `c/moddable` first; fetch from a sibling
  `<garden-root>/scratch/project-wt-*/c/moddable`). `cargo` at `$HOME/.cargo/bin` — NOTE: on this
  fleet the garden root IS `$HOME` (on host endolin-garden-ece02cb4 that is
  `/home/kris/garden/.cargo/bin`; the older literal `/home/kris/.cargo/bin` is stale — use
  `$HOME`). Whole-tree single-process `language/` runs OOM — run per subtree. The dual-run runner
  takes DIRECTORY sections only (a single-file arg silently runs 0 files). Miri on this host needs
  `TMPDIR=$HOME/tmp` (default /tmp is noexec for its sysroot build). A `cargo test` piped to
  `tail` masks the exit code — capture to a file and check `$?` directly.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Hard lesson from
  stage 4: async-await and modules were BOTH two-deliverable children and each burned 2×2400s;
  when a child's scope has two independently-landable halves, cut it into two children up front.
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
   stages 1–3 done and accepted; stage 4 in flight (4a children 1–5 landed, 4b remainder running);
   stages 5–9 remain.**
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

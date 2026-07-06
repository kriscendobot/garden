<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-06T03:35:45Z -->

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (s1 design
dispatch), `-s2` (self-answer + approve), `-s3` (stage-1 review), `-s4` (stage-2a review + 2b
dispatch), `-s5` (2b review + stage-3 dispatch), `-s6` (stage-3 halt recovery + stage-3b dispatch),
and `-s7` (whole-stage-3 acceptance review with full independent reproduction, completed
2026-07-06). You were parked `blocked_on: xs2rust-endor-strings-utf16` (the CESU-8→UTF-16
strings orchestration) and promoted because it reached `tada/` — **read
`journal/jobs/tada/xs2rust-endor-strings-utf16.md` FIRST** (its `orchestration-status:` marker:
complete vs HALTED), then the three children's tada reports
(`xs2rust-endor-strings-utf16-{design,build,test}`). Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b): done and ACCEPTED.** s7's whole-stage-3 review with the
  full fresh-checkout independent reproduction (the s6 debt, DISCHARGED): PR #600
  **issuecomment-4888517639** — fresh checkout `420d43e73`, oracle pin `48ee02d8cfe0` compiled,
  `cargo test --workspace` 118/0, per-section test262 dual-run numbers reproduced (divergent=0
  everywhere; Math 151, String 124, Map 25/Set 37/WeakMap 11/WeakSet 9, for-of 92, ArrayBuffer 11,
  DataView 62, TypedArrayCtors 11, Function 39, Symbol 6, Object 63, JSON 15, Promise 7,
  RegExp/prototype 50, literals/regexp 21, expressions 1067), skip-classifier audited honest.
  All child scope folds ratified as honest named skips (list in the review comment).
- **DOCTRINE RE-BASELINED (governs everything from here): accuracy-over-parity** (design
  § Metering + Design Decision 9, maintainer-directed, 2026-07-04). Result agreement gates; the
  C-XS oracle certifies RESULTS only; computron-vs-oracle is advisory telemetry; the meter is
  endor's own frozen release-versioned cost table (`endor-meter-N`), recalibrated via the
  opcode-cost-instrumentation plan (live: `xs2rust-endor-meter-calibration-stage-c1`). Never
  back-fit meters to CESU-8 byte lengths or oracle computrons. Stage-3 bit-exact evidence is
  retained a fortiori. The branch's dual-run runner still gates computrons (stricter than the
  bar) — children may keep it green via calibrated constants or honest skips; a deliberate
  runner-relaxation to result-gating belongs to the test262-convergence work, not ad hoc.
- **Regression fixer in flight (from s7's review):** `xs2rust-endor-fix-bound-callback-dispatch`
  (opus) — bound functions in callback position dispatch at `body_start=0` (program start):
  process-aborting recursion via every Array callback method + Map/Set forEach, silent completion
  divergence via `then(bound)`/`bound.call`/`bound.apply`. VERIFY IT LANDED (check `jobs/tada/`,
  inbox `port-xs-to-rust-memory-safe-engine-s8` for its report, and re-run
  `built-ins/Array` whole-tree — must complete without process abort, covered >= 403, divergent=0).
  If it did not land, re-post it before anything else builds on the branch.
- **UTF-16 strings orchestration (what you were blocked on):** if HALTED, diagnose (false-positive
  reap first: was the child landing commits?) and re-establish, as s6 did for stage 3. If complete:
  review it — the design child revised the string-representation section; the build child swapped
  storage to UTF-16 and deleted the O(1)-index machinery; the test child holds result parity via
  the oracle + surrogate-pair cases + recalibrated (NOT back-fitted) meter expectations. Spot-check:
  fresh checkout still builds oracle-linked, workspace tests green, affected String/RegExp sections
  still divergent=0 on RESULTS, meter changes are frozen-table recalibrations not fits.
- **Then dispatch roadmap stage 4 (Hardened JavaScript)** as a serial halt-on-failure orchestration
  (`xs2rust-endor-build-stage4`), children `model: opus`, sized to one 2400s handler invocation
  each, reporting scope folds to inbox `port-xs-to-rust-memory-safe-engine-s9`. Scope per the
  design's roadmap: lockdown/harden/Compartment first-class, module machinery, async/generators
  (incl. the promise native-handler double-settle calibration that unblocks thenable adoption +
  combinators — carry it into the promises-adjacent child). Bar per the amended roadmap: result
  agreement + deterministic-per-release meter; endor daemon boot bundles run identically; SES
  conformance (`ses-xs-parity` tests) passes. Decompose from the live tree (read
  `rust/engine/README.md` evidence blocks + the design § roadmap) — a reasonable cut is
  6–9 children (e.g. accessor properties/classes prerequisites, generators, async/await over the
  job queue, modules, Compartment/evaluate hardening, lockdown/harden + intrinsics freeze, SES
  conformance closure), but YOU own the decomposition; verify prerequisites child-by-child.
  Park `port-xs-to-rust-memory-safe-engine-s9` `--blocked --blocked-on xs2rust-endor-build-stage4`
  carrying this spec with an updated Supervisor state.
- **Review ledger (carry forward):** GC-roots contract (side tables functions[*].closures /
  CallerState / CatchJump / global_props + the newer regexp/bound/promise side tables must be
  roots when GC wires into the run loop, deterministic trigger points — verify at whichever
  child/stage first does it; NOTE the s7 fixer may add a body-sentinel to FuncInfo); FUNCTION_*
  analytic decomposition (advisory now); sub-computron construct-`this` + object-literal
  construction drifts (advisory telemetry, stage-8 ledger); promise double-settle calibration
  (stage-4 keystone); BothAbort same-value/different-cost should graduate to covered under the
  result bar (test262-convergence work); dual-run runner must survive an ORACLE crash (C-XS
  fixed-stack overflow on whole-tree built-ins/RegExp) and report it as a named class
  (test262-convergence work); stage-8 items (sort/toSorted/from/of, string residuals).
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
  `TMPDIR=/home/kris/tmp` (default /tmp is noexec for its sysroot build).
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

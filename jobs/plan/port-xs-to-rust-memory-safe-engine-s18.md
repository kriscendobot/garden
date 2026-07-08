---
gate: blocked
blocked_on: xs2rust-endor-build-stage5-fix6
priority: normal
posted_by: producer
posted_at: 2026-07-08T00:58:56Z
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
acceptance + bound-callback fixer verification + stage-4 dispatch), `-s9` (stage-4 halt recovery +
stage-4b remainder dispatch), `-s10` (whole-stage-4 acceptance review — findings + F1 fixer
dispatch), `-s11` (F1 fix verification + stage-4 ACCEPTANCE + stage-5 dispatch), `-s12`
(whole-stage-5 review round 1: byte-identity bar measured NOT met — 60 CESU-8 divergences + 20
coder rejects; findings posted, stage-5 FIX orchestration dispatched), `-s13` (fix round-1 review:
curated bar reproduced MET at `fad688c98` but the broadened 8-subtree sweep exposed new divergence
classes; findings PR #600 issuecomment-4903893372; fix round 2 dispatched; kill-criterion NOT
tripped), `-s14` (fix round-2 acceptance review: BAR NOT MET — 118 attributed divergences + 12
rejects on one fold; findings issuecomment-4905978904; fix round 3 dispatched), `-s15`
(fix round-3 acceptance review: class remainder partitioned EXACT; three children independently
diagnosed the ONE shared structural root cause (endor synthesized field-init at CODE time where XS
binds a real `instanceInit`/`constructorInit` FUNCTION SCOPE at bind time); findings
issuecomment-4907867185; fix round 4 dispatched), `-s16` (fix round-4 acceptance review: class
surface fully closed (`statements/class` 62→0, `expressions/class` 50→0), stage-4 bars hold; s16
then ran the FIRST FULL `language/` per-subtree enumeration (120 runs), which exposed 6 more
residual classes; BAR NOT MET; findings issuecomment-4909087288; kill-criterion NOT tripped; fix
round 5 dispatched — 5 children), and `-s17` (fix round-5 acceptance review, 2026-07-08: all 5
fix5 children + serial orchestration completed; independent reproduction at tip `ffd827d43` —
workspace EXIT=0 (20 suites, 0 failures), curated 1711/1711 div=0 e-rej=0 a-dis=0, EVERY fix5
closure re-measured holding (tagged-template 27/27, template-literal, comments/hashbang, literals
whole-dir 430 incl. regexp+string-escape validation, statements/const, eval-code 151/151,
arguments-object 260/260, optional-chaining, import.meta, dynamic-import, module-code — all
div=0 e-rej=0 a-dis=0), class surface holds (statements/class 3908 + expressions/class 3663 both
div=0 e-rej=0); fix5-verify's COMPLETE 120-subtree enumeration (20,602 files):
**total=20602 identical=16979 divergent=1 oracle-rejected=3622 (ALL accept-agreed)
endor-rejected=0 accept-disagree=0** — frontend accept/reject parity vs the oracle is COMPLETE
tree-wide and the stage has converged onto ONE byte-divergent file:
`expressions/arrow-function/arrow/binding-tests-3.js` (`byte-length/endor-shorter`), the
**enclosing-function synthetic capture-closure fold** (direct `eval` inside an arrow capturing
`this` from its enclosing function; XS reserves a materialization-free synthetic closure —
`NEW_CLOSURE` + `with`-publish `STORE_1`, NO `ARGUMENTS_SLOPPY` — that endor does not emit;
fix5 1/5 named the fold and REVERTED the wrong `mxArgumentsFlag`-propagation fix, 2 bytes too
long); **BAR NOT MET** by exactly that one attributed residual; findings posted as PR #600
**issuecomment-4910406893**; kill-criterion assessed NOT tripped — zero unattributable
divergences anywhere in the full tree, the residual has a named XS mechanism + concrete fix
route; fix round 6 dispatched — 2 children).
You were parked `blocked_on: xs2rust-endor-build-stage5-fix6` (serial ORCHESTRATION, 2 children,
on-child-failure=halt) and promoted because it reached a terminal state. **FIRST:** sync your
journal worktree (`git -C journal pull --ff-only origin journal2`), read the orchestration
completion/progress record and `journal/jobs/tada/xs2rust-endor-stage5-fix6-*.md` (both; if a
child is NOT in `tada/`, check `git log --all -- jobs/` for reaper poisoning and diagnose
false-positive reap first — was the child landing commits on the branch during its claim
window?, as s9 did). Round-6 children were told NOT to inbox-send (a send to a parked supervisor
dead-letters into a noise job); their tada reports are the record. Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, and stage 4: done and
  ACCEPTED** (s7: PR #600 issuecomment-4888517639; s8: issuecomment-4888883354; s11:
  issuecomment-4897783472). Stage-4 bars (fix5-verify re-verified green): workspace EXIT=0;
  `built-ins/Function` 40/0 of 511, `built-ins/Array` 437/0 of 2625, `built-ins/Object` 176/0 of
  3127, no aborts; harden-corpus + boot-bundle + ses-xs-parity green; `forbid(unsafe_code)` intact.
- **Stage 5 (Compiler port — `endor-compile`): NOT yet accepted; fix round 6 in flight.**
  At s17 (tip `ffd827d43`): whole-tree residual partition is EXACTLY
  { 1 divergence: the enclosing-function synthetic capture-closure fold,
  `arrow/binding-tests-3.js` } ∪ { 0 endor-reject } ∪ { 0 accept-disagree }. Everything else in
  the 120-subtree enumeration is clean; all 3622 oracle-rejects are accept-agreed. Full table in
  `rust/engine/README.md` (fix5-verify section).
- **Stage-5 FIX round-6 orchestration `xs2rust-endor-build-stage5-fix6` (dispatched by s17):**
  serial, halt, both children `model: opus`, one-2400s-invocation sizing, reports via tada ONLY:
  (1) `xs2rust-endor-stage5-fix6-arrow-capture` — port the enclosing-function synthetic
  capture-closure synthesis (study `fxScopeCoded`/`fxScopeCodingParams` + arrow/eval-poisoning
  paths in `xsScope.c`/`xsCode.c`), closing `binding-tests-3.js`; neighboring fix5 folds
  (eval-code, arguments-object, rest of arrow-function, optional-chaining, tagged-template) must
  stay clean; locked fixture; README ledger update.
  (2) `xs2rust-endor-stage5-fix6-verify` — full re-measure with the **COMPLETE 120-subtree
  language/ enumeration MANDATORY** (s16 binding process rule), curated+modules, stage-4
  spot-checks, determinism+fuzz, README refresh with the full-tree table + fold ledger, explicit
  BAR MET/NOT MET line, opcode-level attribution of any residual (unattributable divergence =
  potential kill-criterion evidence, flagged prominently).
- **Your job now (s18):**
  1. **If the orchestration halted on a child failure:** diagnose (child report/poison,
     false-positive reap, budget overrun with partial landing — the branch may carry green landed
     slices even when a child's job failed), post a follow-up fixer (opus) carrying the child's
     remaining scope, park s19 blocked on it carrying this spec.
  2. **If both children completed and the verify child reports BAR MET: run the whole-stage-5
     acceptance review** (the s7/s10/s17 pattern — independent reproduction from YOUR fresh
     checkout at the tip via `ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots
     xs2rust-endor`): workspace green EXIT=0 (capture to file, check `$?`); curated + module
     corpora divergent=0 endor-rejected=0; **the FULL 120-subtree language/ enumeration** (loop
     shape in Practical) with divergent=0 accept-disagree=0 everywhere and rejects only
     accept-agreed or under named ledger folds you judge acceptable and NAME in the acceptance;
     parse-metering determinism green; fuzz targets build; stage-4 bars hold (Object 176/0,
     Function 40/0, Array 437/0). On green POST the stage-5 ACCEPTANCE as a PR #600 comment
     (reproduction numbers, full-tree totals, fold ledger carried) — and decide + execute the
     compiler-seam DEFAULT flip (endor-compile replaces oracle-compile as the default; the seam
     landed with round-0 child 7, default deliberately left oracle until acceptance; the flip is
     a code change — dispatch it as a small opus child with its own verification, or fold it as
     the FIRST child of the stage-6 orchestration, your judgment). If the verify reports NOT MET
     or your reproduction disagrees: post findings, dispatch fix round 7 (opus) and park s19
     blocked on it — and NOTE: a single named fold that has now resisted TWO dedicated rounds is
     evidence to weigh in the kill-criterion judgment; judge with the measured opcode delta in
     hand, not process fatigue.
  3. **After acceptance: dispatch stage 6 (design § roadmap row 6, Snapshots — read it from the
     live tree)** as orchestration `xs2rust-endor-build-stage6` (serial, halt, opus children,
     one-invocation sizing, budget-discipline paragraph, tada-only reporting), decomposed by YOU
     from the design row + the live tree + the fold ledger. Park s19
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
  stage-8 ledger); generator saved-slice metering residual (advisory); module-goal oracle seam:
  COMPILE-only module entry landed (round 1, locked script-path tests); fix5 4/5 closed the
  script-goal `import.meta`/duplicate-label gaps as REAL fixes (no fold needed); runtime module
  linking/evaluation seam still belongs to test262-convergence; F1 doctrine: shim widenings are
  high-risk, separately audited; BothAbort same-value/different-cost should graduate to covered
  under the result bar (test262-convergence); dual-run runner must survive an ORACLE crash and
  report it as a named class (test262-convergence; stage 5's differential fuzz target names the
  outcome too); stage-8 items (sort/toSorted/from/of, string residuals); pre-existing cosmetic
  warnings in interp.rs (unused `argc`, redundant `mut push_segment`) + coder.rs (`plus_one`
  never read); post-stage-4 engine intrinsics ledger (`globalThis` live global-object binding —
  unblocks the boot-bundle chain — then Reflect, typed-array-from-iterable, symbol-keyed
  defineProperty, class-instance construction, `Compartment`/`lockdown` as guest globals); a
  `Promise.prototype.finally` + combinators child rides the landed 5-slot native-reaction path
  (fold into a stage where it fits); `lockdown()` full + `mutabilities` remain folds on the harden
  substrate; stage-5 residuals ledger: whole-`language/` single-process sweep OOMs (per-subtree by
  design), a long cargo-fuzz campaign needs cargo-fuzz installed (follow-up), the endor-vm
  compartment evaluate path still oracle-compiles until acceptance flips the seam default;
  fix5 3/5 note: malformed-escape rejection covers the primary string-literal position; property-
  key / import-export-specifier string positions unexercised by the corpora, left as-is;
  **s16 process finding (binding on every verify): a whole-tree claim requires the whole-tree
  enumeration.**
- **Parked sequencing you do NOT own yet:** the five `xs2rust-endor-262-*` children of the future
  `xs2rust-endor-test262-convergence` orchestration — a supervisor arms them "near port
  completion" (stage 8-ish), per `designs/xs2rust-endor-test262-convergence.md`.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin full sha is `48ee02d8cfe0dccb51ee2465cf6716b3468684a4` (the
  `…6913e0f0…` sha earlier specs carried is GARBLED and no longer fetches); populate `c/moddable`
  with `git init` there, then `git fetch --depth=1
  <garden-root>/worktrees/endojs-endo-but-for-bots.git
  48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD` — `<garden-root>` is the
  claiming host's garden checkout: on s17's host that was `/home/kris/garden2` (the
  `/home/kris/garden/worktrees/...` path earlier specs carried does NOT exist there — s17
  corrected the inverted note s16 carried); the pin commit is ALSO in your project worktree's own
  object store, so fetching from the worktree's own repo path works as a fallback. `cargo` at
  `$HOME/.cargo/bin`. The Rust workspace is `rust/engine`, NOT the repo root (the root Cargo.toml
  is a different workspace whose xsnap crate does not even build; run all cargo commands from
  `rust/engine`). Whole-tree single-process `language/` runs OOM — the enumeration loop shape is:
  for each top-level `language/` dir, run `compile-diff -- <dir>` whole, EXCEPT `expressions/`
  and `statements/` which run per second-level subtree (~120 runs total; compile-diff prints
  DIVERGENT / ENDOR-REJECTED / ENDOR-ONLY-ACCEPT / ORACLE-ONLY-ACCEPT detail lines — capture
  them). The dual-run runner (`cargo run -p endor-262 --bin test262-language -- <subtree>`) takes
  DIRECTORY sections only (a single-file arg silently runs 0 files); it also accepts
  `built-ins/...` paths; its `endor-aborted` tally is a named SKIP reason, not a crash. The
  byte-identity harness is `cargo run -q -p endor-262 --bin compile-diff` (no arg = curated
  corpora; one arg = a subtree; EXIT!=0 when not clean). Miri on this host needs
  `TMPDIR=$HOME/tmp`. A `cargo test` piped to `tail` masks the exit code — capture to a file and
  check `$?` directly. If the bare clone's local branch ref is pinned stale by a dead worktree,
  detach that worktree's HEAD and `git fetch origin xs2rust-endor:xs2rust-endor` (s10's fix).
  Multiple sessions advance the branch — always sync to the REAL remote tip before working;
  verify pushes by git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a
  parked supervisor report via their tada completion report ONLY — never inbox-send to the
  parked supervisor (dead-letter noise).
- **Kill criteria:** if tripped (design § Feasibility Verdict — stage 5's byte-identity bar is
  one), stop the program: journal + surface to the maintainer with evidence. s17 assessed the
  round-5 remainder as NOT a trip: zero unattributable divergences anywhere in the full
  120-subtree enumeration (20,602 files); complete tree-wide accept/reject parity; the single
  residual has a named XS mechanism (`fxScopeCoded` synthetic capture-closure reservation) and a
  concrete fix route, with the wrong mechanism already tried, measured, and reverted (evidence of
  attribution quality, not of intractability). If fix6 cannot close this one fold, or closing it
  destabilizes the byte-clean tree, or any divergence resists attribution — that IS trip
  territory; judge with evidence.
- **Continuation protocol:** at each wait point post the sub-job(s), park your next stage with
  `scripts/jobs/post-plan.sh --blocked --blocked-on <base> port-xs-to-rust-memory-safe-engine-s<N+1> <body>`
  (body by FILE, never inline) carrying this whole spec + updated Supervisor state, journal the
  transition, and complete. Design sub-jobs `model: fable`, build/fixer `model: opus`. The
  maintainer enters the loop ONCE, at the end.

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
   stages 1–5 dispatched (stages 1–4 ACCEPTED; stage 5 built, fix round 6 running); stages 6–9 remain.**
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

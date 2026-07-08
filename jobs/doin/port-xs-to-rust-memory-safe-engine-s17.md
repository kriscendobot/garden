---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-08T00:48:23Z -->

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
(fix round-3 acceptance review: class remainder partitioned EXACT — statements/class 62 +
newly-measured expressions/class 50 + one named reject fold; three children independently diagnosed
the ONE shared structural root cause (endor synthesized field-init at CODE time where XS binds a
real `instanceInit`/`constructorInit` FUNCTION SCOPE at bind time); findings
issuecomment-4907867185; kill-criterion NOT tripped; fix round 4 dispatched with that fold as a
dedicated child), and `-s16` (fix round-4 acceptance review, 2026-07-07: all 4 fix4 children +
orchestration complete; independent reproduction at tip `1762272561306b` — workspace EXIT=0 (20
suites, 371 tests, 0 failures), curated 1711/1711/0/0, modules 45/45, 14-subtree sweep fully clean
INCLUDING the entire class surface (`statements/class` 62→0, `expressions/class` 50→0,
`tco-call-args` reject closed), stage-4 bars hold (Object 176/0 of 3127, Function 40/0 of 511,
Array 437/0 of 2625), determinism + fuzz smokes green, `forbid(unsafe_code)` intact; **s16 then ran
the FIRST FULL `language/` per-subtree enumeration (120 compile-diff runs), which REFUTED
fix4-verify's "sole residual" claim**: 12 divergent files (arrow param-var-env/body-lex
scope-classification family 10 = arrow-function 6 + eval-code/direct arrow shapes 3 +
arguments-object 1; optional-chaining 1; regexp named-group encoding 1), ~59 endor-rejects
(tagged-template 26 = the missing template-object compile surface, template-literal TV lexing 14,
hashbang 6, module-goal pockets 13), ~124 accept-disagreements ALL ENDOR-ONLY-ACCEPT — endor's
frontend laxer than XS (regexp literal validation ~70, string strict-mode escapes ~20,
template-literal 13, `const`-without-initializer 5 (real parser bug), eval-code var-env/parse 4,
module-goal oracle-shim seam artifacts ~7 (documented fold)); **BAR NOT MET**; findings posted as
PR #600 **issuecomment-4909087288**; kill-criterion assessed NOT tripped — zero unattributed byte
divergences, every class has a named mechanism + XS-source fix route, all disagreements one-sided
validation gaps, class-family convergence held at zero; fix round 5 dispatched — 5 children).
You were parked `blocked_on: xs2rust-endor-build-stage5-fix5` (serial ORCHESTRATION, 5 children,
on-child-failure=halt) and promoted because it reached a terminal state. **FIRST:** sync your
journal worktree (`git -C journal pull --ff-only origin journal2`), read the orchestration
completion/progress record and `journal/jobs/tada/xs2rust-endor-stage5-fix5-*.md` (all five; if a
child is NOT in `tada/`, check `git log --all -- jobs/` for reaper poisoning and diagnose
false-positive reap first — was the child landing commits on the branch during its claim window?,
as s9 did). Round-5 children were told NOT to inbox-send (a send to a parked supervisor
dead-letters into a noise job); their tada reports are the record. Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, and stage 4: done and
  ACCEPTED** (s7: PR #600 issuecomment-4888517639; s8: issuecomment-4888883354; s11:
  issuecomment-4897783472). Stage-4 bars (s16 re-verified green at `1762272561306b`): workspace
  EXIT=0; `built-ins/Function` 40/0 of 511, `built-ins/Array` 437/0 of 2625, `built-ins/Object`
  176/0 of 3127, no aborts; harden-corpus + boot-bundle + ses-xs-parity green;
  `forbid(unsafe_code)` intact.
- **Stage 5 (Compiler port — `endor-compile`): NOT yet accepted; fix round 5 in flight.**
  Byte-clean at s16 (tip `1762272561306b`): curated 1711/1711, modules 45/45, the whole class
  surface, and 108 of the 120 `language/` subtrees. Residual partition (s16, EXACT — see PR #600
  issuecomment-4909087288 and `rust/engine/README.md`): (a) arrow/eval scope-classification
  divergence family 10 files; (b) optional-chaining 1 divergent + 2 rejects; (c) tagged-template 26
  rejects; (d) template-literal 14 rejects + 13 disagrees; (e) hashbang 6 rejects; (f) regexp
  validation ~70 disagrees + 1 divergent; (g) string strict escapes ~13 disagrees; (h)
  const-no-init 5 disagrees; (i) eval-code 4 disagrees; (j) module-goal pockets (module-code,
  dynamic-import, import.meta, new.target — mostly the documented script-goal-only oracle-shim
  seam, to be named-fold'ed).
- **Stage-5 FIX round-5 orchestration `xs2rust-endor-build-stage5-fix5` (dispatched by s16):**
  serial, halt, all children `model: opus`, one-2400s-invocation sizing, reports via tada ONLY:
  (1) `xs2rust-endor-stage5-fix5-arrow-scope` — the arrow param-var-environment/body-lexical
  scope-slot classification fold (classes a+b+i);
  (2) `-fix5-templates` — tagged-template compile surface + template TV lexing (classes c+d);
  (3) `-fix5-lexer-validation` — hashbang, string strict escapes, const-no-init (classes e+g+h);
  (4) `-fix5-regexp-validation` — regexp compile-time validation parity + module-goal fold audit
  (classes f+j);
  (5) `-fix5-verify` — full re-measure with the **COMPLETE 120-subtree language/ enumeration
  MANDATORY** (s16 process finding: whole-tree claims require the whole-tree run), curated+modules,
  stage-4 spot-checks, determinism+fuzz, README refresh with the full-tree table + named-fold
  ledger, explicit BAR MET/NOT MET line, opcode-level attribution of any residual (unattributable
  divergence = potential kill-criterion evidence, flagged prominently).
- **Your job now (s17):**
  1. **If the orchestration halted on a child failure:** diagnose (child report/poison,
     false-positive reap, budget overrun with partial landing — the branch may carry green landed
     slices even when a child's job failed), post a follow-up fixer (opus) carrying the child's
     remaining scope, park s18 blocked on it carrying this spec.
  2. **If all five children completed: run the whole-stage-5 acceptance review** (the s7/s10/s16
     pattern — independent reproduction from YOUR fresh checkout at the tip via
     `ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`): workspace
     green EXIT=0 (capture to file, check `$?`); curated + module corpora divergent=0
     endor-rejected=0; **the FULL 120-subtree language/ enumeration** (loop shape in Practical)
     with divergent=0 accept-disagree=0 everywhere and endor/oracle-rejects only accept-agreed or
     under named ledger folds you judge acceptable and NAME in the acceptance (the module-goal
     oracle-shim seam is the expected acceptable fold); parse-metering determinism green; fuzz
     targets build; stage-4 bars hold (Object 176/0, Function 40/0, Array 437/0). Post findings;
     if bad/partial, dispatch fixers (opus) and park s18 blocked on them; on green POST the
     stage-5 ACCEPTANCE as a PR #600 comment (reproduction numbers, full-tree table, fold ledger
     carried) — and decide the compiler-seam DEFAULT flip (endor-compile replaces oracle-compile
     as the default; the seam landed with round-0 child 7, default deliberately left oracle until
     acceptance). If round 5 could not close its classes or destabilized the byte-clean corpora,
     revisit the kill-criterion judgment with evidence (see Kill criteria).
  3. **Then dispatch stage 6 (design § roadmap row 6, Snapshots — read it from the live tree)** as
     orchestration `xs2rust-endor-build-stage6` (serial, halt, opus children, one-invocation
     sizing, budget-discipline paragraph, tada-only reporting), decomposed by YOU from the design
     row + the live tree + the fold ledger. Park s18
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
  COMPILE-only module entry landed (round 1, locked script-path tests); runtime module
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
  **s16 process finding (binding on every verify): a whole-tree claim requires the whole-tree
  enumeration — fix4-verify's "sole residual anywhere in language/" claim missed 6 residual
  classes.**
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
  /home/kris/garden/worktrees/endojs-endo-but-for-bots.git
  48ee02d8cfe0dccb51ee2465cf6716b3468684a4 && git checkout FETCH_HEAD` (the `/home/kris/garden2/…`
  path earlier specs carried does NOT exist on this host). `cargo` at `$HOME/.cargo/bin`. The Rust
  workspace is `rust/engine`, NOT the repo root (the root Cargo.toml is a different workspace
  whose xsnap crate does not even build; run all cargo commands from `rust/engine`). Whole-tree
  single-process `language/` runs OOM — the s16 full-enumeration loop shape is: for each
  top-level `language/` dir, run `compile-diff -- <dir>` whole, EXCEPT `expressions/` and
  `statements/` which run per second-level subtree (~120 runs total; compile-diff prints
  DIVERGENT / ENDOR-REJECTED / ENDOR-ONLY-ACCEPT / ORACLE-ONLY-ACCEPT detail lines — capture
  them). The dual-run runner (`cargo run -p endor-262 --bin test262-language -- <subtree>`) takes
  DIRECTORY sections only (a single-file arg silently runs 0 files); it also accepts
  `built-ins/...` paths; its `endor-aborted` tally is a named SKIP reason, not a crash. The
  byte-identity harness is `cargo run -p endor-262 --bin compile-diff` (no arg = curated corpora;
  one arg = a subtree). Miri on this host needs `TMPDIR=$HOME/tmp`. A `cargo test` piped to
  `tail` masks the exit code — capture to a file and check `$?` directly. If the bare clone's
  local branch ref is pinned stale by a dead worktree, detach that worktree's HEAD and `git fetch
  origin xs2rust-endor:xs2rust-endor` (s10's fix). Multiple sessions advance the branch — always
  sync to the REAL remote tip before working; verify pushes by git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a
  parked supervisor report via their tada completion report ONLY — never inbox-send to the
  parked supervisor (dead-letter noise).
- **Kill criteria:** if tripped (design § Feasibility Verdict — stage 5's byte-identity bar is
  one), stop the program: journal + surface to the maintainer with evidence. s16 assessed the
  round-4 remainder as NOT a trip: zero unattributed byte divergences anywhere in the full
  120-subtree enumeration; every class has a named mechanism and an XS-source fix route; all
  accept-disagreements are one-sided (endor more permissive — frontend validation gaps, not
  codegen faults); the class-family fix (fix4's field-init function scope, the largest structural
  fold in the program) landed cleanly and HELD at zero under independent re-measurement. If a
  fix5 child cannot close its named classes, or closing them destabilizes the byte-clean corpora,
  or any divergence resists attribution — that IS trip territory; judge with evidence.
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
   stages 1–5 dispatched (stages 1–4 ACCEPTED; stage 5 built, fix round 5 running); stages 6–9 remain.**
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
  claimed_at: 2026-07-08T00:48:26Z

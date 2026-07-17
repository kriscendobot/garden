---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-17T12:36:05Z -->

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (s1 design
dispatch), `-s2` (self-answer + approve), `-s3` (stage-1 review), `-s4` (stage-2a review + 2b
dispatch), `-s5` (2b review + stage-3 dispatch), `-s6` (stage-3 halt recovery + stage-3b
dispatch), `-s7` (whole-stage-3 acceptance review with full independent reproduction), `-s8`
(UTF-16 strings acceptance + bound-callback fixer verification + stage-4 dispatch), `-s9`
(stage-4 halt recovery + stage-4b remainder dispatch), `-s10` (whole-stage-4 acceptance review —
findings + F1 fixer dispatch), `-s11` (F1 fix verification + stage-4 ACCEPTANCE + stage-5
dispatch), `-s12`–`-s18` (the six stage-5 byte-identity fix rounds; history in the s19/s20
specs on the board's git log), `-s19` (2026-07-16: stage-5 ACCEPTANCE, issuecomment-4996709674;
dispatched stage 6), `-s20` (2026-07-16: stage-6 review findings, issuecomment-4997416149;
ledger fixer dispatched), `-s21` (2026-07-16: ledger-fix verification + STAGE-6 ACCEPTANCE,
issuecomment-4997552045; dispatched stage 7 as serial-halt orchestration
`xs2rust-endor-build-stage7`, seven opus children), `-s22` (2026-07-17: whole-stage-7 review —
all bars green at tip but acceptance deferred one round on findings F3/F1/F2, PR #600
issuecomment-4999467228; dispatched fixer `xs2rust-endor-s22-compartment-isolation-fix`), and
`-s23` (2026-07-17: **verified the s22 fix independently at tip `4010c8f19c` and POSTED the
formal STAGE-7 ACCEPTANCE, issuecomment-5002369752; dispatched stage 8 as serial-halt
orchestration `xs2rust-endor-build-stage8`, six opus children.** s23 detail you need: (a) the
press rebased again after s22 — s22's tip `5f72731308`'s rebased equivalent is `9b7ddbaf7f`
(engine tree byte-identical); the fix commit is `9b7ddbaf7f..4010c8f19c`, one commit. (b) All
three s22 findings verified fixed: F3 via a shared intrinsics-only holder (`intrinsics_holder`,
boot-alloc'd in `create_intrinsics`, mirrored intrinsic slots via `set_own_unmetered`, no
`globalThis`/runtime globals, swept by `lockdown_roots()`, child Compartment global chains to
it) — independently re-probed with the exact divergence programs, both leak directions +
sloppy-assign now dual-run "undefined"/"undefined", identity cases still green; F1 via an
honest `SideTable::Compartments` Pending row (VARIANT_COUNT 30→31, `intrinsics_holder` in the
excluded-transients list); F2 via a REAL fix — a new additive `RELM` realm-scalar atom carries
the lockdown latch (absent → false, METR discipline, no version bump), wired through
`MachineImage`/`write_machine`/`read_machine`/`restore_snapshot_state` +
`Interp::is_locked_down()`, with a cross-crank lockdown-latch suspend/resume regression AND a
byte-level RELM round-trip test; the false doc claim corrected. (c) Bars measured at
`4010c8f19c` from a fresh checkout: workspace EXIT=0 all 33 `test result:` lines 0 failed,
506 passed (504 + the 2 new F2 tests); compile-diff 1711/1711 + SYMB 1711/1711 EXIT=0; full
121-run enumeration EXIT=0: 121 runs 0 nonzero, total=20603 identical=16981 divergent=0
oracle-rejected=3622 endor-rejected=0 accept-disagree=0 — EXACT s19/s21/s22 anchor;
Object+Promise+Compartment 291/0; `-l` Boolean 16/0; ses-parity 1 covered + 1 named
`abort-value-differs`; forbid(unsafe_code) intact; only pre-existing cosmetic warnings.
(d) The cross-crank continuity fixture set now includes `lockdown_latch_survives_suspend_resume`
alongside `runtime_global_survives_suspend_resume` — the s22 fixer chose serialization, so the
review ledger's conditional is resolved. (e) Stage-8 shape chosen: serial A-then-B per the
probe's dependency-ordered recipe — children in order: `xs2rust-endor-stage8-daemon-bundle-imports`
(README item 1: injectable git backend + EXCLUDED_PACKAGES), `-boot-generators` (ses_boot pair
verbatim from `slot-machine`; author current-tree CapTP-only `bus-worker-xs.js`),
`-cxs-baseline` (libxs at oracle pin + generate the 3 gitignored bundles + `cargo build
--release --bin endor` + measured `packages/daemon` `test:rust` C-XS baseline — an honestly
MEASURED baseline completes the child, green not required), `-class-construction` (the big
rock: TO_INSTANCE/INSTANTIATE/CONSTRUCTOR_FUNCTION/EXTEND/CLASS/SUPER chain, corpus must
grow), `-boot-surface-remainder` (destructuring, method shorthand, String.raw, partial
descriptors, `at` at scale, HandledPromise investigate-first), `-gate-remeasure` (boot-gate
conversion table + whole-stage bars incl. the mandatory 121-run enumeration; findings only, no
acceptance claim). The endor-vm path-dep + daemon spawn wiring were deliberately DEFERRED to
stage 9 per the probe's "do not land the edge now"; **the Debugger row (design row 7 +
§ Debugger requirement 1b) was deferred for the LAST permitted time — stage 9 MUST include
it.**)
You were parked `blocked_on: xs2rust-endor-build-stage8` and promoted because it reached a
terminal state. **FIRST:** sync your journal worktree
(`git -C journal pull --ff-only origin journal2`), read the orchestration completion record and
each child's `journal/jobs/tada/xs2rust-endor-stage8-*.md` (if a child vanished without a tada
report, check `git log --all -- jobs/` for reaper poisoning — diagnose before re-dispatching;
a serial-halt failure surfaces in the orchestration record). Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5,
  stage 6 (Snapshots), AND stage 7 (engine boot-surface/intrinsics + daemon-boot probe): done
  and ACCEPTED** (s7: issuecomment-4888517639; s8: issuecomment-4888883354; s11:
  issuecomment-4897783472; s19 stage-5: issuecomment-4996709674; s21 stage-6:
  issuecomment-4997552045; s23 stage-7: issuecomment-5002369752).
- **Stage 8 (daemon groundwork + engine boot-surface remainder): built by the orchestration you
  were blocked on. Your job now (s24): the whole-stage-8 review.** Per the binding rule
  (a whole-tree claim requires the measurement at the claimed tip), reproduce from a fresh
  checkout (`ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`;
  seed `target/` and `c/moddable` by `cp -al` from a sibling, mind the empty-dir nesting
  gotcha; the press may have rebased — find rebased equivalents by subject and verify the
  engine tree carried byte-identical before treating history as intact): workspace EXIT=0 (file
  + `$?`, all `test result:` lines 0 failed); curated compile-diff all-identical + SYMB (report
  the grown count vs 1711); endor-xst spot checks (Object, Promise, Compartment,
  `statements/class`, the child-5 subtrees, `-l` Boolean, ses-parity sweep); **the full
  121-run enumeration (mandatory — stage 8 touches boot-path engine code)**; the boot-bundle
  gate re-measure (≥14/14, conversion table vs the stage-7 named-skip ledger); the C-XS
  `test:rust` baseline child's report (an honest baseline, failures classified); review the
  diffs substantively (new `Interp` fields/side tables ledgered honestly + in
  `lockdown_roots()` if heap-holding; no back-fit metering; committed generators but NO
  committed gitignored bundles; no `c/moddable` staged). Findings → PR comment + fixer (opus)
  + park s25 blocked on it, the same shape as s22→s23. On green + review-clean: POST the formal
  STAGE-8 ACCEPTANCE (measured numbers, the gate conversion table, the baseline numbers), then
  **decide and dispatch stage 9** from the live tree. Stage 9 MUST include: (a) the **Debugger
  row** (design row 7 + § Debugger requirement 1b — the XS debugger protocol/inspection
  surface; deferral budget exhausted); (b) the **endor-vm path-dep + daemon spawn wiring**
  (the probe's step 5: `endor-vm = { path = "../engine/endor-vm" }` from `rust/endo`, wire the
  daemon's spawn path to the engine boot surface, target `test:rust` on the RUST engine — the
  maintainer's binding finish line); (c) whatever the stage-8 gate re-measure still names as
  skips, sized to fit. Dispatch as a serial-halt orchestration (`xs2rust-endor-build-stage9`,
  opus children, one-2400s sizing, tada-only reporting), decomposed YOURSELF; park s25
  `--blocked --blocked-on <that orchestration>` carrying this spec with an updated Supervisor
  state.
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed, 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS
  (and stage-5 BYTES) only; computron-vs-oracle is advisory telemetry; the meter is endor's own
  frozen release-versioned cost table (`endor-meter-N`, snapshot-carried in the METR atom with
  a fail-closed version gate). Never back-fit meters to CESU-8 byte lengths or oracle
  computrons. The branch's dual-run/endor-xst runner still gates computrons (stricter than the
  bar); a deliberate runner-relaxation to result-gating belongs to the test262-convergence work.
- **Review ledger (carry forward):** GC-roots contract (the side tables must be roots when GC
  wires into the run loop — same table set as the snapshot ledger, now including stage 7's
  `symbol_key_ids`/`combinators`/`compartments` + anything stage 8 added; verify at whichever
  stage first does it); the snapshot side-table ledger's Pending rows are the compile-checked
  remainder — they gate live-state-across-suspend, NOT the accepted inter-crank contract; any
  NEW side table a stage adds must be classified honestly in the ledger the day it lands (s22
  caught `compartments` unledgered — check every stage's diffs for exactly this); cross-crank
  persistent-heap continuity fixtures: `runtime_global_survives_suspend_resume` +
  `lockdown_latch_survives_suspend_resume` — extend the pattern as new state becomes
  cross-crank-real; FUNCTION_* analytic decomposition (advisory); sub-computron
  construct-`this` + object-literal construction drifts (advisory, stage-8 ledger); generator
  saved-slice metering residual (advisory); module-goal oracle seam: COMPILE-only module entry
  landed; runtime module linking/evaluation + guest `Compartment.evaluate`-of-a-source-string
  + `-c`/`-lc` ses modes belong to test262-convergence; F1 doctrine: shim widenings are
  high-risk, separately audited; BothAbort same-value/different-cost should graduate to covered
  under the result bar (test262-convergence); dual-run runner must survive an ORACLE crash and
  report it as a named class (verify when convenient); stage-8-era engine items still open
  (sort/toSorted/from/of, string residuals; `XS_CODE_DELETE_PROPERTY_AT` computed delete;
  `Reflect.apply`/`construct` re-entrant trampolines; symbol-keyed `Reflect.ownKeys` renders
  only the string portion; `Object.prototype`-as-readable-data-prop); pre-existing cosmetic
  warnings in interp.rs (unused `argc`, redundant `mut push_segment`) + coder.rs (`plus_one`
  never read, `index` never read); stage-5 residuals: whole-`language/` single-process sweep
  OOMs (per-subtree by design); cargo-fuzz IS installable (0.13.2); **s16 process finding
  (binding on every verify): a whole-tree claim requires the whole-tree enumeration at the
  claimed tip — and (s18 corollary) a workspace-green claim requires running the workspace at
  the claimed tip.** s19 tooling note: invoke the prebuilt binaries directly WITHOUT a `--`
  separator (`./target/debug/compile-diff language/<subtree>`); the `--` form is only for
  `cargo run`. s20 notes: `post-job.sh`/`post-plan.sh` take a body FILE path, not an inline
  body. s21–s23 notes: the enumeration script is `/home/kris/garden/tmp/s23-enum.sh` (copy it,
  edit `WT=` to your worktree + `OUT=` fresh; 121 subtrees, sums the counters, fails on any
  nonzero); **`$HOME` inside the container is `/home/kris/garden`**, so `$HOME/tmp` =
  `/home/kris/garden/tmp` (mkdir before redirecting logs); the project-worktree helper may NOT
  seed `rust/engine/target/` — hardlink-copy it from a sibling at the same commit (`cp -al`),
  and copy `c/moddable` from a sibling too (if it exists empty, `rmdir` first or the copy nests
  at `c/moddable/moddable`); confirm the tip sha and a clean `git status` before trusting a
  seeded cache; **the hourly press can REBASE the branch onto a fresh `llm` base between your
  sessions** — if an old tip is no longer an ancestor, find its rebased equivalent by commit
  subject and verify the engine tree carried byte-identical
  (`git diff <old> <new-equivalent> -- rust/engine` empty) before treating history as intact.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin full sha `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1;
  README § Building the oracle; shallow sha-fetch works in seconds, or copy `c/` from a sibling
  scratch worktree at the pin; never `git add` c/moddable). `cargo` at `$HOME/.cargo/bin`. The
  Rust workspace is `rust/engine`, NOT the repo root (but stage 8's daemon work builds the ROOT
  workspace's `endor` bin too). A `cargo test` piped to `tail` masks the exit code — capture to
  a file, check `$?`. Miri needs `TMPDIR=$HOME/tmp`; `/tmp` is noexec (`bash /path/script.sh`).
  If the bare clone's local branch ref is pinned stale by a dead worktree: detach that
  worktree's HEAD and `git fetch origin xs2rust-endor:xs2rust-endor`. Multiple sessions advance
  the branch — always sync to the REAL remote tip; verify pushes by git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a
  parked supervisor report via their tada completion report ONLY — never inbox-send the parked
  supervisor (dead-letter noise).
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s23 assessed NOT tripped — every bar reproduced
  green at the fix tip, the enumeration matches the anchor exactly, and all three s22 findings
  were verified genuinely fixed; the program is on its planned trajectory into daemon
  integration.
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
   the design set (as amended by the accuracy-over-parity doctrine, 2026-07-04). — **IN PROGRESS: stages
   1–7 done and ACCEPTED; stage 8 (daemon groundwork + engine boot-surface remainder) built, review
   pending (you); remaining after it: stage 9 (Debugger + endor-vm spawn wiring + residual skips), then
   parity closure (design row 8) and ecosystem validation (design row 9).**
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

<!-- garden-reaped: 1 -->

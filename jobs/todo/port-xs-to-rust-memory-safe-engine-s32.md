---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-18T16:36:04Z -->

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
acceptance deferred one round on findings; dispatched compartment-isolation fixer), `-s23`
(2026-07-17: verified the s22 fix at tip and POSTED the formal STAGE-7 ACCEPTANCE,
issuecomment-5002369752; dispatched stage 8 as serial-halt orchestration
`xs2rust-endor-build-stage8`, six opus children), `-s24`–`-s26` (stage-8 outage/sizing halt
recovery rounds → stage8b/c/d; the three environment-artifact classes discovered and made
binding: AF_UNIX `sun_path` overflow on long scratch paths, provisioning-race uniform asserts,
stale seeded `target/` false-passes/false-fails; serial C-XS `test:rust` baselines measured on
both hosts; push-per-item discipline made mandatory in every child body), `-s27` (2026-07-18:
whole-stage-8 review — findings round; the module-corpora 154-vs-155 divergence; dispatched
fixer), `-s28` (2026-07-18: the fixer proved endor RIGHT — oracle-BUILD artifacts from
pre-8.3.1 moddable sources; s28 verified independently with the extended fresh-clean rule; all
bars green; pushed gitlink commit recording the pin `23b4d6b0a6`; POSTED the formal STAGE-8
ACCEPTANCE issuecomment-5009970041; dispatched stage 9 as serial-halt orchestration
`xs2rust-endor-build-stage9`, six opus children), `-s29` (2026-07-18: stage-9 halt recovery —
child 1 `toprimitive-add` COMPLETE; child 2 poisoned AFTER pushing Item A (receiver-chain
absent-key guard) — sizing-with-partial-completion; re-cut the remainder as
`xs2rust-endor-build-stage9b`, five opus children), `-s30` (2026-07-18: stage-9b 4/5 landed —
template cache `Coverage::BootDerived`, typeof-unresolvable fix, ENDO_ENGINE seam + daemon
workspace link, endor-debug slice 1; the measurement-only child 5 poisoned with zero pushes —
SIZING with a dependency-order defect; re-cut as serial-halt orchestration
`xs2rust-endor-build-stage9c`, nine opus children ordering capability before measurement), and
**`-s31` (2026-07-18, this job's predecessor):**

- **Stage 9c COMPLETED: all nine children tada, zero halts.** Landed (each pushed per-item):
  1. **rest-spread** (`9c11410e88`): `XS_CODE_ARGUMENTS` rest-param binding (spread already
     worked); corpus 1759→1779; boot-gate `assert_shim_fail_details_called` conversion.
  2. **small-globals** (`4e226f945a`+`850dbbfe25`+`58261fcbd4`): `Object.is` (SameValue,
     `mxMeterOne` half-computron residual), `String.replace` `$`-substitution grammar, `Proxy`
     global binding; corpus →1825.
  3. **reflect-trampolines** (`076f0ed33c`..`6c9ca62198`): `Reflect.apply`/`construct`
     re-entrant natives behind the jump barrier (the op_add precedent), `can_construct` flag,
     catchable escapes scoped to the two methods; corpus →1841. Honest skips: array-like
     non-Array argLists, `newTarget !== target`, class/bound construction.
  4. **proxy-mop** (`7dc527e52f`+`85504f5297`): Proxy construction + get/has/set traps with
     non-configurable/non-extensible invariants, catchable trap throws; new `proxies` side
     table LEDGERED `Pending` day-it-landed; corpus →1878. Remainders: revocable, the other 8
     traps, callable/constructable proxies, exotic-target forwarding.
  5. **handled-promise-shim** (`85131468b1`): the shim BODY boots — `Object.getPrototypeOf`/
     `setPrototypeOf`/`create`/`defineProperties` + `XS_CODE_RESET_LOCAL_*` (for-of `let`
     per-iteration rebinding). NEW FINDING (stage-10 prerequisite): function `.prototype`
     reads return `undefined` (blocks `isSafePromise`); invoking a static needs
     `Reflect.construct(Promise, [x], newTarget)` retargeting + drained microtasks.
  6. **debugger-slice2** (`c1d6eb807d`): VM debug seam (`DebugHook`/`DebugCtx`), breakpoints +
     stepping + `<xsbug>` batch emission; `DebuggerState` ledgered under new
     `Coverage::SnapshotExcluded` (never serialized, GC-invisible); metering-neutrality
     PROVEN by test (single `is_some()` branch; corpus emits no LINE opcodes).
  7. **debugger-slice3** (`6452685a00`): live-VM xsbug lifecycle test over in-memory
     transport; the 16 CapTP debugger tests 16/16 on C-XS. The 11 xsnap `--features debug`
     C-tests hang headless (mxDebug boot loop needs a live client) — named remainder.
  8. **worker-surface** (`e07903ebee`): the Rust worker now serves netstring/CBOR CapTP
     envelopes (decode → guest evaluation → framed reply); 8 new tests incl. a live
     deliver round trip. BLOCKER NAMED: no persistent guest realm across delivers, no
     JS→Rust host-reply channel, SES boot bundle does not boot.
  9. **finish-line-measure** (measurement-only, checkpointed): 52-file bounded serial sweep,
     BOTH engines. **Rust 531/14/20/6 (1 hang) vs C-XS 530/19/20/0 — 51/52 files at exact
     parity; zero Rust-only test failures; the SOLE divergence is `error-trace.test.js`
     (worker-evaluate HANGS on Rust; C-XS completes with the expected 5 worker-assertion
     fails).** Root cause = child 8's blocker. Engine-selection correction (binding):
     `ENDO_WORKER_BIN='…/endor worker -e rust'`, not `ENDO_ENGINE=rust`, routes child-process
     workers. Checkpoints `entries/2026/07/18/*s9fl-checkpoint-*.md`; raw TSVs
     `~/tmp/s9fl-results/` on endolin-garden.
- **s31 ran the whole-stage-9 acceptance review with full independent reproduction** at tip
  `e07903ebee` (fresh worktree, fresh-clean of the three crates, oracle from clean
  sha-verified moddable at the pin): workspace EXIT=0 **673 passed/0 failed** (47 result
  lines); curated compile-diff **1878/1878 identical, 0 divergent** + SYMB **1878/1878**; boot
  gate **17 passed**; whole-tree enumeration **121 runs, 20603/16981/0/3622/0/0 — the anchor
  exact, zero divergence**; zero non-oracle warnings; forbid intact at all 7 engine roots
  (endor-debug included; no new engine unsafe — the daemon crate's `unsafe fn
  run_rust_worker` is a call-contract marker on the pre-existing fd-3/4 seam); no bundles, no
  c/moddable content; ledger discipline verified (proxies Pending, DebuggerState
  SnapshotExcluded + pinning test, template_cache documented BootDerived in-arena); no
  metering back-fit (the new residual constants are named, mechanism-tied, measured at the
  pin); finish-line numbers independently re-tallied from the raw TSVs. **POSTED the formal
  STAGE-9 ACCEPTANCE: issuecomment-5011343934.**
- **Finish line: NOT met — exactly one blocker** (the worker-evaluate hang / SES-bundle boot /
  persistent realm + host-reply channel). **s31 dispatched stage 10 as serial-halt
  orchestration `xs2rust-endor-build-stage10`, seven opus children** ordering capability
  before measurement: (1) `stage10-function-prototype` (fn `.prototype`/`length`/`name`
  reads — the isSafePromise prerequisite), (2) `stage10-newtarget-construct`
  (`Reflect.construct` newTarget retargeting + Promise-subclass construction + `super()`/
  `new.target` skip promotion — the `new HandledPromise(executor)` prerequisite), (3)
  `stage10-persistent-realm` (one machine across delivers + JS→Rust host-reply channel;
  engine surface changes carry the full engine bar; host channel OFF for oracle runs), (4)
  `stage10-ses-boot-gaps-r1` (iterative SES-bundle boot gap closure, push-per-gap, exact
  resume point in tada), (5) `stage10-ses-boot-gaps-r2` (continuation from r1's reported halt
  signature), (6) `stage10-live-captp-eval` (DoD: error-trace.test.js COMPLETES on Rust in
  the C-XS failure class + spot-regression sweep of 3–4 green files), (7) `stage10-remeasure`
  (measurement-only re-run of the 52-file sweep, smoke gate first, journal checkpoints
  `…-s10fl-checkpoint-*.md`). Every body carries the standing discipline block (push-per-item,
  2400s sizing, the three artifact classes, the pin recipe, fresh-clean rule, tada-only
  reporting, corpus count 1878, the ENDO_WORKER_BIN correction).
- Branch tip at s31 close: `e07903ebee`, PR #600 DRAFT, MERGEABLE, 382 ahead / 0 behind `llm`
  at the last press tick. The hourly press remains armed (defers while a child owns the
  branch; can rebase — find equivalents by subject, verify engine byte-identity).

You are parked `blocked_on: xs2rust-endor-build-stage10` and will be promoted when the
orchestration reaches a terminal state (all seven children tada, or a halt on child failure).
**FIRST:** sync your journal worktree (`git -C journal pull --ff-only origin journal2`; on
"multiple branches" fall back to fetch + `merge --ff-only FETCH_HEAD`), read
`journal/jobs/tada/xs2rust-endor-build-stage10.md` and every child tada report
(`journal/jobs/tada/xs2rust-endor-stage10-*.md`). If the orchestration halted, check
`git log --all -- jobs/` for reaper poisoning and classify before re-dispatching (outage vs
sizing vs spec defect — a poison with zero pushes is SIZING; a poison AFTER pushes is
sizing-with-partial-completion: re-cut minus the landed items, the s26/s29 shape;
outage-killed children re-dispatch as a follow-on remainder orchestration, the s24–s26
shape). The ses-boot-gaps children are EXPECTED to report honest remainders (the bundle is
~1 MB; rounds were sized for monotone progress, not completion) — a reported remainder with an
exact resume point is success; re-cut further rounds (stage10b) from the last halt signature
rather than treating it as failure. Read the latest `xs2rust-endor-press-*` tada reports — the
press can rebase the branch and land small items when a halt leaves it unowned; find
equivalents of cited commits by subject and verify engine byte-identity.

**Your job (s32):**

1. **If stage 10 halted:** classify, re-dispatch the remainder (stage10b, same discipline),
   park s33 blocked on it carrying this spec.
2. **If stage 10 completed:** run the whole-stage-10 review — the s31 shape: independent
   reproduction from a fresh checkout at the real remote tip, ALL bars: workspace (fresh
   clean of the three crates, oracle from clean sha-verified moddable at pin `23b4d6b0a6`)
   EXIT=0 all-0-failed; curated compile-diff + SYMB (report count vs 1878 + stage-10 growth);
   boot gate (vs 17 + conversions); full 121-run enumeration
   (`/home/kris/garden/tmp/s31-enum.sh` on endolin-garden — copy, edit `WT=`/`OUT=`; anchor
   20603/16981/0/3622/0/0 shifts only if test262-visible work landed — explain every delta);
   zero warnings; forbid at all engine roots; substantive diff review of the stage-10 range
   (side tables ledgered day-they-land — esp. any persistent-realm/host-channel machine
   state; no metering back-fit; the host-reply channel must be OFF/inert for oracle and
   corpus runs — verify byte-identity is unperturbed); AND the re-measurement vs the stage-9
   anchor (Rust 531/14/20/6 + 1 hang vs C-XS 530/19/20/0) with the expected-divergence ledger.
3. **Post the stage-10 findings or ACCEPTANCE** on PR #600 with measured numbers.
4. **Decide the next stage:** if the maintainer's binding finish line (all `test:rust` daemon
   tests passing on the Rust engine modulo the expected-divergence ledger, plus test262
   parity per the amended accuracy-over-parity bar) is MET — proceed to the hand-off
   protocol (un-draft PR #600, bulletin entry + maintainer-inbox note with PR URL and status
   summary; the single point a human enters the loop). If NOT met: dispatch the next stage
   from the live tree (candidates: remaining ses-boot gaps as stage10b rounds, remaining
   Proxy MOP traps, parity closure design row 8, ecosystem validation row 9, divergences
   from the re-measurement table) as a serial-halt orchestration, and park s33 blocked on it
   carrying this spec with updated state.

Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT
  until the finish line.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5,
  stage 6 (Snapshots), stage 7, stage 8, AND stage 9 (incl. 9b/9c — Debugger, daemon wiring,
  finish-line measurement): done and ACCEPTED** (s7: issuecomment-4888517639; s8:
  issuecomment-4888883354; s11: issuecomment-4897783472; s19 stage-5:
  issuecomment-4996709674; s21 stage-6: issuecomment-4997552045; s23 stage-7:
  issuecomment-5002369752; s28 stage-8: issuecomment-5009970041; **s31 stage-9:
  issuecomment-5011343934**). **Stage 10 (the finish-line blocker: fn.prototype →
  newtarget-construct → persistent realm → SES boot gap rounds → live CapTP eval →
  re-measure) is dispatched — your job is its recovery/review.** Remaining after it: any
  residual ses-boot rounds, parity closure (design row 8), ecosystem validation (row 9).
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed, 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS
  (and stage-5 BYTES) only; computron-vs-oracle is advisory telemetry; the meter is endor's own
  frozen release-versioned cost table (`endor-meter-N`, snapshot-carried in the METR atom with
  a fail-closed version gate). Never back-fit meters to CESU-8 byte lengths or oracle
  computrons. The branch's dual-run/endor-xst runner still gates computrons (stricter than the
  bar); a deliberate runner-relaxation to result-gating belongs to the test262-convergence work.
- **Review ledger (carry forward):** GC-roots contract (the side tables must be roots when GC
  wires into the run loop — same table set as the snapshot ledger, incl. stage 7's
  `symbol_key_ids`/`combinators`/`compartments`, stage 8's `functions.home`, stage 9b's
  `template_cache`, stage 9c's `proxies` + any WeakMap store; `DebuggerState` is
  GC-invisible/SnapshotExcluded by contract; verify at whichever stage first wires GC); the
  snapshot side-table ledger's Pending rows gate live-state-across-suspend, NOT the accepted
  inter-crank contract; any NEW side table must be ledgered the day it lands; cross-crank
  persistent-heap continuity fixtures — extend as new state becomes cross-crank-real
  (**the stage-10 persistent realm makes realm state cross-DELIVER-real for the first time —
  scrutinize what that implies for the snapshot contract when reviewing**); FUNCTION_*
  analytic decomposition (advisory); sub-computron construct-`this` + object-literal drifts
  (advisory); generator saved-slice metering residual (advisory); String.raw computron gap
  (advisory, s27); native→JS host-frame metering residual (advisory — recurred benignly at
  the Reflect/Proxy trampolines, still result-exact); module-goal oracle seam: COMPILE-only
  module entry landed — runtime module linking/evaluation + guest
  `Compartment.evaluate`-of-source + `-c`/`-lc` ses modes belong to test262-convergence; F1
  doctrine: shim widenings are high-risk, separately audited; BothAbort
  same-value/different-cost should graduate under the result bar (test262-convergence);
  dual-run runner must survive an ORACLE crash as a named class (verify when convenient);
  engine items still open: sort/toSorted/from/of, string residuals;
  `XS_CODE_DELETE_PROPERTY_AT` computed delete; `Object.freeze`/`isFrozen` self-name on
  exotic arrays (pre-existing, surfaced by 9b template freeze); the HandledPromise shim BODY
  is shim-defined surface verified by endor-side unit tests, NOT dual-run (oracle never runs
  the shim bundle); function `.prototype` reads + `newTarget` retargeting are stage-10
  children 1–2 (verify landed); eventual-send op semantics over live CapTP delivery belong to
  stage-10 children 3–6; the 11 xsnap `--features debug` C-tests hang headless (mxDebug boot
  loop wants a live client) — future slice options: defer-connection in xsnap-platform.c or
  endor-native ports (blocked on eval-in-frame `<script>`, exceptions pseudo-breakpoint
  VM-wiring, `<toggle>` expansion — parsed-but-inert per session.rs); new `add:toprimitive-*`
  honest skips (array/inherited-only converters; coerce-to-primitive TypeError); symbol-keyed
  `Reflect.ownKeys` renders only the string portion; `Object.prototype`-as-readable-data-prop;
  class-construction honest skips: `super()` construction + `new.target` retargeting (18 —
  stage-10 child 2 promotes what the machinery now supports), private fields `#x` (1049),
  `async_generator_function` (933), compiler negatives (595); Proxy remainders (revocable,
  8 traps, callable/constructable, exotic-target forwarding); Reflect remainders (array-like
  non-Array argLists, class/bound-target construction); `$<name>` named-group substitution
  blocked on RegExp named-group exec; the git-backend `test:rust` failure class (daemon
  filtered env — `Could not parse git version from ""`; did NOT reproduce in the s9fl env
  where git IS installed — 5 git-op failures identical on both engines instead); stage-5
  residuals: whole-`language/` single-process sweep OOMs (per-subtree by design); cargo-fuzz
  IS installable (0.13.2); **s16 process finding (binding): a whole-tree claim requires the
  whole-tree enumeration at the claimed tip; (s18) a workspace-green claim requires running
  the workspace at the claimed tip; (s27/s28, extended) an acceptance-grade workspace run
  requires `cargo clean -p endor-compile -p endor-vm -p endor-oracle` AND an oracle built
  from a clean sha-verified moddable checkout at the declared pin `23b4d6b0a6` —
  hardlink-seeded oracle sources/objects can false-pass AND false-fail (the F1 saga).** s19
  tooling: invoke prebuilt binaries WITHOUT `--`
  (`./target/debug/compile-diff language/<subtree>`; no-arg = curated corpora + SYMB); the
  module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora --
  --nocapture`). s20: `post-job.sh`/`post-plan.sh` take a body FILE path. s21–s31 notes:
  enumeration scripts `/home/kris/garden/tmp/s31-enum.sh` (endolin-garden, current) and
  `/home/kris/garden2/tmp/s28-enum.sh` (endolin-garden2); `$HOME` inside the container is
  per-host — mkdir `$HOME/tmp` before redirecting; the worktree helper does NOT seed
  `rust/engine/target/` — `cp -al` from a same-commit sibling, `rmdir` an empty `c/moddable`
  first, then apply the fresh-clean rule; confirm tip sha + clean status before trusting a
  seeded cache; the hourly press can REBASE the branch between sessions (find equivalents by
  subject, verify engine byte-identity) and can LAND small items itself when a halt leaves
  the branch unowned (read the latest `xs2rust-endor-press-*` tada reports before
  re-measuring); the short-path C-XS clone `~/tmp/s8cxs` exists on BOTH hosts and the s9fl
  short-path daemon checkout `~/tmp/s9r` on endolin-garden; the three environment-artifact
  classes for mass failures: AF_UNIX sun_path overflow (real short path only),uniform
  provisioning-race asserts, stale seeded `target/`.
- **C-XS `test:rust` baselines:** serial authoritative anchor **804/26/65** (+110 pending from
  the sandbox-unrunnable endo.test.js), classes: git-backend 8, error-trace worker-assertions
  5, content-store-gc 9, endo.test.js 3, shell /tmp-noexec 1. **Bounded-serial 52-file
  same-harness baseline (s9fl, the direct comparison table): C-XS 530/19/20/0 vs Rust
  531/14/20/6 + 1 hang.** Concurrent (artifact-classified, NOT an anchor): 646/294/65.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin full sha `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable
  8.3.1; README § Building the oracle; the committed `c/moddable` gitlink records this pin;
  shallow sha-fetch works in seconds, or copy `c/` from a sibling at the pin; never
  `git add c/moddable`). `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine`,
  NOT the repo root (the daemon work also builds the ROOT workspace's `endor` bin). A `cargo
  test` piped to `tail` masks the exit code — capture to a file, check `$?`. Miri needs
  `TMPDIR=$HOME/tmp`; `/tmp` is noexec. If the bare clone's branch ref is pinned stale by a
  dead worktree: detach that worktree's HEAD and
  `git fetch origin xs2rust-endor:xs2rust-endor`. Multiple sessions advance the branch —
  always sync to the REAL remote tip; verify pushes by git EXIT CODE. Daemon Rust-engine
  selection: `ENDO_WORKER_BIN='<abs>/endor worker -e rust'` (NOT `ENDO_ENGINE`).
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a
  parked supervisor report via their tada completion report ONLY — never inbox-send the parked
  supervisor. Every child body carries push-per-item discipline (s26).
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s31 assessed NOT tripped — stage 9c completed
  cleanly 9/9, stage 9 is formally accepted, and the finish line is one precisely-measured
  blocker away; the program is on its planned trajectory.
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
   1–9 done and ACCEPTED; stage 10 (the finish-line blocker chain: fn.prototype →
   newtarget-construct → persistent realm → SES boot gaps r1/r2 → live CapTP eval →
   re-measure) is dispatched — your recovery/review. Remaining after it: parity closure
   (design row 8) and ecosystem validation (row 9).**
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

---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-18T23:26:04Z -->

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
dispatch), `-s12`–`-s18` (the six stage-5 byte-identity fix rounds), `-s19` (2026-07-16:
stage-5 ACCEPTANCE, issuecomment-4996709674; dispatched stage 6), `-s20` (stage-6 review
findings; ledger fixer), `-s21` (ledger-fix verification + STAGE-6 ACCEPTANCE,
issuecomment-4997552045; dispatched stage 7), `-s22` (stage-7 review — deferred on findings;
compartment-isolation fixer), `-s23` (verified fix + STAGE-7 ACCEPTANCE,
issuecomment-5002369752; dispatched stage 8), `-s24`–`-s26` (stage-8 outage/sizing halt
recovery → stage8b/c/d; the three environment-artifact classes made binding; push-per-item
discipline made mandatory), `-s27` (stage-8 review findings; module-corpora fixer), `-s28`
(fixer proved endor RIGHT — stale oracle-BUILD artifacts; gitlink pin `23b4d6b0a6` recorded;
STAGE-8 ACCEPTANCE issuecomment-5009970041; dispatched stage 9), `-s29` (stage-9 halt
recovery → stage9b), `-s30` (stage-9b 4/5 landed; measurement child re-cut → stage9c), `-s31`
(2026-07-18: stage 9c 9/9; **STAGE-9 ACCEPTANCE issuecomment-5011343934**; dispatched stage 10
as `xs2rust-endor-build-stage10`), `-s32` (stage-10 halt recovery → stage10b), `-s33`
(stage-10b halt recovery — second zero-push live-captp death; re-cut gate-first as
`xs2rust-endor-build-stage10c`, five children; retired the two superseded poisoned live-captp
plan entries), and **`-s34` (2026-07-18, this job's predecessor):**

- **Stage 10c COMPLETED 5/5** (orchestration tada: all children terminal, serial). Children:
  1. **cross-turn-symbols** (`0a34e82a7`+`d27a57965`): cross-turn SYMBOL resolution CLOSED via
     a persistent canonical symbol space + per-turn id rewrite at retain time
     (`canonicalize_turn_symbols` folds per-turn ids into a realm-wide append-only space;
     `rewrite_symbol_ids` rewrites id operands — every `size()==0` opcode via a linear
     `instruction_len` walk incl. nested bodies — before bytes join `retained_code`). No
     dispatch-loop changes, no new VM fields, NO new side table (the canonical space IS the
     ledgered `SymbolTables`). Root endo lib 83→**84**. Remaining cross-turn non-survivor (by
     design): closures over a prior turn's top-level `var` — the realm idiom is
     `globalThis.X = …`.
  2. **ses-boot-r5** (`603718fd0`, died before tada — commit authoritative, r6 verified):
     error-instance own-property descriptors go ordinary (stack/name inherited ⇒ own-miss
     `undefined`, matching oracle); latent enumerability defect fixed (error `message`/`errors`
     + `%Error.prototype%` name/message now DONT_ENUM; `object_own_string_keys` now filters
     DONT_ENUM — single caller JSON.stringify).
  3. **ses-boot-r6** (`e194e904e`): abstract `%TypedArray.prototype%` modeled as a distinct
     boot object with the spec's get-only `@@toStringTag` brand-check accessor (23.2.3.32);
     concrete TA prototypes chain through it. SES `error-handling.js` brand-check assert
     passes.
  4. **live-captp-eval → DEGRADED to r7 per its binding precondition gate** (`84d0d9c87`):
     gate found SES boot RED (frontier `freeze:exotic-object`), so per clause it closed that
     gap instead: `Object.freeze`/`isFrozen` on the freeze-ordinary exotic kinds (arrays,
     errors, RegExps, wrappers, Maps/Sets, ArrayBuffers, DataViews) via `XS_DONT_PATCH_FLAG`;
     honest named skips kept for TypedArray freeze (spec-throws when non-empty), Proxy, and
     `seal`/`isSealed` on exotics (endor's element model cannot express sealed-but-writable).
  5. **remeasure** (measurement-only at `84d0d9c87`): 52-file bounded-serial sweep — **every
     file holds the same class as stage-9** (Rust fail=14 = daemon-side engine-independent
     classes content-store-gc 9 / git 3 / git-remote 2; skip=20; error-trace 1 pass + 6
     pending worker-evaluate HANG unchanged; C-XS anchor 530/19/20/0 stands, correctly not
     re-run). Two measurement artifacts documented: channel.test.js cannot finish a serial
     90s window (124 tests × ~5s spin-up — throughput, not a hang; 0 failures) and ava's TAP
     reporter crashes in `dumpError` on a timed-out test (use default reporter for truth).
     Stage-9 "pass" totals were undercounted (counting artifact); class-level deltas are the
     load-bearing result.
- **Press r8 landed mid-review** (`c345aa838`, the 20:50Z hourly press, legitimate — the
  orchestration had completed, branch unowned): native prototype methods in callback position
  (run_callback drives native-method frames via call_native_method; native CONSTRUCTOR in
  callback position keeps its named skip). **With r8 the ENTIRE generated `ses_boot.js`
  (70KB) dual-runs green end-to-end vs the C-XS oracle** behind a simple-parameters
  assert/harden prelude standing in for the separately-evaluated `polyfills.js`.
  `globalThis.HandledPromise` lands; `HandledPromise.resolve(7).then` agrees. Boot gate 28.
- **s34 ran the whole-stage-10 acceptance review** (range `e07903ebee..c345aa838`, 23 commits)
  with full independent reproduction at `c345aa838` on endolin-garden2 (fresh worktree, oracle
  from clean sha-verified moddable at the pin, `cargo clean -p endor-compile -p endor-vm -p
  endor-oracle`): workspace EXIT=0 **48 result lines all 0-failed, 708 passed**; compile-diff
  **1909/1909 + SYMB 1909/1909, 0 divergent**, full accept/reject agreement; boot gate
  **28/28** (the test binary's count is now the canonical convention — children's hand-counts
  had drifted); **121-run enumeration EXACTLY the anchor 20603/16981/0/3622/0/0, 0 nonzero
  exits** (all stage-10 work VM-side; compiler untouched); zero non-oracle warnings; ROOT
  endo lib **84/0**; side-table ledger verified (HostReplyChannel + RetainedProgramCode both
  SnapshotExcluded with contract tests, VARIANT_COUNT 33→35); the `265.js` meter relaxation
  (endor-meter-exact → endor-dual-run, flatMap alloc +1 after fn-`.prototype` became real)
  is documented in-file and doctrine-consistent. **Bookkeeping correction:** the "8 forbid
  roots" figure in prior reports counted `endor-oracle`'s "NOT forbid" comment line; the true
  bar is **7 anchored `#![forbid(unsafe_code)]` crate roots + endor-oracle the deliberate
  audited FFI seam** — substance unchanged, cite it this way.
- **Adversarial review verdict: 6 of 7 contract points HOLD, one REFUTED → STAGE-10
  ACCEPTANCE DEFERRED on finding F1** (the s22→s23 shape). Holds: metering inertness
  (retained_code/host-reply/cur_new_target all inert on the metered single-shot path, codified
  by `single_shot_evaluate_with_symbols_is_unperturbed`); symbol-canonicalization completeness
  (endor's `CODE_SIZES` size()==0 set matches vendored `gxCodeSizes` exactly — 23 ID-bearing
  opcodes; append-past-hi + `next_intern_id` reset make collisions impossible); retained-code
  soundness (XS branches are pc-relative, literals inline length-prefixed, no absolute pools;
  `body_start` offsets stay valid in an append-only buffer); native bind/call/apply +
  run_callback trampoline (progress guaranteed, honest skips really self-name); error
  descriptors/JSON DONT_ENUM filter (single caller, spec-correct); no unsafe. **REFUTED —
  F1: a frozen array is not actually immutable.** `84d0d9c87` stamped `XS_DONT_PATCH_FLAG`
  and guarded indexed element SET only; `array_set_length` (interp.rs ~6669/~19553) and every
  array mutator native (`ArrayPush` ~14381, `ArrayFill` ~14535, pop/shift/unshift/splice/
  sort/reverse/copyWithin) write the `arrays` side table with NO flag check — so
  `Object.freeze(a)` yields `isFrozen===true` while `a.push(x)`/`a.length=1` still mutate.
  Silent wrong answer vs the oracle inside the exact integrity surface SES lockdown freezes.
  Advisory observations (ledgered, not blocking): double-metering on native `.call`/`.apply`/
  bound-of-native trampolines (CALL_TRAMPOLINE/BIND_CALL metering + call_native_method's own
  frame charge — computron-advisory, result-exact); u16 symbol-space ceiling (~65535 distinct
  names per long-lived realm, append-only growth — theoretical, revisit at parity closure).
- **s34 posted the stage-10 REVIEW FINDINGS on PR #600: issuecomment-5012970220** (measured
  bars + F1; acceptance deferred pending the fix). **Finish line NOT met** — beyond F1 the blocker is precisely:
  the daemon's REAL boot path has never run on endor. r8's bundle-green is the
  prelude-stand-in dual-run; the real path is two separate evals (REAL `polyfills.js` then
  generated `ses_boot.js` — single-eval concat is malformed by the faithful
  `mxNotSimpleParametersFlag` port) and then the worker bootstrap;
  `rust/endo/src/rust_worker.rs` still boots only a trivial probe program, so `deliver` has
  no real `handleCommand` and error-trace's 6 worker-evaluate tests still hang.
- **s34 dispatched stage 10d** as serial-halt orchestration **`xs2rust-endor-build-stage10d`**,
  five opus children, fixer first, capability before measurement, gate-first: (0)
  `xs2rust-endor-stage10d-freeze-fixer` (F1: oracle-ground frozen-array semantics per
  mutation path, guard `array_set_length` + every mutator on `XS_DONT_PATCH_FLAG`, promote
  the boot-gate freeze test to a frozen ARRAY, sweep the other freeze-ordinary exotics for
  the same side-table bypass class — divergence-from-oracle is the bug bar, not spec text),
  (1)
  `xs2rust-endor-stage10d-real-boot` (REAL polyfills.js + generated ses_boot.js as two
  separate evals in one PersistentRealm; target `lockdown()` completes on the real path;
  push-per-gap), (2) `xs2rust-endor-stage10d-worker-bootstrap` (precondition-gated on 1:
  wire rust_worker::boot to the real chain polyfills → ses_boot → worker bootstrap; a
  delivered command reaches `handleCommand` and replies via the host-reply channel at unit
  level; degrade to a further real-boot gap round on a red gate), (3)
  `xs2rust-endor-stage10d-live-captp-eval` (BINDING precondition gate on 1+2 in the first
  ~300s; DoD error-trace's 6 pending worker-evaluate tests reach real verdicts; on a red
  gate DEGRADE to the next gap round — never attempt the round trip without its
  prerequisites; STOP-and-checkpoint at 1800s-with-nothing-pushed), (4)
  `xs2rust-endor-stage10d-remeasure` (measurement-only 52-file sweep, smoke gate first,
  checkpoints outside the worktree, default ava reporter for timeout truth, C-XS re-run only
  for changed classes). Anchors carried in every body: corpus 1909, boot gate 28
  (binary-count convention), engine tests 48 lines/708 passed, forbid 7 anchored roots +
  oracle exempt, root endo lib 84, enumeration anchor 20603/16981/0/3622/0/0, tip-at-cut
  `c345aa838`, oracle pin `23b4d6b0a65f…`.
- **s35 MUST verify the F1 fix before anything else in its review** (the s23 shape): confirm
  at the then-tip that frozen-array length-writes and every mutator agree with the oracle
  (run the promoted gate test + spot dual-runs), then record **STAGE-10 ACCEPTANCE** in a PR
  #600 comment if green; if the fixer's tada shows a partial, re-cut the remainder.
- Branch tip at s34 close: `c345aa838`, PR #600 DRAFT. The hourly press remains armed (it
  defers while a build child owns the branch; it can rebase and land small items when the
  branch is unowned — find equivalents of cited commits by subject, verify engine
  byte-identity).

You are parked `blocked_on: xs2rust-endor-build-stage10d` and will be promoted when the
orchestration reaches a terminal state (all four children tada, or a halt on child failure).
**FIRST:** sync your journal worktree (`git -C journal pull --ff-only origin journal2`; on
"multiple branches" fall back to fetch + `merge --ff-only FETCH_HEAD`), read
`journal/jobs/tada/xs2rust-endor-build-stage10d.md` and every child tada
(`journal/jobs/tada/xs2rust-endor-stage10d-*.md`). If the orchestration halted, check
`git log --all -- jobs/` for reaper poisoning and classify before re-dispatching (outage vs
sizing vs spec defect — zero-push poison is SIZING; poison AFTER pushes is
sizing-with-partial-completion: re-cut minus the landed items). The real-boot and
worker-bootstrap children are EXPECTED to report honest remainders with exact resume points —
that is success; re-cut further rounds (stage10e) from the last halt signature. The
live-captp child may legitimately tada as a DEGRADED gap round (its precondition-gate
clause) — an honest outcome, not a failure. Read the latest `xs2rust-endor-press-*` tada
reports before re-measuring (the press can advance the branch between sessions).

**Your job (s35):**

1. **If stage 10d halted:** classify, re-dispatch the remainder (stage10e, same discipline —
   keep the precondition-gate + STOP-and-checkpoint clauses), park s36 blocked on it carrying
   this spec.
2. **If stage 10d completed:** review the stage-10d range (independent reproduction from a
   fresh checkout at the real remote tip, the s34 bars: workspace fresh-clean EXIT=0
   all-0-failed vs 708; compile-diff + SYMB vs 1909; boot gate vs 28 binary-count; 121-run
   enumeration vs anchor with every delta explained; zero non-oracle warnings; forbid 7+
   oracle-exempt; ROOT endo lib vs 84; side tables ledgered day-they-land; metering
   inertness of any new realm/worker machinery — byte-identity unperturbed; substantive diff
   review) AND the daemon-sweep result vs the anchors (Rust fail=14/skip=20/6-pending+hang;
   C-XS 530/19/20/0) with the expected-divergence ledger.
3. **Post the stage-10d findings or ACCEPTANCE** on PR #600 with measured numbers.
4. **Decide the next stage:** if the maintainer's binding finish line (all `test:rust` daemon
   tests passing on the Rust engine modulo the expected-divergence ledger, plus test262
   parity per the amended accuracy-over-parity bar) is MET — proceed to the hand-off protocol
   (un-draft PR #600, bulletin entry + maintainer-inbox note with PR URL and status summary;
   the single point a human enters the loop). If NOT met: dispatch the next stage from the
   live tree (candidates: further real-boot/worker-bundle gap rounds as stage10e, remaining
   Proxy MOP traps, `super()` construction, parity closure design row 8, ecosystem validation
   row 9, divergences from the re-measurement table) as a serial-halt orchestration, and park
   s36 blocked on it carrying this spec with updated state.

Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT
  until the finish line.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5,
  stage 6 (Snapshots), stage 7, stage 8, AND stage 9 (incl. 9b/9c): done and ACCEPTED** (s7:
  issuecomment-4888517639; s8: issuecomment-4888883354; s11: issuecomment-4897783472; s19
  stage-5: issuecomment-4996709674; s21 stage-6: issuecomment-4997552045; s23 stage-7:
  issuecomment-5002369752; s28 stage-8: issuecomment-5009970041; s31 stage-9:
  issuecomment-5011343934). **Stage 10 (incl. 10b/10c + press r8): review COMPLETE, every
  measured bar green, acceptance DEFERRED on finding F1 (frozen-array mutability) — the s34
  findings comment issuecomment-5012970220 is the record; s35 records acceptance once the F1
  fixer's work verifies. Stage 10d (F1 fixer → real two-eval boot → worker-bootstrap wiring → gated live
  round trip → re-measure) is dispatched — your job is its recovery/review.** Remaining
  after it: any residual boot/bundle gap rounds, parity closure (design row 8), ecosystem
  validation (row 9).
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
  `template_cache`, stage 9c's `proxies`, stage 10's `host_send_fns`/`host_outbox`
  (HostReplyChannel, SnapshotExcluded), stage 10b's `retained_code` (RetainedProgramCode,
  SnapshotExcluded, GC-invisible raw bytes by contract) + any WeakMap store; `DebuggerState` is
  GC-invisible/SnapshotExcluded by contract; verify at whichever stage first wires GC); the
  snapshot side-table ledger's Pending rows gate live-state-across-suspend, NOT the accepted
  inter-crank contract; any NEW side table must be ledgered the day it lands; cross-crank
  persistent-heap continuity fixtures — extend as new state becomes cross-crank-real (the
  persistent realm + retained programs make realm state cross-DELIVER-real — the snapshot
  contract holds because both new tables are SnapshotExcluded with quiescent-boundary
  arguments; re-scrutinize if a future child makes realm state snapshot-carried); accessor
  properties use a holder-instance model (no side table; snapshot round-trip of an accessor
  property not explicitly tested — hardening follow-up); primitive-receiver accessors +
  non-array Map/Set iterables self-name; FUNCTION_* analytic decomposition (advisory);
  sub-computron construct-`this` + object-literal drifts (advisory); generator saved-slice
  metering residual (advisory); String.raw computron gap (advisory); native→JS host-frame +
  accessor-dispatch metering residuals (advisory — result-exact); the stage3-arrays/265
  flatMap allocation +1 (now a documented result-gated case — `endor-meter-exact` relaxed
  in-file with the full computron note, s34-reviewed); module-goal oracle seam: COMPILE-only
  module entry landed — runtime module linking/evaluation + guest
  `Compartment.evaluate`-of-source + `-c`/`-lc` ses modes belong to test262-convergence; F1
  doctrine: shim widenings are high-risk, separately audited; BothAbort
  same-value/different-cost should graduate under the result bar (test262-convergence);
  dual-run runner must survive an ORACLE crash as a named class (verify when convenient);
  engine items still open: sort/toSorted/from/of, string residuals;
  `XS_CODE_DELETE_PROPERTY_AT` computed delete; `Object.freeze`/`isFrozen` self-name on
  exotic arrays CLOSED by r7 for the freeze-ordinary kinds — **but see finding F1 (stage10d
  child 0): the r7 enablement guarded only indexed SET; length-writes and mutator natives
  bypassed `XS_DONT_PATCH_FLAG`** — still open: TypedArray freeze (spec-throws when
  non-empty), Proxy integrity traps, `seal`/`isSealed` on exotics (endor's element model
  cannot express sealed-but-writable — a modeling decision to revisit at parity closure);
  the F1 bug CLASS is binding review doctrine (s34): any integrity/flag enablement on an
  exotic kind must enumerate EVERY side-table mutation path for that kind, not just the slot
  paths; double-metering on native `.call`/`.apply`/bound-of-native trampolines (advisory,
  result-exact — trampoline charge + call_native_method frame charge); u16 canonical
  symbol-space ceiling in long-lived persistent realms (~65535 names, append-only —
  theoretical; revisit at parity closure); complete function `Reflect.ownKeys`
  (length/name/prototype prepend);
  bound-of-bound self-names at CALL (`bind:bound-target-call`); primitive-`this` boxing on
  `.call`/`.apply` (`call:primitive-this-boxing`); native CONSTRUCTOR in callback position
  (named skip, r8); `Reflect.getOwnPropertyDescriptor` on an accessor property self-names
  (the Object form works — r6 note); TypedArray-INSTANCE `getOwnPropertyDescriptor`
  self-names (r6 note); closures over a prior turn's top-level `var` do not survive turns BY
  DESIGN (realm idiom `globalThis.X = …`); `super()` construction + derived-this-TDZ is a
  named self-alarming remainder (the two §3 skips fail the day it lands; 18
  class-construction skips hang off it); private fields `#x` (1049),
  `async_generator_function` (933), compiler negatives (595); Proxy remainders (revocable, 8
  traps, callable/constructable, exotic-target forwarding); Reflect remainders (array-like
  non-Array argLists, class/bound-target construction); `$<name>` named-group substitution
  blocked on RegExp named-group exec; the git-backend `test:rust` failure class (daemon
  filtered env; env-dependent); stage-5 residuals: whole-`language/` single-process sweep
  OOMs (per-subtree by design); cargo-fuzz IS installable (0.13.2); **s16 process finding
  (binding): a whole-tree claim requires the whole-tree enumeration at the claimed tip;
  (s18) a workspace-green claim requires running the workspace at the claimed tip;
  (s27/s28) an acceptance-grade workspace run requires `cargo clean -p endor-compile -p
  endor-vm -p endor-oracle` AND an oracle built from a clean sha-verified moddable checkout
  at the declared pin `23b4d6b0a6`; (s34) the boot-gate count is the TEST BINARY's count
  (28 at stage-10 acceptance) — children's hand-counts drift; (s34) cite forbid as 7
  anchored roots + oracle exempt.** s19 tooling: prebuilt binaries WITHOUT `--`;
  module-corpora is a LIB test. s20: `post-job.sh`/`post-plan.sh` take a body FILE path.
  s21–s34 notes: enumeration scripts `/home/kris/garden2/tmp/s34-enum.sh` (endolin-garden2,
  current — 121 runs, summed totals) and `/home/kris/garden/tmp/s31-enum.sh`
  (endolin-garden); `$HOME` inside the container is per-host — mkdir `$HOME/tmp` before
  redirecting; the worktree helper does NOT seed `rust/engine/target/` (nor the ROOT
  `target/`) — `cp -al` from a same-commit sibling, `rmdir` an empty `c/moddable` first,
  then apply the fresh-clean rule; confirm tip sha + clean status before trusting a seeded
  cache; the ROOT `endo` build needs the generated JS bundles — gitignored placeholders
  suffice for lib tests that do not drive them (`worker_bootstrap.js`/`daemon_bootstrap.js`/
  `ses_boot.js` under `rust/endo/xsnap/src/`); never commit bundles; the hourly press can
  REBASE the branch between sessions and can LAND items when a halt leaves the branch
  unowned (read the latest `xs2rust-endor-press-*` tadas before re-measuring); the
  short-path C-XS clone `~/tmp/s8cxs` exists on BOTH hosts and the short-path daemon
  checkout `~/tmp/s9r` on endolin-garden; the three environment-artifact classes for mass
  failures: AF_UNIX sun_path overflow (real short path only), uniform provisioning-race
  asserts, stale seeded `target/`; channel.test.js cannot finish a 90s serial window (124
  tests × ~5s spin-up — throughput artifact, NOT a hang); ava's TAP reporter crashes in
  `dumpError` on a timed-out test — use the default reporter for timeout truth.
- **C-XS `test:rust` baselines:** serial authoritative anchor **804/26/65** (+110 pending from
  the sandbox-unrunnable endo.test.js), classes: git-backend 8, error-trace worker-assertions
  5, content-store-gc 9, endo.test.js 3, shell /tmp-noexec 1. **Bounded-serial 52-file
  same-harness baseline (the direct comparison table): C-XS 530/19/20/0 vs Rust
  fail=14/skip=20/6-pending + 1 hang (error-trace), classes stable across stages 9 and 10.**
  Concurrent (artifact-classified, NOT an anchor): 646/294/65.
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
  supervisor. Every child body carries push-per-item discipline (s26) and, since stage10c, the
  precondition-gate + STOP-and-checkpoint clauses for round-trip-shaped DoDs.
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s34 assessed NOT tripped — every measured
  stage-10 bar is green with the enumeration exactly on anchor; the one refuted review point
  (F1) is a narrow, precisely-named guard omission with a scoped fixer dispatched, not a
  design fault; the finish line is one precisely-named wiring-plus-gap chain away (the
  daemon's real boot path onto machinery that now demonstrably works under the test
  harness); the program is on its planned trajectory.
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
   1–10 done and ACCEPTED; the stage10d finish-line chain (real two-eval boot → worker-bootstrap wiring →
   gated live round trip → re-measure) is dispatched — your recovery/review. Remaining after it: parity
   closure (design row 8) and ecosystem validation (row 9).**
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
  host: endolin-garden-ece02cb4
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-18T23:26:08Z

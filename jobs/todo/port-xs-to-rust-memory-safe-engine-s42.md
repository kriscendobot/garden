---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-20T02:51:05Z -->

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
(2026-07-18: stage 9c 9/9; **STAGE-9 ACCEPTANCE issuecomment-5011343934**; dispatched stage 10),
`-s32`/`-s33` (stage-10 halt recoveries → 10b/10c), `-s34` (stage-10c 5/5 + press r8; bars
green but F1(s34) frozen-arrays REFUTED; findings issuecomment-5012970220; dispatched 10d),
`-s35` (2026-07-18: 10d landed + verified; **STAGE-10 ACCEPTANCE issuecomment-5013346972**;
dispatched 10e), `-s36` (10e recovery; press closed 3 gaps solo incl. the binding C-XS
`indexOf_aux` unparenthesized-macro artifact — transliterated bit-exactly, never "fix" it;
dispatched 10f), `-s37` (stage-10f 3/3; findings F1(s37) Object.assign integrity/accessors +
F2(s37) sort receiver-mutating comparator, issuecomment-5014930807; 10e/10f DEFERRED;
dispatched 10g), `-s38` (2026-07-19: 10g halted 2/4 — but landed the F1/F2 fixes, 3
array-reflection gaps, and the END value-stack reset `12d997c9fecc` that took the worker
bundle through FULL SES+@endo boot to handleCommand registration; dispatched 10h), `-s39`
(2026-07-19: stage 10h 2/2 — `hostGetDaemonHandle` bound `d911a95894`, remeasure
fail=14/skip=20/1-hang; ALL bars reproduced green from fresh checkout; independent F1/F2(s37)
probe verification: F2 closed, F1's literal-accessor shape REFUTED → **finding F1(s39)**,
issuecomment-5015383357; dispatched the stage10i chain), `-s40` (2026-07-19: stage 10i 3/3 —
accessor fixer `9c54df61e5`, for_of iterator-as-iterable `afff3aaf64` → **the worker bundle
boots the ENTIRE SES+@endo graph, binding gate GREEN**; F1(s39) VERIFIED CLOSED 4/4+16/16;
**STAGE-10e–10i ACCEPTANCE issuecomment-5015638801**; findings F1(s40) class-method DONT_ENUM
+ F2(s40) inferred `.name`; dispatched the stage10j chain), and **`-s41` (2026-07-19, this
job's predecessor):**

- **Stage 10j COMPLETED 3/3 (serial):** (0) flag fixer — F1(s40) `define_apply_attributes`
  (`XS_GET_ONLY` stamp on the data define tail, `6d7ee44a8`) + F2(s40) `fxRenameFunction`
  transliteration (bare key / `get `/`set ` prefixes, Symbol keys honestly anonymous,
  generators deferred to their metered rename, `9f299a6c0`), 16 dual-run tests, dropped-flag
  set EMPTY for result semantics; (1) dispatch child — closed `%TypedArray%.prototype.subarray`
  (same-buffer view, species-correct prototype, `TYPED_ARRAY_SUBARRAY_FRAME_METERING =
  212_984` raw-exact, `42e4fcdf8e`): the real `handleCommand` now decodes a full CBOR deliver
  envelope; gate stayed RED honestly at TWO named frontiers — the **`trace`** host global
  (route/log path) and the **`dub_at`** opcode (CapTP-bootstrap serialize); added the
  self-updating marker `real_handler_decodes_a_real_envelope_to_the_dispatch_path_frontier`;
  (2) remeasure at `42e4fcdf8e` (endolin-garden s9r env): **fail=14/skip=20/hang=1, TSV
  byte-identical to the s10h baseline** — the error-trace pin did NOT move, no new class, C-XS
  not re-run (fail=14-vs-15 is default-reporter accounting of the timed-out error-trace file).
- **s41 reproduced ALL bars green from a fresh checkout at `42e4fcdf8e`** (fresh-clean rule +
  oracle from the clean sha-verified pin): engine **894/0 EXIT=0 (70 `test result:` lines**,
  grew from 871/67 by exactly the 23 new tests in 3 suites), compile-diff **1909/1909 + SYMB
  1909/1909** EXIT=0, boot gate **30/0**, ROOT lib **111/0** real bundles, full-boot marker
  GREEN + dispatch-frontier marker GREEN, forbid 7 roots + oracle exempt, VARIANT_COUNT 35,
  0 non-oracle warnings. Range review (3 Rust-only commits) sound.
- **s41 ran the owed INDEPENDENT F1/F2(s40) verification** (fresh variants the fixer never
  saw: for-in/spread/assign-from over class prototypes, propertyIsEnumerable, constructor
  property, static generators, duplicate methods, literal duplicates; getter/setter name
  prefixes, computed-key names both forms, arrows, anonymous classes, async/generator methods,
  duplicate keys both orders, named funcexprs): **F1(s40) and F2(s40) VERIFIED CLOSED.**
  F1(s39) re-probes 9/9 bit-exact; F1/F2(s37) honest skips 4/4 self-name (incl.
  `Object.keys:unclassified-property` over an enumerable accessor). Probe artifacts
  `~/tmp/s41-results/{s41_probe.rs,s41_attrib.rs,*.log}` (endolin-garden2).
- **STAGE-10j ACCEPTANCE posted: issuecomment-5015969926.**
- **New finding F1(s41) (CONFIRMED, pre-existing at `afff3aaf64` — probe-verified at anchor
  AND tip):** an accessor→data METHOD redefine of the same key leaves the stale getter live on
  the read path (`var o={get m(){return 1},m(){return 2}};o.m();` → oracle "2", endor
  `Throw("call: not a function")`; class-body shape identical; gopd correctly reports the DATA
  shape — the slot is internally inconsistent; the data-VALUE redefine `m:2` works). Binding
  under the F1-class doctrine; fixer dispatched as stage-10k child 0.
- **Advisory metering telemetry recorded (result-exact, pre-existing at the anchor):**
  copy-skip of a non-enum property in spread/assign-from −1; for-in over a class prototype
  with ≥2 skipped methods +1; reflection after a same-key class-body redefine +1; async-method
  define −1 (independent of F2); computed-key gopd off a class prototype +1 (fixer-noted).
  Symbol-keyed method names stay anonymous (no `[desc]` adornment) — deliberate honest skip.
- **s41 dispatched stage 10k** as serial-halt orchestration **`xs2rust-endor-build-stage10k`**,
  three opus children: (0) `xs2rust-endor-stage10k-accessor-redefine-fixer` — F1(s41),
  reproduce-first, transliterate `fxOrdinaryDefineOwnProperty`'s data-over-accessor transition
  (clear GETTER/SETTER + holder linkage), literal/class/computed/generator/async/set-only/
  round-trip coverage, BINDING no-boot-regression clause, redefine-sweep answer required in
  tada; (1) `xs2rust-endor-stage10k-live-captp-dispatch` — bind `trace` (realm-global, ledger
  row same day) + transliterate `dub_at` bit-exact, at most one more frontier item, BINDING
  ~300s gate (marker GREEN AND `dispatch_command_to_handler` Ok, no degrade), verify NO
  silent-ack masking the moment the gate is GREEN, LIVE round trip ONLY if GREEN and ≥1200s
  remain (HARD STOP); (2) `xs2rust-endor-stage10k-remeasure` — outage-hardened detached sweep
  + TSV resume, artifacts `$HOME/tmp/s10k-results/`, must name every error-trace test that
  flipped vs the anchor (the pin is THE question).
- Bar conventions: engine-workspace and ROOT-lib counts are BINARY counts at the measured tip
  and GROW with each gap round — last measured engine **894/0 (70 `test result:` lines)** at
  `42e4fcdf8e`, ROOT endo lib **111** with real bundles, boot gate **30**, compile-diff
  **1909/1909 + SYMB**, forbid 7 anchored roots + oracle exempt, VARIANT_COUNT **35**, oracle
  pin `23b4d6b0a65f…`. Cite the measured number at the measured tip.

You are parked `blocked_on: xs2rust-endor-build-stage10k` and will be promoted when the
orchestration reaches a terminal state (all three children tada, or a halt on child failure).
**FIRST:** sync your journal worktree (`git -C journal pull --ff-only origin journal2`; on
"multiple branches" fall back to fetch + `merge --ff-only FETCH_HEAD`), read
`journal/jobs/tada/xs2rust-endor-build-stage10k.md` and every child tada
(`journal/jobs/tada/xs2rust-endor-stage10k-*.md`). If the orchestration halted, check
`git log --all -- jobs/` for reaper poisoning and classify before re-dispatching (outage vs
sizing vs spec defect — zero-push poison is SIZING; poison AFTER pushes is
sizing-with-partial-completion: re-cut minus the landed items; repeated transient-handler-kill
poison with 0 deadline overruns is OUTAGE — re-cut same shape; a poisoned plan entry left by
the reaper must be retired when superseded). The dispatch child may legitimately tada as a
DEGRADED gap round or a gate-GREEN checkpoint short of the round trip (both honest success);
the remeasure may legitimately SKIP only if the tip regressed to an already-measured sha. Read
the latest `xs2rust-endor-press-*` tadas before re-measuring — the press advances the branch
between sessions and can LAND items when a halt leaves the branch unowned.

**Your job (s42):**

1. **If stage 10k halted:** classify, re-dispatch the remainder (stage10l, same discipline —
   precondition-gate + HARD-STOP + outage-hardened-remeasure clauses; carry the dispatch-path
   frontier as the resume point), park s43 blocked on it carrying this spec.
2. **If stage 10k completed:** **verify the F1(s41) fix INDEPENDENTLY** — reconstruct probes
   from the findings record (accessor→data method redefine, literal + class, read-path AND
   descriptor coherence) at the real remote tip, PLUS fresh variants of your own devising (the
   fixer has seen the s41 probes: vary — e.g. Reflect.get after redefine, `in`/hasOwnProperty,
   redefine inside `extends` bodies, setter-only→generator-method, triple redefines,
   `Object.entries` if covered); require agreement or honest named skips. Re-run the
   F1/F2(s40) + F1(s39) + s37 probe families (no regression; `~/tmp/s41-results/s41_probe.rs`
   is the s41 matrix — vary it, don't just re-run it). **If the dispatch child claims the gate
   GREEN or the LIVE round trip: reproduce it independently** (the silent-ack-masking check is
   binding — a command the handler completes must flow its REAL value), and confirm the
   remeasure's error-trace answer accounts for all 6 pinned tests. Then review the stage-10k
   range (fresh checkout at the real remote tip, current bars vs the anchors, substantive diff
   review — the `trace` realm-global's ledger row and SES-lockdown surface, the `dub_at`
   transliteration fidelity, and the accessor-clear's interaction with the holder-instance
   model deserve particular scrutiny). On green: **post the stage-10k ACCEPTANCE** on PR #600
   with measured numbers. On new findings: post them, dispatch a fixer, park s43.
3. **Decide the next stage:** if the maintainer's binding finish line (all `test:rust` daemon
   tests passing on the Rust engine modulo the expected-divergence ledger — the error-trace
   6-pending-hang pin must MOVE via a live round trip — plus test262 parity per the amended
   accuracy-over-parity bar) is MET — proceed to the hand-off protocol (rebase/weave if
   CONFLICTING vs `llm` (last press: ahead 437 / behind 10), un-draft PR #600, bulletin entry
   + maintainer-inbox note with PR URL and status summary; the single point a human enters the
   loop). If NOT met: dispatch the next stage from the live tree (candidates: the error-trace
   hang once the round trip is live, remaining dispatch-path frontier items as stage10l,
   F1-class full-fidelity graduation (accessor-setter re-entry + catchable TypeError with
   bit-exact metering; Object.keys-over-accessor + assign-onto-accessor skip graduation),
   remaining Proxy MOP traps, `super()` construction, parity closure design row 8, ecosystem
   validation row 9) as a serial-halt orchestration, and park s43 blocked on it carrying this
   spec with updated state.

Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT
  until the finish line.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5,
  stage 6 (Snapshots), stage 7, stage 8, stage 9 (incl. 9b/9c), stage 10 (incl. 10b/10c/
  press-r8 + the 10d F1 fix), stages 10e/10f/10g/10h/10i, AND stage 10j: done and ACCEPTED**
  (s7: issuecomment-4888517639; s8: issuecomment-4888883354; s11: issuecomment-4897783472; s19
  stage-5: issuecomment-4996709674; s21 stage-6: issuecomment-4997552045; s23 stage-7:
  issuecomment-5002369752; s28 stage-8: issuecomment-5009970041; s31 stage-9:
  issuecomment-5011343934; s35 stage-10: issuecomment-5013346972; s40 stages 10e–10i:
  issuecomment-5015638801; **s41 stage-10j: issuecomment-5015969926**). **The stage10k chain
  (F1(s41) accessor-redefine fixer → trace+dub_at dispatch + gated LIVE round trip →
  outage-hardened remeasure) is dispatched — your job is its recovery/review and the stage-10k
  acceptance decision.** Remaining after it: the error-trace hang pin (must move via the live
  round trip), parity closure (design row 8), ecosystem validation (row 9).
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
  (HostReplyChannel, SnapshotExcluded — since 10h also carrying
  `host_get_daemon_handle_fns`/`host_daemon_handle`), stage 10b's `retained_code`
  (RetainedProgramCode, SnapshotExcluded, GC-invisible raw bytes by contract) + any WeakMap
  store; `DebuggerState` is GC-invisible/SnapshotExcluded by contract; verify at whichever
  stage first wires GC); the snapshot side-table ledger's Pending rows gate
  live-state-across-suspend, NOT the accepted inter-crank contract; any NEW side table must be
  ledgered the day it lands (**the `trace` binding, if it adds one, included**);
  `runtime_key_names` (s37): GC-invisible, runtime-only — its live-state-across-suspend
  treatment is a named Pending-class follow-up; the END value-stack reset (s38, s39-verified):
  `CallerState.entry_stack_len` truncation at every END variant, metering-neutral;
  `dispatch_deliver` gates real-handler routing on full boot completion AND degrades to
  fold-ack on an invoke-time handler frontier (s40-verified honest; **verify no silent-ack
  masking once the dispatch path is live — a command the handler completes must flow its REAL
  value**); F1(s37)/F2(s37) honest named skips
  (`assign:accessor-target`/`assign:nonwritable-target`,
  `sort:receiver-mutated-during-sort`) — s39+s40+s41-verified; their full-fidelity graduation
  (re-entering the setter, the oracle's catchable TypeError bit-exact) is a named follow-up;
  **F1(s39) VERIFIED CLOSED (s40 4/4+16/16; s41 re-probes 9/9); F1(s40)/F2(s40) VERIFIED
  CLOSED (s41: fresh-variant matrices; dropped-flag set EMPTY for result semantics);** the
  accessor-define path routes through the holder-instance model; `Object.keys` over an
  enumerable accessor + `Object.assign` onto an accessor target honest-skip — their graduation
  is a named follow-up; the s34/s37/s39/s40/s41 F1 bug CLASS is binding review doctrine: any
  integrity/flag enablement, any NEW write/mutation path onto guest-reachable targets, AND any
  DEFINITION path must preserve/honor property flags end to end AND leave the slot coherent;
  **F1(s41) (OPEN, fixer dispatched): accessor→data method redefine leaves a stale getter on
  the read path while gopd reports the data shape — the stage10k fixer's redefine sweep must
  be reviewed at s42 (is the stale-accessor set EMPTY?)**; the s41 advisory ±1 family
  (copy-skip −1, ≥2-method for-in +1, post-redefine reflection +1, async-define −1,
  computed-key gopd +1) is recorded telemetry — do not let a fixer silently regress RESULTS
  chasing it; Symbol-keyed method names stay anonymous (no `[desc]` adornment) — deliberate
  honest skip; cross-crank persistent-heap continuity fixtures — extend as new state becomes
  cross-crank-real; accessor properties use a holder-instance model (no side table; snapshot
  round-trip of an accessor property not explicitly tested — hardening follow-up);
  primitive-receiver accessors + non-array Map/Set iterables self-name; the for_of
  iterator-as-iterable branch (s40-verified): `%IteratorPrototype%` identity push-back,
  `FOR_OF_GET_ITERATOR_METERING`; copy-constructed `new Set([…])`/`new Map([…])` metering
  divergence is pre-existing and isolated; FUNCTION_* analytic decomposition (advisory);
  sub-computron construct-`this` + object-literal drifts (advisory); generator saved-slice
  metering residual (advisory); String.raw computron gap (advisory); native→JS host-frame +
  accessor-dispatch metering residuals (advisory — result-exact); the stage3-arrays/265
  flatMap allocation +1 (documented result-gated case); module-goal oracle seam: COMPILE-only
  module entry landed — runtime module linking/evaluation + guest
  `Compartment.evaluate`-of-source + `-c`/`-lc` ses modes belong to test262-convergence; F1
  doctrine: shim widenings are high-risk, separately audited; BothAbort
  same-value/different-cost should graduate under the result bar (test262-convergence);
  dual-run runner must survive an ORACLE crash as a named class (verify when convenient);
  engine items still open: sort/toSorted/from/of residuals (holey/frozen receivers + result
  coercion remain named skips), string residuals; `XS_CODE_DELETE_PROPERTY_AT` computed
  delete; frozen-exotic integrity CLOSED for the freeze-ordinary kinds incl. F1(s34)'s paths,
  harden-of-Array/RegExp traversal, array length/index gopd + ownKeys frozen flags — still
  open: TypedArray freeze (spec-throws when non-empty), Proxy integrity traps,
  `seal`/`isSealed` on exotics; AT-key `re["lastIndex"]=N` misses the RegExp side table even
  non-frozen (fixer follow-up note); wrapper reads after freeze are pre-existing read-side
  skips; double-metering on native `.call`/`.apply`/bound-of-native trampolines (advisory,
  result-exact); u16 canonical symbol-space ceiling in long-lived persistent realms (~65535
  names, append-only — theoretical; revisit at parity closure); complete function
  `Reflect.ownKeys` (length/name/prototype prepend); bound-of-bound self-names at CALL;
  primitive-`this` boxing on `.call`/`.apply`; native CONSTRUCTOR in callback position (named
  skip, r8); `Reflect.getOwnPropertyDescriptor` on an accessor property self-names (the
  Object form works); TypedArray-INSTANCE `getOwnPropertyDescriptor` self-names;
  `JSON.stringify:interned-key` honest skip (s41-observed over class prototypes);
  `%TypedArray%.prototype.subarray` BigInt-element views self-name; closures over a prior
  turn's top-level `var` do not survive turns BY DESIGN (realm idiom `globalThis.X = …`);
  `super()` construction + derived-this-TDZ is a named self-alarming remainder (the two §3
  skips fail the day it lands; 18 class-construction skips hang off it); private fields `#x`
  (1049), `async_generator_function` (933), compiler negatives (595); Proxy remainders
  (revocable, 8 traps, callable/constructable, exotic-target forwarding); Reflect remainders
  (array-like non-Array argLists, class/bound-target construction); `$<name>` named-group
  substitution blocked on RegExp named-group exec; the git-backend `test:rust` failure class
  (daemon filtered env; env-dependent); stage-5 residuals: whole-`language/` single-process
  sweep OOMs (per-subtree by design); cargo-fuzz IS installable (0.13.2); **s16 process
  finding (binding): a whole-tree claim requires the whole-tree enumeration at the claimed
  tip; (s18) a workspace-green claim requires running the workspace at the claimed tip;
  (s27/s28) an acceptance-grade workspace run requires `cargo clean -p endor-compile -p
  endor-vm -p endor-oracle` AND an oracle built from a clean sha-verified moddable checkout at
  the declared pin `23b4d6b0a6`; (s34) the boot-gate count is the TEST BINARY's count (30 =
  `endor-262 --test boot_bundle_gate`); (s34) cite forbid as 7 anchored roots + oracle exempt;
  (s36/s39/s40/s41) engine-workspace and ROOT-lib counts are BINARY counts at the measured tip
  — they grow with each gap round (894 / 70 `test result:` lines at `42e4fcdf8e`;
  111-with-real-bundles ROOT); (s36) the press-found C-XS `indexOf_aux` unparenthesized-macro
  artifact (1 raw per matched lead byte) is transliterated bit-exactly — do not "fix" it;
  (s39/s40/s41) INDEPENDENT verification means reconstructing probes from the findings RECORD
  plus fresh variants the fixer has never seen — the s37 fixer reproduced the finding in a
  different shape and the divergent shape was the live defect; (s41) attribute a new finding
  by RE-RUNNING the minimal probe at the pre-stage anchor before deciding
  accept-vs-defer — pre-existing findings do not block a stage acceptance.** s19 tooling:
  prebuilt binaries WITHOUT `--`; module-corpora is a LIB test; compile-diff no-arg = the
  curated 1909 corpora + SYMB (there is no `--symb` flag). s20: `post-job.sh`/`post-plan.sh`
  take a body FILE path. s21–s41 notes: enumeration scripts `/home/kris/garden2/tmp/s34-enum.sh`
  (endolin-garden2) and `/home/kris/garden/tmp/s31-enum.sh` (endolin-garden); `$HOME` inside
  the container is per-host — mkdir `$HOME/tmp` before redirecting; the worktree helper does
  NOT seed `rust/engine/target/` (nor the ROOT `target/`) — `cp -al` from a
  same-commit-or-near sibling (the s41 supervisor worktree
  `project-wt-port-xs-to-rust-memory-safe-engine-s41-5cd7f36a` at `42e4fcdf8e` survives on
  endolin-garden2 with fully built caches: engine target, ROOT target, oracle at the pin, real
  bundles), `rmdir` an empty `c/moddable` first, then apply the fresh-clean rule; confirm tip
  sha + clean status before trusting a seeded cache; the ROOT `endo` build needs the generated
  JS bundles — REAL bundles seed from `/home/kris/garden/tmp/s9r/rust/endo/xsnap/src/` on
  endolin-garden or the s41 worktree's `rust/endo/xsnap/src/*.js` on endolin-garden2; never
  commit bundles; the hourly press can REBASE the branch between sessions and can LAND items
  when a halt leaves the branch unowned (read the latest `xs2rust-endor-press-*` tadas before
  re-measuring); the short-path C-XS clone `~/tmp/s8cxs` exists on BOTH hosts; the short-path
  daemon env `/home/kris/garden/tmp/s9r` (endolin-garden) is the proven sweep env; sweep
  artifacts: `~/tmp/s10f-results/` + `~/tmp/s37-results/` + `~/tmp/s10i-results/` +
  `~/tmp/s41-results/` (endolin-garden2 — s41-results holds the s41 probe matrices + all bar
  logs), `~/tmp/s10h-results/` + `~/tmp/s39-results/` + `~/tmp/s40-results/` +
  `~/tmp/s10j-results/` (endolin-garden), `$HOME/tmp/s10k-results/` is the stage10k sweep's
  home; the three environment-artifact classes for mass failures: AF_UNIX sun_path overflow
  (real short path only), uniform provisioning-race asserts, stale seeded `target/`;
  channel.test.js can complete clean in a 900s window; ava's TAP reporter crashes in
  `dumpError` on a timed-out test — use the default reporter for timeout truth.
- **C-XS `test:rust` baselines:** serial authoritative anchor **804/26/65** (+110 pending from
  the sandbox-unrunnable endo.test.js), classes: git-backend 8, error-trace worker-assertions
  5, content-store-gc 9, endo.test.js 3, shell /tmp-noexec 1. **Bounded-serial 52-file
  same-harness baseline (the direct comparison table): C-XS 530/19/20/0 vs Rust
  fail=14/skip=20/hang=1 (error-trace pin), classes stable across stages 9, 10, the
  10f/10h/10i remeasures, and the 10j remeasure at `42e4fcdf8e` (TSV byte-identical to
  s10h).** Concurrent (artifact-classified, NOT an anchor): 646/294/65.
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
  precondition-gate + STOP-and-checkpoint clauses for round-trip-shaped DoDs (since stage10h,
  HARD STOP: reassess the clock after every pushed item; round trip only with ≥1200s
  remaining); since stage10f, measurement children carry the detached-sweep + resume-from-TSV
  outage hardening (proven across reaper requeues).
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s41 assessed NOT tripped — stage 10j completed 3/3
  cleanly, all bars reproduced green from a fresh checkout, F1/F2(s40) verified closed against
  fresh variants, the CBOR envelope now decodes end-to-end, and the one new finding is a
  pre-existing slot-coherence defect with a clear doctrine-compliant fix; the frontier is two
  named items (`trace` + `dub_at`) with the live round trip directly behind them.
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
   1–10, 10e–10i, AND 10j done and ACCEPTED; the stage10k chain (F1(s41) accessor-redefine fixer →
   trace+dub_at dispatch + gated LIVE round trip → outage-hardened remeasure) is dispatched — your
   recovery/review and the stage-10k acceptance decision. Remaining after it: the error-trace pin (must
   move via the live round trip), parity closure (design row 8), and ecosystem validation (row 9).**
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

---
gate: blocked
blocked_on: xs2rust-endor-build-stage10n
priority: normal
posted_by: producer
posted_at: 2026-07-20T06:30:30Z
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
(2026-07-19: stage 10h 2/2 — `hostGetDaemonHandle` bound, remeasure
fail=14/skip=20/1-hang; ALL bars reproduced green from fresh checkout; independent F1/F2(s37)
probe verification: F2 closed, F1's literal-accessor shape REFUTED → **finding F1(s39)**,
issuecomment-5015383357; dispatched the stage10i chain), `-s40` (2026-07-19: stage 10i 3/3 —
accessor fixer + for_of iterator-as-iterable → **the worker bundle boots the ENTIRE SES+@endo
graph, binding gate GREEN**; F1(s39) VERIFIED CLOSED 4/4+16/16; **STAGE-10e–10i ACCEPTANCE
issuecomment-5015638801**; findings F1(s40) class-method DONT_ENUM + F2(s40) inferred `.name`;
dispatched the stage10j chain), `-s41` (2026-07-19: stage 10j 3/3 — F1/F2(s40) flag fixes,
`%TypedArray%.prototype.subarray` closed so the real `handleCommand` decodes a full CBOR
envelope, remeasure TSV-identical; F1/F2(s40) VERIFIED CLOSED; **STAGE-10j ACCEPTANCE
issuecomment-5015969926**; new finding F1(s41) accessor→data method-redefine stale getter;
dispatched the stage10k chain), `-s42` (2026-07-20: stage 10k 3/3 — F1(s41) fixed
(`c7ccf5716`), `trace` host global + `dub_at` bit-exact → **the CapTP dispatch gate GREEN**
with the silent-ack masking defect found and fixed (drained host frames are the real replies);
remeasure TSV-identical at `c34ffd9012`; F1(s41) VERIFIED CLOSED via 34-probe fresh-variant
matrix; **STAGE-10k ACCEPTANCE issuecomment-5018362782**; findings F1(s42) gOPN unbound +
F2(s42) Reflect.get holder leak, both probe-attributed pre-existing; dispatched the stage10l
chain; the press REBASED the branch onto `llm` 2026-07-20T02:33Z — ahead 440 / behind 0), and
`-s43` (2026-07-20: stage 10l 3/3 — F1/F2(s42) fixed and VERIFIED CLOSED via a 38-probe
fresh-variant matrix, the holder-leak set EMPTY for reflective reads; **the LIVE error-trace 6-pending
pin MOVED: all 6 flipped to pass, 7/7 deterministic twice on s9r** at `1481757f7f` with genuine frames,
zero engine changes needed; all bars reproduced green from a fresh checkout (engine 923/0, 73 lines;
1909/1909+SYMB; 30/0; 111/0; VARIANT_COUNT 35); **STAGE-10l ACCEPTANCE issuecomment-5018744962**;
findings: F1(s43) native-fn `length`/`name` reflection absent engine-wide (pre-existing) + the s10e
HOST-GATED stall localized between eval FORMULATE and worker delivery; dispatched the four-child
stage10m chain), and **`-s44` (2026-07-20, this job's predecessor):**

- **Stage 10m HALTED at child 2 (`xs2rust-endor-stage10m-live-env-diagnosis`)** after children 0/1
  completed; child 3 (remeasure) swept unrun. s44 classified the halt **OUTAGE — opus-model-specific
  API/quota**: five transient-handler kills 05:22–06:13Z 2026-07-20 across BOTH hosts, each within
  3–16 min of claim (zero deadline overruns, zero pushes, requeue-exhausted poison); the diagnosis
  child was the ONLY opus job in the window (child 1 tada'd 05:19Z, minutes before the kills began)
  while fleet-default jobs completed normally on both hosts throughout; an opus probe at 06:23Z
  succeeded (`OPUS-OK`, exit 0). Re-cut same shape per doctrine. Retired the poisoned diagnosis plan
  entry; absorbed the reaper's maintainer-inbox poison-notice into the supervisor loop (unread→read)
  per sizing doctrine.
- **Stage-10m child 0 LANDED (`8b9c050825`, pushed, bars green — INDEPENDENT VERIFICATION OWED, yours):**
  the `XS_CODE_SET_PROPERTY_AT` integer-index frontier on ordinary objects, transliterated from
  `fxOrdinarySetProperty`/`fxSetIndexProperty`'s hidden `XS_ARRAY_KIND` index chunk — carried as a
  **NEW side table `SideTable::ObjectIndices`** (BTreeMap per instance, `Coverage::Pending`,
  **VARIANT_COUNT 35→36**, ledgered same-day). Write (`o[2]=v`, `{2:'x'}` literals) + read paths land;
  the **BINDING integer-first key order** (indices ascending FIRST, then strings in creation order)
  landed for `Object.keys`/`Object.getOwnPropertyNames`/`for-in`/`JSON.stringify`; oracle-certified
  (`{b:1,2:'x',a:2,1:'y'}` → `"1,2,b,a"`). Non-extensible/frozen receivers reject a NEW index (sloppy
  no-op / strict self-name); ambiguous existing-index overwrite honest-skips. Non-required consumers
  (`Object.entries`/`values`, `Reflect.ownKeys`, spread, `Object.assign`, `defineProperties`)
  honest-skip index-keyed receivers rather than drop keys; index-key query paths (`in`,
  `hasOwnProperty`, `getOwnPropertyDescriptor`, `delete o[k]`) verified already-honest-skip. 7 new
  dual-run gates. Child-cited bars: engine **930/0 (74 lines)**, 1909/1909+SYMB, 30/0, ROOT 111/0,
  0 warnings, no new unsafe.
- **Stage-10m child 1 LANDED (`d268092d7b`, pushed, bars green — INDEPENDENT VERIFICATION OWED, yours):**
  F1(s43) fixed engine-wide. Per-method/ctor **spec arities transliterated from the pinned moddable's
  host-function builder tables** (`fxNextHostFunctionProperty`/`fxBuildHostConstructor`, keyed by the
  exact `fx_...` callback; `keys`/`apply`/`get` collisions disambiguated by variant, never name);
  `name`/`arity`/`name_chunk` stamped at boot unmetered (ctors at alloc, prototype methods+statics in
  the install loop, direct-intrinsic globals incl. `harden`/`lockdown`); `GET_PROPERTY`+gOPD
  synthesize `length`/`name` lazily with XS flags `{writable:false, enumerable:false,
  configurable:true}`; **graduated the ledger's `Reflect.ownKeys` length/name(,prototype)-prepend
  row** (gOPN too, XS creation order); bound functions read the TARGET's reflection
  (`.name "bound keys"`, `.length` post-bind); user functions unchanged; symbol-keyed/exotic
  accessors stay unreflected (anonymous-name row not regressed). 6 new dual-run tests. Child-cited
  bars at `d268092d7b`: engine EXIT=0 all green (+6 tests), 1909/1909+SYMB, 30/0, ROOT 111/0, no new
  side table (reused `FuncInfo`). NEW out-of-scope observations (unfixed, now ledgered): `''.padStart`
  unbound; `Map.groupBy`/`RegExp.escape` statics unbound (constructor own-keys agree only on the
  reflection prefix).
- **s44 dispatched stage 10n** as serial-halt orchestration **`xs2rust-endor-build-stage10n`**, two
  opus children: (0) `xs2rust-endor-stage10n-live-env-diagnosis` — the 10m diagnosis body re-cut same
  shape (zero-push default, HARD STOP, env-vs-engine-vs-checkpoint classification triad, artifacts
  `$HOME/tmp/s10n-diagnosis/`), updated for the advanced tip (re-sync s10e + rebuild + RE-RUN the
  repro FIRST — done early if the stall vanished at tip; check `$HOME/tmp/s10m-diagnosis/` for
  leftovers, none expected); (1) `xs2rust-endor-stage10n-remeasure` — the outage-hardened detached
  sweep re-cut (artifacts `$HOME/tmp/s10n-results/`; may NOT skip — the tip advanced past
  `1481757f7f`; must apply the diagnosis remediation if one landed; 4 required answers incl. naming
  every error-trace test vs the s10i/s10k/s10l anchor).
- Stale-board notes: `jobs/doin/xs2rust-endor-stage10k-remeasure.md` is a superseded 10k-era
  measurement re-promotion (measurement-only, harmless, left to the reaper); the poisoned hourly-press
  plan entry (deadline-overrun 03:13Z) is superseded by the next press mint.
- Bar conventions: engine-workspace and ROOT-lib counts are BINARY counts at the measured tip and GROW
  with each gap round — last child-cited engine **930/0 (74 `test result:` lines)** at `8b9c050825`
  (+6 more tests green at `d268092d7b`), ROOT endo lib **111/0** with real bundles, boot gate
  **30/0**, compile-diff **1909/1909 + SYMB**, forbid anchored roots + oracle exempt, VARIANT_COUNT
  **36**, oracle pin `23b4d6b0a65f…`. Cite the measured number at the measured tip; s44's numbers are
  CHILD-cited — the fresh-checkout reproduction is owed at the stage-10m/10n acceptance review.

You are parked `blocked_on: xs2rust-endor-build-stage10n` and will be promoted when the orchestration
reaches a terminal state (both children tada, or a halt on child failure). **FIRST:** sync your
journal worktree (`git -C journal pull --ff-only origin journal2`; on "multiple branches" fall back to
fetch + `merge --ff-only FETCH_HEAD`; if the pull dies on stale unmerged index entries from another
job, resolve those paths to HEAD — `git reset` + `git checkout HEAD --` them — then re-pull), read
`journal/jobs/tada/xs2rust-endor-build-stage10n.md` and every child tada
(`journal/jobs/tada/xs2rust-endor-stage10n-*.md`) PLUS the already-landed stage-10m child tadas
(`journal/jobs/tada/xs2rust-endor-stage10m-{set-property-at,native-fn-reflection}.md`). If the
orchestration halted, check `git log --all -- jobs/` for reaper poisoning and classify before
re-dispatching (outage vs sizing vs spec defect — zero-push poison is SIZING; poison AFTER pushes is
sizing-with-partial-completion: re-cut minus the landed items; repeated transient-handler-kill poison
with 0 deadline overruns is OUTAGE — re-cut same shape; **the s44 refinement: before locking an
outage classification, check whether OTHER jobs completed in the window — a kill pattern confined to
one job while fleet-default jobs run clean is a MODEL-specific outage (probe the model with a
one-token `claude -p --model` call before re-cutting into it)**; a poisoned plan entry left by the
reaper must be retired when superseded). The diagnosis child may legitimately tada as a classified
checkpoint short of a root cause (honest success); the remeasure may legitimately SKIP only if the
tip regressed to an already-measured sha. Read the latest `xs2rust-endor-press-*` tadas before
re-measuring — the press advances (and REBASES) the branch between sessions and can LAND items when a
halt leaves the branch unowned.

**Your job (s45):**

1. **If stage 10n halted:** classify per the doctrine above, re-dispatch the remainder (stage10o,
   same discipline — precondition-gate + HARD-STOP + outage-hardened-remeasure clauses; carry the
   s10e-diagnosis goal as the resume point if it is what fell), park s46 blocked on it carrying this
   spec.
2. **If stage 10n completed:** run the **whole-stage-10m+10n acceptance review** — the independent
   verification owed for BOTH landed stage-10m fixes plus the 10n outcomes: for `set_property_at`
   (`8b9c050825`): reconstruct probes from the child's record PLUS fresh variants of your own devising
   (computed string/integer keys on plain objects and arrays, the BINDING integer-first key-order
   probes across keys/gOPN/for-in/JSON.stringify, accessor-setter via computed key, frozen/sealed
   receivers incl. the new-index reject + existing-index honest-skip split, interaction with the
   honest-skipped consumers (entries/values/Reflect.ownKeys/spread/assign), RegExp `lastIndex` AT-key
   ledger row); for F1(s43) (`d268092d7b`): fresh arity/name spot-checks across intrinsics the fixer
   never probed, **verified against the pinned C's builder tables — never guessed** (incl. `.name`,
   flags via gOPD, bound-of-bound, the own-keys prepend order, and the graduated Reflect.ownKeys
   row); require agreement or honest named skips; re-run varied s37/s40/s41/s42/s43 probe families
   (no regression — vary, don't re-run verbatim; the s43 matrix is `~/tmp/s43-results/s43_probe.rs`
   on endolin-garden2). Review the stage-10m+10n range at a fresh checkout and REPRODUCE the bars
   (the s44 numbers are child-cited only; the F1-bug-class doctrine covers WRITE paths — now incl.
   the ObjectIndices index-chunk writes — REFLECTIVE READS, and DEFINITION paths alike). Weigh the
   diagnosis child's classification: if it proved an ENGINE defect, that is a finding to fix before
   acceptance; if env, confirm the remediation made the flip sweep-observable (or is honestly
   documented as s9r-only). On green: **post the combined stage-10m/10n ACCEPTANCE** on PR #600 with
   measured numbers. On new findings: attribute at the pre-stage anchor `1481757f7f` first
   (pre-existing does not block), post them, dispatch fixers, park s46.
3. **Decide the next stage:** if the maintainer's binding finish line (all `test:rust` daemon tests
   passing on the Rust engine modulo the expected-divergence ledger — the error-trace pin has MOVED
   live on s9r; sweep-observability per the diagnosis outcome — plus test262 parity per the amended
   accuracy-over-parity bar) is MET — proceed to the hand-off protocol (rebase/weave if CONFLICTING vs
   `llm`, un-draft PR #600, bulletin entry + maintainer-inbox note with PR URL and status summary; the
   single point a human enters the loop). If NOT met: dispatch the next stage from the live tree
   (candidates: F1-class full-fidelity graduation (accessor-setter re-entry + catchable TypeError with
   bit-exact metering; Object.keys-over-accessor + assign-onto-accessor skip graduation;
   `defineProperty:redefine` + `define-accessor-at-index`), the set_property_at remainder frontiers
   (`XS_CODE_DELETE_PROPERTY_AT`, integer-index `in`/`hasOwnProperty`/gOPD/accessors, index keys into
   entries/values/Reflect.ownKeys/spread), the newly-observed unbound statics (`''.padStart`,
   `Map.groupBy`, `RegExp.escape`), remaining Proxy MOP traps, `super()` construction (18
   class-construction skips hang off it), parity closure design row 8, ecosystem validation row 9) as
   a serial-halt orchestration, and park s46 blocked on it carrying this spec with updated state.

Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT
  until the finish line.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5, stage 6
  (Snapshots), stage 7, stage 8, stage 9 (incl. 9b/9c), stage 10 (incl. 10b/10c/press-r8 + the 10d F1
  fix), stages 10e/10f/10g/10h/10i, stage 10j, stage 10k, AND stage 10l: done and ACCEPTED** (s7:
  issuecomment-4888517639; s8: issuecomment-4888883354; s11: issuecomment-4897783472; s19 stage-5:
  issuecomment-4996709674; s21 stage-6: issuecomment-4997552045; s23 stage-7:
  issuecomment-5002369752; s28 stage-8: issuecomment-5009970041; s31 stage-9:
  issuecomment-5011343934; s35 stage-10: issuecomment-5013346972; s40 stages 10e–10i:
  issuecomment-5015638801; s41 stage-10j: issuecomment-5015969926; s42 stage-10k:
  issuecomment-5018362782; **s43 stage-10l: issuecomment-5018744962**). **Stage-10m children 0/1 (`set_property_at` `8b9c050825`, native-fn reflection `d268092d7b`)
  LANDED with child-cited green bars — independent verification owed; the stage10n chain (s10e
  live-env diagnosis re-cut → remeasure) is dispatched after the opus outage requeue-exhausted the
  10m diagnosis child — your job is its recovery/review and the combined stage-10m/10n acceptance
  decision.** The LIVE
  error-trace pin is CLOSED on the proven env (s9r, 7/7 deterministic); sweep-observability on
  endolin-garden2 awaits the diagnosis child. Remaining after 10m: parity closure (design row 8),
  ecosystem validation (row 9).
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
  `host_get_daemon_handle_fns`/`host_daemon_handle`, since 10k also carrying
  `host_trace_fns`/`host_trace_outbox`), stage-10m child 0's `object_indices` (`SideTable::ObjectIndices`, Coverage::Pending), stage 10b's `retained_code`
  (RetainedProgramCode, SnapshotExcluded, GC-invisible raw bytes by contract) + any WeakMap
  store; `DebuggerState` is GC-invisible/SnapshotExcluded by contract; verify at whichever
  stage first wires GC); the snapshot side-table ledger's Pending rows gate
  live-state-across-suspend, NOT the accepted inter-crank contract; any NEW side table must be
  ledgered the day it lands; `runtime_key_names` (s37): GC-invisible, runtime-only — its
  live-state-across-suspend treatment is a named Pending-class follow-up; the END value-stack
  reset (s38, s39-verified): `CallerState.entry_stack_len` truncation at every END variant,
  metering-neutral; `dispatch_deliver` (s42-verified): gates real-handler routing on full boot
  completion, surfaces DRAINED HOST FRAMES as the real replies (no synthetic `"undefined"` ack —
  the silent-ack fix), degrades to fold-ack ONLY on handler-not-ready or an invoke-time handler
  frontier; the rendered-string-`"undefined"` return seam is a named follow-up (typed completion
  signal); F1(s37)/F2(s37) honest named skips
  (`assign:accessor-target`/`assign:nonwritable-target`,
  `sort:receiver-mutated-during-sort`) — s39+s40+s41+s42+s43-verified; their full-fidelity
  graduation (re-entering the setter, the oracle's catchable TypeError bit-exact) is a named
  follow-up; **F1(s39), F1(s40)/F2(s40), F1(s41), AND F1/F2(s42) all VERIFIED CLOSED** (s42:
  34-probe matrix; s43: 38-probe matrix, 0 stage-attributable wrong completions); the
  accessor-define path routes through the holder-instance model, the accessor→data redefine
  clears the accessor markers in `instance_put` (s42-verified scoped), and reflective reads
  route through the accessor read path — **the holder-leak set is EMPTY for reflective reads**
  (s43-verified; `Reflect.getOwnPropertyDescriptor` over an accessor remains an honest
  self-name; `Object.getOwnPropertyDescriptor` returns the getter FUNCTION); `Object.keys` over
  an enumerable accessor + `Object.assign` onto an accessor target honest-skip — graduation is
  a named follow-up; the s34/s37/s39/s40/s41 F1 bug CLASS is binding review doctrine: any
  integrity/flag enablement, any NEW write/mutation path onto guest-reachable targets, AND any
  DEFINITION path must preserve/honor property flags end to end AND leave the slot coherent —
  s42 extended the class to REFLECTIVE READ paths (a read must invoke the accessor, never leak
  the holder); **F1(s43): FIXED by stage-10m child 1 (`d268092d7b` — arities transliterated from the pinned C
  builder tables keyed by exact `fx_` callback; lazy `length`/`name` synthesis with XS flags; gOPN +
  Reflect.ownKeys prepend graduated; bound functions read target reflection) — INDEPENDENT
  VERIFICATION OWED: spot-check arities against the pinned C, never guessed; NEW observed unfixed
  siblings: `''.padStart` unbound, `Map.groupBy`/`RegExp.escape` statics unbound**; **the s10e live-stall
  (OPEN, diagnosis child RE-CUT as stage-10n child 0 after the opus outage requeue-exhausted the 10m
  instance with zero work done): the engine-hosted daemon stalls between eval FORMULATE and worker
  delivery, deterministic on s10e, green on s9r — classification env-vs-engine pending; the re-cut
  re-runs the repro at the ADVANCED tip first**; the s41 advisory ±1 family (copy-skip −1, ≥2-method
  for-in +1, post-redefine reflection +1, async-define −1, computed-key gopd +1) plus the s42
  systemic computed-method-call +1 (context-dependent, non-scaling) are recorded telemetry — do
  not let a fixer silently regress RESULTS chasing them; Symbol-keyed method names stay
  anonymous — deliberate honest skip; cross-crank persistent-heap continuity fixtures — extend
  as new state becomes cross-crank-real; accessor properties use a holder-instance model (no
  side table; snapshot round-trip of an accessor property not explicitly tested — hardening
  follow-up); primitive-receiver accessors + non-array Map/Set iterables self-name; the for_of
  iterator-as-iterable branch (s40-verified); copy-constructed `new Set([…])`/`new Map([…])`
  metering divergence is pre-existing and isolated; FUNCTION_* analytic decomposition
  (advisory); sub-computron construct-`this` + object-literal drifts (advisory); generator
  saved-slice metering residual (advisory); String.raw computron gap (advisory); native→JS
  host-frame + accessor-dispatch metering residuals (advisory — result-exact); the
  stage3-arrays/265 flatMap allocation +1 (documented result-gated case); module-goal oracle
  seam: COMPILE-only module entry landed — runtime module linking/evaluation + guest
  `Compartment.evaluate`-of-source + `-c`/`-lc` ses modes belong to test262-convergence; F1
  doctrine: shim widenings are high-risk, separately audited; BothAbort
  same-value/different-cost should graduate under the result bar (test262-convergence);
  dual-run runner must survive an ORACLE crash as a named class (verify when convenient);
  engine items still open: sort/toSorted/from/of residuals (holey/frozen receivers + result
  coercion remain named skips), string residuals; `XS_CODE_DELETE_PROPERTY_AT` computed
  delete; `set_property_at` integer-index frontier LANDED (stage-10m child 0, `8b9c050825` — the
  BINDING integer-first own-key-order clause landed for keys/gOPN/for-in/JSON.stringify; NEW side
  table `SideTable::ObjectIndices` Pending, VARIANT_COUNT 36; verification owed) — remaining
  frontiers: integer-index `in`/`hasOwnProperty`/gOPD/`delete`, integer-index accessors, index keys
  into entries/values/Reflect.ownKeys/spread/assign/defineProperties (all honest-skip today); frozen-exotic integrity CLOSED for the freeze-ordinary
  kinds incl. F1(s34)'s paths, harden-of-Array/RegExp traversal, array length/index gopd +
  ownKeys frozen flags — still open: TypedArray freeze (spec-throws when non-empty), Proxy
  integrity traps, `seal`/`isSealed` on exotics; AT-key `re["lastIndex"]=N` misses the RegExp
  side table even non-frozen (named in the stage-10m child-0 spec); wrapper reads after freeze
  are pre-existing read-side skips; double-metering on native `.call`/`.apply`/bound-of-native
  trampolines (advisory, result-exact); u16 canonical symbol-space ceiling in long-lived
  persistent realms (~65535 names, append-only — theoretical; revisit at parity closure);
  complete function `Reflect.ownKeys` (length/name/prototype prepend) — GRADUATED by the F1(s43)
  fix (verification owed); bound-of-bound self-names at CALL; primitive-`this` boxing on
  `.call`/`.apply`; native CONSTRUCTOR in callback position (named skip, r8);
  `Reflect.getOwnPropertyDescriptor` on an accessor property self-names (the Object form
  works); TypedArray-INSTANCE `getOwnPropertyDescriptor` self-names;
  `JSON.stringify:interned-key` honest skip (s41-observed, s42-confirmed over class
  prototypes); `%TypedArray%.prototype.subarray` BigInt-element views self-name; closures over
  a prior turn's top-level `var` do not survive turns BY DESIGN (realm idiom
  `globalThis.X = …`); `super()` construction + derived-this-TDZ is a named self-alarming
  remainder (s42 observed even an EMPTY `class B extends A{}` instantiation skips on it; the
  two §3 skips fail the day it lands; 18 class-construction skips hang off it); private fields
  `#x` (1049), `async_generator_function` (933), compiler negatives (595); Proxy remainders
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
  `endor-262 --test boot_bundle_gate`); (s34) cite forbid as anchored roots + oracle exempt;
  (s36/s39/s40/s41/s42/s43) engine-workspace and ROOT-lib counts are BINARY counts at the
  measured tip — they grow with each gap round (923 / 73 `test result:` lines at `1481757f7f`;
  111-with-real-bundles ROOT); (s36) the press-found C-XS `indexOf_aux` unparenthesized-macro
  artifact (1 raw per matched lead byte) is transliterated bit-exactly — do not "fix" it;
  (s39/s40/s41/s42/s43) INDEPENDENT verification means reconstructing probes from the findings
  RECORD plus fresh variants the fixer has never seen; (s41/s42/s43) attribute a new finding by
  RE-RUNNING the minimal probe at the pre-stage anchor before deciding accept-vs-defer —
  pre-existing findings do not block a stage acceptance; (s42) a probe whose harness shape adds
  helper calls can MASK the defect class — when a probe throws unexpectedly, minimize it; (s43)
  a probe surface can be MASKED by a named frontier skip (integer object-literal keys compile
  through `set_property_at`, so even `Object.keys` ordering is unobservable there) — record the
  masked question as a BINDING clause on the frontier's future fixer rather than calling it
  covered.** s19 tooling: prebuilt binaries WITHOUT `--`; module-corpora is a LIB test;
  compile-diff no-arg = the curated 1909 corpora + SYMB (there is no `--symb` flag). s20:
  `post-job.sh`/`post-plan.sh` take a body FILE path. s21–s43 notes: enumeration scripts
  `/home/kris/garden2/tmp/s34-enum.sh` (endolin-garden2) and `/home/kris/garden/tmp/s31-enum.sh`
  (endolin-garden); `$HOME` inside the container is per-host — mkdir `$HOME/tmp` before
  redirecting (`$HOME` IS the garden root); the worktree helper does NOT seed
  `rust/engine/target/` (nor the ROOT `target/`) — `cp -al` from a same-commit-or-near sibling
  (the s43 supervisor worktree `project-wt-port-xs-to-rust-memory-safe-engine-s43-5cd7f36a` at
  `1481757f7f` on endolin-garden2 has fully built caches: engine target, ROOT target, oracle at
  the pin, real bundles; the stage10l-reflection-fixer worktree
  `…-xs2rust-endor-stage10l-reflection-fixer-5cd7f36a` is a same-tip sibling there too; the s42
  worktree `…-s42-5cd7f36a` at `c34ffd9012` survives on endolin-garden), `rmdir` an empty
  `c/moddable` first, then apply the fresh-clean rule; confirm tip sha + clean status before
  trusting a seeded cache; the ROOT `endo` build needs the generated JS bundles — REAL bundles
  seed from the s43/s42 worktrees' `rust/endo/xsnap/src/*.js` or
  `/home/kris/garden/tmp/s9r/rust/endo/xsnap/src/` on endolin-garden; never commit bundles; the
  hourly press can REBASE the branch between sessions (2026-07-20T02:33Z) and can LAND items
  when a halt leaves the branch unowned (read the latest `xs2rust-endor-press-*` tadas before
  re-measuring; message an in-flight press to defer if one is live when you claim); the
  short-path C-XS clone `~/tmp/s8cxs` exists on BOTH hosts; the short-path daemon env
  `/home/kris/garden/tmp/s9r` (endolin-garden) is the proven LIVE env, `/home/kris/garden2/tmp/
  s10e` (endolin-garden2) is the sweep env — the LIVE round trip is currently green ONLY on s9r
  (the s10e stall is stage-10m child 2's question); sweep artifacts: `~/tmp/s10f-results/` +
  `~/tmp/s37-results/` + `~/tmp/s10i-results/` + `~/tmp/s41-results/` +
  `/home/kris/garden2/tmp/s10k-results/` + `/home/kris/garden2/tmp/s10l-results/` +
  `~/tmp/s43-results/` (endolin-garden2), `~/tmp/s10h-results/` + `~/tmp/s39-results/` +
  `~/tmp/s40-results/` + `~/tmp/s10j-results/` + `~/tmp/s42-results/` +
  `/home/kris/garden/tmp/s10l-live/` (endolin-garden); `$HOME/tmp/s10n-results/` +
  `$HOME/tmp/s10n-diagnosis/` are the stage10n children's homes (`$HOME/tmp/s10m-*` should be empty —
  the 10m diagnosis died workless); the three environment-artifact
  classes for mass failures: AF_UNIX sun_path overflow (real short path only), uniform
  provisioning-race asserts, stale seeded `target/`; channel.test.js can complete clean in a
  900s window; ava's TAP reporter crashes in `dumpError` on a timed-out test — use the default
  reporter for timeout truth; the shared `journal/` worktree can be left with stale unmerged
  index entries by a crashed peer — resolve those paths to HEAD and re-pull rather than merging.
- **C-XS `test:rust` baselines:** serial authoritative anchor **804/26/65** (+110 pending from
  the sandbox-unrunnable endo.test.js), classes: git-backend 8, error-trace worker-assertions
  5, content-store-gc 9, endo.test.js 3, shell /tmp-noexec 1. **Bounded-serial 52-file
  same-harness baseline (the direct comparison table): C-XS 530/19/20/0 vs Rust
  fail=15/skip=20/pending=6 on s10e (the sweep-side pin; the LIVE s9r drive is 7/7 —
  fail=14-vs-15 is default-reporter accounting of the timed-out error-trace file), classes
  stable across stages 9, 10, the 10f/10h/10i/10j/10k remeasures, and the 10l remeasure at
  `1481757f7f` (TSV byte-identical to s10i).** Concurrent (artifact-classified, NOT an anchor):
  646/294/65.
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
  surface to the maintainer with evidence. s44 assessed NOT tripped — the stage-10m halt was an opus API outage (not a program defect):
  children 0/1 landed green with the binding key-order clause and the F1(s43) silent-wrong-completion
  class closed at child-cited bars, the re-cut is dispatched, and the prior s43 basis stands (s43 — stage 10l completed 3/3
  cleanly with the binding LIVE pin MOVED (all 6 error-trace tests flipped, genuine frames,
  deterministic twice on the proven env), all bars reproduced green from a fresh checkout, both
  s42 findings verified closed against a 38-probe fresh-variant matrix, the one new finding is
  pre-existing with a doctrine-compliant fixer dispatched, and the single open question (the
  s10e host-gating) has a localized evidence trail and a dedicated diagnosis child).
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
   1–10, 10e–10l done and ACCEPTED; the LIVE error-trace pin MOVED on the proven env; stage-10m
   children 0/1 LANDED (verification owed); the stage10n chain (s10e diagnosis re-cut → remeasure) is
   dispatched — your recovery/review and the combined stage-10m/10n acceptance decision. Remaining
   after it: parity closure (design row 8), and ecosystem validation (row 9).**
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
  gardener: 18
  worker_kind: gardener
  claimed_at: 2026-07-20T06:21:08Z

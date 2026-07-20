---
gate: blocked
blocked_on: xs2rust-endor-build-stage10l
priority: normal
posted_by: producer
posted_at: 2026-07-20T03:07:11Z
---

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
(2026-07-19: stage 10h 2/2 — `hostGetDaemonHandle` bound, remeasure
fail=14/skip=20/1-hang; ALL bars reproduced green from fresh checkout; independent F1/F2(s37)
probe verification: F2 closed, F1's literal-accessor shape REFUTED → **finding F1(s39)**,
issuecomment-5015383357; dispatched the stage10i chain), `-s40` (2026-07-19: stage 10i 3/3 —
accessor fixer + for_of iterator-as-iterable → **the worker bundle boots the ENTIRE SES+@endo
graph, binding gate GREEN**; F1(s39) VERIFIED CLOSED 4/4+16/16; **STAGE-10e–10i ACCEPTANCE
issuecomment-5015638801**; findings F1(s40) class-method DONT_ENUM + F2(s40) inferred `.name`;
dispatched the stage10j chain), `-s41` (2026-07-19: stage 10j 3/3 — F1/F2(s40) flag fixes,
`%TypedArray%.prototype.subarray` closed so the real `handleCommand` decodes a full CBOR
envelope, remeasure TSV-identical; ALL bars reproduced from fresh checkout; F1/F2(s40)
VERIFIED CLOSED; **STAGE-10j ACCEPTANCE issuecomment-5015969926**; new finding F1(s41)
accessor→data method-redefine stale getter; dispatched the stage10k chain), and **`-s42`
(2026-07-20, this job's predecessor):**

- **Stage 10k COMPLETED 3/3 (serial):** (0) accessor-redefine fixer — F1(s41) fixed by a scoped
  flag-mask in `instance_put`'s found branch (the `fxOrdinaryDefineOwnProperty`
  data-over-accessor transition, `c7ccf5716` post-rebase), 10 dual-run tests, the
  stale-accessor-redefine wrong-completion set EMPTY (remaining accessor→data divergences are the
  pre-existing orthogonal honest skips `defineProperty:redefine` + `define-accessor-at-index`);
  (1) dispatch child — bound `trace` (`b32b2ffd7`: the `fx_trace`/`fxReport` transliteration,
  `host_trace_fns` + `host_trace_outbox` riding the `HostReplyChannel` side-table row SAME-DAY,
  SnapshotExcluded/GC-invisible, VARIANT_COUNT still 35) and transliterated `dub_at` bit-exact
  (`c34ffd9012`, verified against pinned `xsRun.c` line 1604) → **the CapTP dispatch gate is
  GREEN**: the real `handleCommand` runs a real CBOR deliver to completion. The child FOUND AND
  FIXED a silent-ack masking defect: the real handler returns `undefined` and replies out-of-band
  via `hostSendRawFrame`, so `dispatch_deliver` now surfaces DRAINED HOST FRAMES as the real
  replies (no synthetic `"undefined"` ack; fold-ack only on the two degraded paths). The LIVE
  round trip was honestly deferred per HARD-STOP (gate-GREEN checkpoint). New systemic +1
  computed-method-call computron advisory recorded (context-dependent, non-scaling — not chased);
  `set_property_at` named as the next runtime-opcode frontier; (2) remeasure at the tip:
  **pass=760/fail=15/skip=20/pending=6, TSV byte-identical to the s10i baseline**, all 6
  error-trace pinned tests individually named, pin correctly HELD (contingent on the deferred
  live round trip), no new class, C-XS 530/19/20/0 anchor stands.
- **The hourly press REBASED the branch onto `llm` at 2026-07-20T02:33Z** — now **ahead 440 /
  behind 0** (was 437/10). s42 verified the rebase content-preserving (old tip `3b18435c4` vs new
  tip `c34ffd9012` differs only by llm's own design docs; `rust/` identical). The
  rebase-if-conflicting hand-off precondition is currently satisfied.
- **s42 reproduced ALL bars green from a fresh checkout at `c34ffd9012`** (fresh-clean rule +
  oracle from the clean sha-verified pin): engine **910/0 EXIT=0 (72 `test result:` lines**, grew
  from 894/70 by exactly the two children's +16 tests), compile-diff **1909/1909 + SYMB
  1909/1909** EXIT=0, boot gate **30/0**, ROOT lib **111/0** real bundles with BOTH markers GREEN
  (the dispatch marker now a GREEN assertion) plus `real_chain_dispatches_a_command_to_a_handler_
  and_replies` GREEN, forbid roots intact, VARIANT_COUNT 35, 0 non-oracle warnings, no new
  `unsafe`. Range review (3 Rust-only commits) sound: the accessor-clear is correctly scoped (the
  [[Set]] paths intercept via `accessor_in_chain` first), `dub_at` bit-exact vs the pinned C,
  `trace` follows the established host-fn pattern with the ledger row recorded same-day.
- **s42 ran the owed INDEPENDENT F1(s41) verification** — record shapes + 16 fresh variants the
  fixer never saw (Reflect.get-after-redefine, in/hasOwnProperty, triple redefines both orders,
  Object.entries, .call, computed + Symbol keys, static class, async typeof, for-in,
  get+set→method live-setter check, freeze-then-read): **F1(s41) VERIFIED CLOSED** — 34-probe
  matrix, 0 wrong completions, all non-agreements honest named skips on known ledger rows.
  F1/F2(s40) + F1(s39) + s37 families re-probed varied: no regression. Probe artifacts
  `~/tmp/s42-results/{s42_probe.rs,s42_diag.rs,probe.log,diag-tip.log,diag-anchor.log}`
  (endolin-garden).
- **STAGE-10k ACCEPTANCE posted: issuecomment-5018362782.**
- **New findings (both probe-attributed PRE-EXISTING at anchor `c9bafd202` — tip AND anchor
  logs identical; did not block acceptance; fixer dispatched as stage-10l child 0):**
  **F1(s42):** `Object.getOwnPropertyNames` is UNBOUND in the bare realm (`typeof` →
  `"undefined"`; calls wrong-throw `"call: not a function"` — unnamed, not a self-skip).
  **F2(s42):** `Reflect.get` over a live ACCESSOR property returns the internal HOLDER instance
  instead of invoking the getter (`typeof Reflect.get(t,'a')` → `"object"` vs oracle `"number"` —
  wrong completion + holder encapsulation leak; the `''+` shape self-names via
  `add:toprimitive-no-primitive`; the data path is correct). F1-class doctrine applies.
- **Noted seam (not a defect):** the live-handler ack path drops a handler whose RENDERED return
  is the literal string `"undefined"` (unit-test-seam rendering ambiguity) — deserves a typed
  completion signal when the live protocol work lands.
- **s42 dispatched stage 10l** as serial-halt orchestration **`xs2rust-endor-build-stage10l`**,
  three opus children: (0) `xs2rust-endor-stage10l-reflection-fixer` — F1(s42) bind gOPN
  (oracle-exact key order, non-enumerables included, symbols excluded) + F2(s42) route
  Reflect.get through the accessor read path (holder-leak set must be EMPTY; 3-arg receiver form
  may honest-skip `reflect-get:receiver`), reproduce-first, push-per-item, BINDING
  no-boot-regression bars; (1) `xs2rust-endor-stage10l-live-round-trip` — THE LIVE daemon round
  trip on the proven env (`/home/kris/garden/tmp/s9r` endolin-garden, or the garden2 adaptation
  `/home/kris/garden2/tmp/s10e`), `ENDO_WORKER_BIN='<abs>/endor worker -e rust'`, drive the 6
  pinned error-trace tests live and report each by name (the pin is THE question), BINDING live
  silent-ack check (a completed command must flow a REAL frame), at most 2 new frontier items
  (bit-exact, push-per-item), HARD STOP ≥1200s; (2) `xs2rust-endor-stage10l-remeasure` —
  outage-hardened detached sweep + TSV resume, artifacts `$HOME/tmp/s10l-results/`, must name
  every error-trace test that flipped vs the anchor, 4 required answers.
- Bar conventions: engine-workspace and ROOT-lib counts are BINARY counts at the measured tip
  and GROW with each gap round — last measured engine **910/0 (72 `test result:` lines)** at
  `c34ffd9012`, ROOT endo lib **111** with real bundles, boot gate **30**, compile-diff
  **1909/1909 + SYMB**, forbid anchored roots + oracle exempt, VARIANT_COUNT **35**, oracle
  pin `23b4d6b0a65f…`. Cite the measured number at the measured tip.

You are parked `blocked_on: xs2rust-endor-build-stage10l` and will be promoted when the
orchestration reaches a terminal state (all three children tada, or a halt on child failure).
**FIRST:** sync your journal worktree (`git -C journal pull --ff-only origin journal2`; on
"multiple branches" fall back to fetch + `merge --ff-only FETCH_HEAD`; s42 note: if the pull dies
on stale unmerged index entries from another job, resolve those paths to HEAD — `git reset` +
`git checkout HEAD --` them — then re-pull), read
`journal/jobs/tada/xs2rust-endor-build-stage10l.md` and every child tada
(`journal/jobs/tada/xs2rust-endor-stage10l-*.md`). If the orchestration halted, check
`git log --all -- jobs/` for reaper poisoning and classify before re-dispatching (outage vs
sizing vs spec defect — zero-push poison is SIZING; poison AFTER pushes is
sizing-with-partial-completion: re-cut minus the landed items; repeated transient-handler-kill
poison with 0 deadline overruns is OUTAGE — re-cut same shape; a poisoned plan entry left by
the reaper must be retired when superseded). The live-round-trip child may legitimately tada as a
DEGRADED gap round or an honest checkpoint short of all 6 flips (both honest success); the
remeasure may legitimately SKIP only if the tip regressed to an already-measured sha. Read the
latest `xs2rust-endor-press-*` tadas before re-measuring — the press advances (and now REBASES)
the branch between sessions and can LAND items when a halt leaves the branch unowned.

**Your job (s43):**

1. **If stage 10l halted:** classify, re-dispatch the remainder (stage10m, same discipline —
   precondition-gate + HARD-STOP + outage-hardened-remeasure clauses; carry the live-round-trip
   goal as the resume point), park s44 blocked on it carrying this spec.
2. **If stage 10l completed:** **verify the F1/F2(s42) fixes INDEPENDENTLY** — reconstruct probes
   from the findings record (gOPN typeof/call/key-order; Reflect.get over accessor: typeof shape
   AND value shape) at the real remote tip, PLUS fresh variants of your own devising (the fixer
   has seen the s42 probes: vary — e.g. gOPN over arrays/frozen objects/redefined-accessor
   objects, gOPN.length, Reflect.get proto-chain accessors, Reflect.get 3-arg receiver behavior,
   Reflect.get over set-only, interaction with `harden`); require agreement or honest named
   skips. Re-run varied F1(s41) + F1/F2(s40) + s37 probe families (no regression; the s42 matrix
   is `~/tmp/s42-results/s42_probe.rs` on endolin-garden — vary it, don't just re-run it).
   **If the live-round-trip child claims flipped error-trace tests: reproduce at least one flip
   independently in the proven env** (the live silent-ack check is binding — a completed command
   must flow its REAL frame), and confirm the remeasure's error-trace answer accounts for all 6
   pinned tests. Then review the stage-10l range (fresh checkout at the real remote tip, current
   bars vs the anchors, substantive diff review — gOPN's key-order and exotic-receiver surface,
   Reflect.get's routing through the accessor read path and the holder-leak sweep, and any live
   frontier items landed by child 1 deserve particular scrutiny). On green: **post the stage-10l
   ACCEPTANCE** on PR #600 with measured numbers. On new findings: post them, dispatch a fixer,
   park s44.
3. **Decide the next stage:** if the maintainer's binding finish line (all `test:rust` daemon
   tests passing on the Rust engine modulo the expected-divergence ledger — the error-trace
   6-pending pin must MOVE via the live round trip — plus test262 parity per the amended
   accuracy-over-parity bar) is MET — proceed to the hand-off protocol (rebase/weave if
   CONFLICTING vs `llm` (s42: ahead 440 / behind 0 after the press rebase), un-draft PR #600,
   bulletin entry + maintainer-inbox note with PR URL and status summary; the single point a
   human enters the loop). If NOT met: dispatch the next stage from the live tree (candidates:
   the error-trace pin remainder if the round trip landed partially, `set_property_at`
   (computed-key assignment — the named next runtime-opcode frontier), F1-class full-fidelity
   graduation (accessor-setter re-entry + catchable TypeError with bit-exact metering;
   Object.keys-over-accessor + assign-onto-accessor skip graduation; `defineProperty:redefine` +
   `define-accessor-at-index`), remaining Proxy MOP traps, `super()` construction, parity
   closure design row 8, ecosystem validation row 9) as a serial-halt orchestration, and park
   s44 blocked on it carrying this spec with updated state.

Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT
  until the finish line.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5,
  stage 6 (Snapshots), stage 7, stage 8, stage 9 (incl. 9b/9c), stage 10 (incl. 10b/10c/
  press-r8 + the 10d F1 fix), stages 10e/10f/10g/10h/10i, stage 10j, AND stage 10k: done and
  ACCEPTED** (s7: issuecomment-4888517639; s8: issuecomment-4888883354; s11:
  issuecomment-4897783472; s19 stage-5: issuecomment-4996709674; s21 stage-6:
  issuecomment-4997552045; s23 stage-7: issuecomment-5002369752; s28 stage-8:
  issuecomment-5009970041; s31 stage-9: issuecomment-5011343934; s35 stage-10:
  issuecomment-5013346972; s40 stages 10e–10i: issuecomment-5015638801; s41 stage-10j:
  issuecomment-5015969926; **s42 stage-10k: issuecomment-5018362782**). **The stage10l chain
  (F1/F2(s42) reflection fixer → LIVE daemon round trip → outage-hardened remeasure) is
  dispatched — your job is its recovery/review and the stage-10l acceptance decision.**
  Remaining after it: whatever the live round trip leaves of the error-trace pin, parity closure
  (design row 8), ecosystem validation (row 9).
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
  `host_trace_fns`/`host_trace_outbox`), stage 10b's `retained_code`
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
  `sort:receiver-mutated-during-sort`) — s39+s40+s41+s42-verified; their full-fidelity
  graduation (re-entering the setter, the oracle's catchable TypeError bit-exact) is a named
  follow-up; **F1(s39), F1(s40)/F2(s40), AND F1(s41) all VERIFIED CLOSED** (s42: 34-probe
  fresh-variant matrix, 0 wrong completions); the accessor-define path routes through the
  holder-instance model, and the accessor→data redefine now clears the accessor markers in
  `instance_put` (s42-verified scoped: [[Set]] paths intercept via `accessor_in_chain` first);
  `Object.keys` over an enumerable accessor + `Object.assign` onto an accessor target
  honest-skip — graduation is a named follow-up; the s34/s37/s39/s40/s41 F1 bug CLASS is binding
  review doctrine: any integrity/flag enablement, any NEW write/mutation path onto
  guest-reachable targets, AND any DEFINITION path must preserve/honor property flags end to end
  AND leave the slot coherent — **s42 extends the class to REFLECTIVE READ paths: a read must
  invoke the accessor, never leak the holder instance (F2(s42))**; **F1(s42) (OPEN, fixer
  dispatched): gOPN unbound; F2(s42) (OPEN, fixer dispatched): Reflect.get holder leak — the
  stage10l fixer's holder-leak sweep must be reviewed at s43 (is the leak set EMPTY across
  reflective reads?)**; the s41 advisory ±1 family (copy-skip −1, ≥2-method for-in +1,
  post-redefine reflection +1, async-define −1, computed-key gopd +1) plus the s42 systemic
  computed-method-call +1 (context-dependent, non-scaling) are recorded telemetry — do not let a
  fixer silently regress RESULTS chasing them; Symbol-keyed method names stay anonymous —
  deliberate honest skip; cross-crank persistent-heap continuity fixtures — extend as new state
  becomes cross-crank-real; accessor properties use a holder-instance model (no side table;
  snapshot round-trip of an accessor property not explicitly tested — hardening follow-up);
  primitive-receiver accessors + non-array Map/Set iterables self-name; the for_of
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
  delete; `set_property_at` computed-key assignment (named s10k frontier); frozen-exotic
  integrity CLOSED for the freeze-ordinary kinds incl. F1(s34)'s paths, harden-of-Array/RegExp
  traversal, array length/index gopd + ownKeys frozen flags — still open: TypedArray freeze
  (spec-throws when non-empty), Proxy integrity traps, `seal`/`isSealed` on exotics; AT-key
  `re["lastIndex"]=N` misses the RegExp side table even non-frozen (fixer follow-up note);
  wrapper reads after freeze are pre-existing read-side skips; double-metering on native
  `.call`/`.apply`/bound-of-native trampolines (advisory, result-exact); u16 canonical
  symbol-space ceiling in long-lived persistent realms (~65535 names, append-only —
  theoretical; revisit at parity closure); complete function `Reflect.ownKeys`
  (length/name/prototype prepend); bound-of-bound self-names at CALL; primitive-`this` boxing
  on `.call`/`.apply`; native CONSTRUCTOR in callback position (named skip, r8);
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
  (s36/s39/s40/s41/s42) engine-workspace and ROOT-lib counts are BINARY counts at the measured
  tip — they grow with each gap round (910 / 72 `test result:` lines at `c34ffd9012`;
  111-with-real-bundles ROOT); (s36) the press-found C-XS `indexOf_aux` unparenthesized-macro
  artifact (1 raw per matched lead byte) is transliterated bit-exactly — do not "fix" it;
  (s39/s40/s41/s42) INDEPENDENT verification means reconstructing probes from the findings
  RECORD plus fresh variants the fixer has never seen; (s41/s42) attribute a new finding by
  RE-RUNNING the minimal probe at the pre-stage anchor before deciding accept-vs-defer —
  pre-existing findings do not block a stage acceptance; (s42) a probe whose harness shape adds
  helper calls can MASK the defect class — when a probe throws unexpectedly, minimize it (the
  gOPN "call: not a function" was a missing BINDING, not an array-method failure).** s19
  tooling: prebuilt binaries WITHOUT `--`; module-corpora is a LIB test; compile-diff no-arg =
  the curated 1909 corpora + SYMB (there is no `--symb` flag). s20: `post-job.sh`/`post-plan.sh`
  take a body FILE path. s21–s42 notes: enumeration scripts `/home/kris/garden2/tmp/s34-enum.sh`
  (endolin-garden2) and `/home/kris/garden/tmp/s31-enum.sh` (endolin-garden); `$HOME` inside
  the container is per-host — mkdir `$HOME/tmp` before redirecting (s42: `$HOME` IS the garden
  root — `~/tmp` = `/home/kris/garden/tmp`); the worktree helper does NOT seed
  `rust/engine/target/` (nor the ROOT `target/`) — `cp -al` from a same-commit-or-near sibling
  (the s42 supervisor worktree `project-wt-port-xs-to-rust-memory-safe-engine-s42-5cd7f36a` at
  `c34ffd9012` on endolin-garden has fully built caches: engine target, ROOT target, oracle at
  the pin, real bundles; the s41 worktree `…-s41-5cd7f36a` at `42e4fcdf8e` survives on
  endolin-garden2), `rmdir` an empty `c/moddable` first, then apply the fresh-clean rule;
  confirm tip sha + clean status before trusting a seeded cache; the ROOT `endo` build needs
  the generated JS bundles — REAL bundles seed from `/home/kris/garden/tmp/s9r/rust/endo/xsnap/
  src/` on endolin-garden or the s42/s41 worktrees' `rust/endo/xsnap/src/*.js`; never commit
  bundles; the hourly press can REBASE the branch between sessions (it did, 2026-07-20T02:33Z)
  and can LAND items when a halt leaves the branch unowned (read the latest
  `xs2rust-endor-press-*` tadas before re-measuring; s42 also messaged the in-flight press to
  defer — do the same if one is live when you claim); the short-path C-XS clone `~/tmp/s8cxs`
  exists on BOTH hosts; the short-path daemon env `/home/kris/garden/tmp/s9r` (endolin-garden)
  is the proven sweep env; sweep artifacts: `~/tmp/s10f-results/` + `~/tmp/s37-results/` +
  `~/tmp/s10i-results/` + `~/tmp/s41-results/` (endolin-garden2), `~/tmp/s10h-results/` +
  `~/tmp/s39-results/` + `~/tmp/s40-results/` + `~/tmp/s10j-results/` + `~/tmp/s42-results/`
  (endolin-garden), `/home/kris/garden2/tmp/s10k-results/` (endolin-garden2),
  `$HOME/tmp/s10l-results/` + `$HOME/tmp/s10l-live/` are the stage10l children's homes; the
  three environment-artifact classes for mass failures: AF_UNIX sun_path overflow (real short
  path only), uniform provisioning-race asserts, stale seeded `target/`; channel.test.js can
  complete clean in a 900s window; ava's TAP reporter crashes in `dumpError` on a timed-out
  test — use the default reporter for timeout truth; (s42) the shared `journal/` worktree can
  be left with stale unmerged index entries by a crashed peer — resolve those paths to HEAD and
  re-pull rather than merging.
- **C-XS `test:rust` baselines:** serial authoritative anchor **804/26/65** (+110 pending from
  the sandbox-unrunnable endo.test.js), classes: git-backend 8, error-trace worker-assertions
  5, content-store-gc 9, endo.test.js 3, shell /tmp-noexec 1. **Bounded-serial 52-file
  same-harness baseline (the direct comparison table): C-XS 530/19/20/0 vs Rust
  fail=15/skip=20/pending=6 (the error-trace pin; fail=14-vs-15 is default-reporter accounting
  of the timed-out error-trace file), classes stable across stages 9, 10, the 10f/10h/10i/10j
  remeasures, and the 10k remeasure at `3b18435c4` (TSV byte-identical to s10i).** Concurrent
  (artifact-classified, NOT an anchor): 646/294/65.
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
  surface to the maintainer with evidence. s42 assessed NOT tripped — stage 10k completed 3/3
  cleanly, all bars reproduced green from a fresh checkout, F1(s41) verified closed against a
  34-probe fresh-variant matrix, the CapTP dispatch gate is GREEN with the silent-ack defect
  found and fixed honestly, both new findings are pre-existing with doctrine-compliant fixes
  dispatched, and the LIVE round trip is directly ahead with a proven env recipe.
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
   1–10, 10e–10j, AND 10k done and ACCEPTED; the stage10l chain (F1/F2(s42) reflection fixer → LIVE
   daemon round trip → outage-hardened remeasure) is dispatched — your recovery/review and the stage-10l
   acceptance decision. Remaining after it: whatever the live round trip leaves of the error-trace pin,
   parity closure (design row 8), and ecosystem validation (row 9).**
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

---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-19T10:21:07Z -->

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
`xs2rust-endor-build-stage10c`, five children), `-s34` (stage-10c 5/5 + press r8; whole-stage-10
acceptance review, all measured bars green but review point F1 REFUTED — frozen arrays not
actually immutable; findings issuecomment-5012970220; dispatched stage 10d), `-s35`
(2026-07-18: stage-10d children 0–2 landed; s35 verified F1 independently, **STAGE-10
ACCEPTANCE issuecomment-5013346972**; retired the poisoned 10d plan entry; dispatched stage
10e), `-s36` (2026-07-19: stage-10e recovery — children 1+2 tada'd 5 verified frontier gaps
(the honest-success DEGRADED template for gated round-trip children set by its live-captp
child); remeasure child was a pure-outage halt; the press closed 3 more gaps solo (fill,
user-comparator `sort` `7f8686284f`, string-separator `split` `8eabbdefce` — surfacing the
C-XS `indexOf_aux` unparenthesized-macro artifact, transliterated bit-exactly, binding: never
"fix" it); dispatched stage 10f), `-s37` (2026-07-19: stage-10f COMPLETED 3/3 — worker-gaps
3 gaps to `4e3561013e`; live-captp DEGRADED-correctly closed the runtime-interned-string-key
enumeration boundary `408ef16683`; remeasure survived two reaper requeues, fail=14/skip=20/
6-pending+error-trace-hang EXACT anchor match at `408ef16683`, artifacts `~/tmp/s10f-results/`
on endolin-garden2; s37's whole-stage-10e/10f review reproduced ALL bars green from a fresh
checkout — engine 821/0 (61 binaries), compile-diff+SYMB 1909/1909, boot gate 30/0, ROOT lib
110/0 real bundles — but found and CONFIRMED by dual-run probe two wrong-completed-result
divergences: **F1(s37)** `NativeMethod::ObjectAssign` writes via `set_own_unmetered` silently
mutating frozen/non-writable targets and clobbering accessors, **F2(s37)** `sort` write-back
after a receiver-shrinking comparator completing `len=2` vs oracle `len=6`; probes
`~/tmp/s37-results/s37_probe.rs` (endolin-garden2, 5 scenarios); **stage-10e/10f DEFERRED on
F1/F2**, findings issuecomment-5014930807; dispatched stage 10g as serial-halt orchestration
`xs2rust-endor-build-stage10g`, four opus children), and **`-s38` (2026-07-19, this job's
predecessor):**

- **Stage 10g HALTED 2/4** (orchestration tada `orchestration-status: halted`): children 0+1
  tada'd; child 2 (live-captp-eval) claimed 08:43Z, deadline-overran (cycle 1), reaper-poisoned
  09:33Z; child 3 (remeasure) swept unrun. s38 classified the death
  **sizing-with-partial-completion** (one substantial push landed before the overrun) and
  retired the poisoned 10g live-captp plan entry.
  1. **findings-fixer (tada):** **F1 fixed `5e7929e70f`** — every per-key `Object.assign`
     write routed through the flag machinery `XS_CODE_SET_PROPERTY` models; an accessor in
     the chain or a rejected `[[Set]]` (non-writable own data / new key on non-extensible)
     self-names `Unsupported`; fresh writable-data path bit-exact. Doctrine sweep completed:
     enumerated every `set_own_unmetered`/`set_own_flagged_unmetered` caller — all others are
     fresh/host-controlled targets; **`Object.assign` was the sole guest-reachable gap.**
     **F2 fixed `402b3f7b0e`** — `sort` snapshots receiver length + present-element density
     before the comparator loop (snapshot reads unmetered — unmutated path bit-exact);
     any change at write-back self-names `Unsupported("sort:receiver-mutated-during-sort")`.
     REPRODUCE-FIRST honored: all four scenarios wrong-completed pre-fix, flip to honest
     named skips post-fix. Bars at each push: engine 824/0 then 825/0 (61 binaries),
     compile-diff+SYMB 1909/1909, boot gate 30/0, ROOT lib 110/0 real bundles.
     **s38/s39 still owes the INDEPENDENT probe verification** (the fixer reconstructed the
     scenarios; the parked supervisor re-runs the 5 probes from
     `~/tmp/s37-results/s37_probe.rs` at the real tip).
  2. **worker-gaps (tada):** 3 gaps push-per-gap — `c5a1c0532` (array `length` gopd,
     bit-exact 72c full/86 frozen), `3f522efc1` (`Reflect.ownKeys` over arrays, XS
     `fxArrayOwnKeys` order, result-exact per the ledgered ordinary-path remainder),
     `f95d7bcc3` (array index gopd, bit-exact 67/35-absent/86-frozen). All new paths reads —
     no write-path doctrine exposure. Bars at tip: engine **842/0 (64 binaries)**, rest
     standard. Marker frontier promoted to `Throw("call: not a function")`.
  3. **live-captp-eval (poisoned AFTER landing `12d997c9fecc`):** the END value-stack reset
     fix (XS `mxStack = mxFrameEnd`): a callee `return`ing from inside a `switch` left the
     discriminant on the value stack; endor's `leave_call` never truncated, residue
     accumulated and overwrote a later frame's [THIS, FUNCTION] geometry — that WAS the
     `Throw("call: not a function")` frontier (a corruption artifact, NOT a missing binding;
     do not chase it). Fix records each callee frame's entry stack length and truncates at
     every END variant — metering-neutral, corpus + compile-diff unchanged per the commit.
     **With returns clean the worker bundle boots through the ENTIRE SES + @endo graph and
     registers a real `globalThis.handleCommand`; the boot frontier advanced to the first
     missing HOST global, `hostGetDaemonHandle`** (a host-integration binding the runtime
     injects alongside `hostSendRawFrame` — no longer an engine op). `dispatch_deliver`
     gates real-handler routing on full boot completion (`halted_at.is_none() &&
     handle_command_registered`); a half-booted worker still folds to an ack.
- **s38 dispatched stage 10h** as serial-halt orchestration **`xs2rust-endor-build-stage10h`**,
  two opus children: (0) `xs2rust-endor-stage10h-live-captp-eval` (bind `hostGetDaemonHandle`
  mirroring `hostSendRawFrame`'s injection, push-per-item, at most one more frontier item;
  then the BINDING ~300s gate `halted_at == None && handle_command_registered == true`; the
  round trip ONLY if the gate is GREEN and ≥1200s remain, else STOP at the pushed gate-GREEN
  checkpoint — HARD STOP discipline, four predecessors died at deadline), (1)
  `xs2rust-endor-stage10h-remeasure` (measurement-only outage-hardened detached sweep + TSV
  resume, artifacts `~/tmp/s10h-results/`; tip at dispatch `12d997c9fecc` is six engine
  commits past the measured anchor `408ef16683`, so it runs; report explicitly whether the
  error-trace 6-pending-hang pin MOVED — the END fix + handleCommand registration may change
  worker behavior materially).
- Bar conventions: engine-workspace and ROOT-lib counts are BINARY counts at the measured tip
  and GROW with each gap round — last measured engine **842/0 (64 binaries)** at
  `f95d7bcc32`, ROOT endo lib **110** with real bundles, boot gate **30**, compile-diff
  **1909/1909 + SYMB**, forbid 7 anchored roots + oracle exempt, VARIANT_COUNT **35**, oracle
  pin `23b4d6b0a65f…`. Cite the measured number at the measured tip.

You are parked `blocked_on: xs2rust-endor-build-stage10h` and will be promoted when the
orchestration reaches a terminal state (both children tada, or a halt on child failure).
**FIRST:** sync your journal worktree (`git -C journal pull --ff-only origin journal2`; on
"multiple branches" fall back to fetch + `merge --ff-only FETCH_HEAD`), read
`journal/jobs/tada/xs2rust-endor-build-stage10h.md` and every child tada
(`journal/jobs/tada/xs2rust-endor-stage10h-*.md`). If the orchestration halted, check
`git log --all -- jobs/` for reaper poisoning and classify before re-dispatching (outage vs
sizing vs spec defect — zero-push poison is SIZING; poison AFTER pushes is
sizing-with-partial-completion: re-cut minus the landed items; repeated transient-handler-kill
poison with 0 deadline overruns is OUTAGE — re-cut same shape; a poisoned plan entry left by
the reaper must be retired when superseded). The live-captp child may legitimately tada as a
DEGRADED gap round or a gate-GREEN checkpoint short of the round trip (both are honest
success per its body); the remeasure may legitimately SKIP only if the tip somehow regressed
to an already-measured sha. Read the latest `xs2rust-endor-press-*` tadas before re-measuring
— the press advances the branch between sessions and can LAND items when a halt leaves the
branch unowned.

**Your job (s39):**

1. **If stage 10h halted:** classify, re-dispatch the remainder (stage10i, same discipline —
   the precondition-gate + HARD-STOP + outage-hardened-remeasure clauses; carry the frontier
   marker as the resume point), park s40 blocked on it carrying this spec.
2. **If stage 10h completed:** **verify the F1(s37)/F2(s37) fixes INDEPENDENTLY** — re-run
   the five probe scenarios from `~/tmp/s37-results/s37_probe.rs` (endolin-garden2; or
   equivalents) at the real remote tip and require agreement or honest named skips;
   sweep-check that no other `set_own_unmetered`/`set_own_flagged_unmetered` caller writes
   onto a guest-reachable flagged/accessor target. Then review the stage-10g+10h range
   (independent reproduction from a fresh checkout at the real remote tip, the current bars
   incl. the daemon-sweep result vs the anchors with the expected-divergence ledger,
   substantive diff review under the s34+s37 F1 doctrine — the END stack-reset fix
   `12d997c9fecc` deserves particular scrutiny: correct truncation semantics for every END
   variant incl. generators/async resumption, and that metering-neutrality claim). On green:
   **post the stage-10e/10f/10g/10h ACCEPTANCE** on PR #600 with measured numbers (10e/10f
   are DEFERRED pending exactly the F1/F2 fixes — accept them together). On new findings:
   post them, dispatch a fixer, park s40.
3. **Decide the next stage:** if the maintainer's binding finish line (all `test:rust` daemon
   tests passing on the Rust engine modulo the expected-divergence ledger — note the
   error-trace 6-pending-hang pin must MOVE via a live round trip — plus test262 parity per
   the amended accuracy-over-parity bar) is MET — proceed to the hand-off protocol
   (rebase/weave if CONFLICTING vs `llm`, un-draft PR #600, bulletin entry +
   maintainer-inbox note with PR URL and status summary; the single point a human enters the
   loop). If NOT met: dispatch the next stage from the live tree (candidates: the live round
   trip / remaining host bindings as stage10i, the error-trace hang once the round trip is
   live, F1/F2 full-fidelity graduation (accessor-setter re-entry + catchable TypeError with
   bit-exact metering), remaining Proxy MOP traps, `super()` construction, parity closure
   design row 8, ecosystem validation row 9) as a serial-halt orchestration, and park s40
   blocked on it carrying this spec with updated state.

Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT
  until the finish line.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5,
  stage 6 (Snapshots), stage 7, stage 8, stage 9 (incl. 9b/9c), AND stage 10 (incl.
  10b/10c/press-r8 + the 10d F1 fix): done and ACCEPTED** (s7: issuecomment-4888517639; s8:
  issuecomment-4888883354; s11: issuecomment-4897783472; s19 stage-5:
  issuecomment-4996709674; s21 stage-6: issuecomment-4997552045; s23 stage-7:
  issuecomment-5002369752; s28 stage-8: issuecomment-5009970041; s31 stage-9:
  issuecomment-5011343934; s35 stage-10: issuecomment-5013346972). **Stage 10e/10f: bars
  green, DEFERRED on findings F1(s37)/F2(s37) (issuecomment-5014930807); the fixes LANDED in
  stage 10g (`5e7929e70f`/`402b3f7b0e`, fixer-verified reproduce-first) but the supervisor's
  INDEPENDENT verification is still owed; stage 10g itself halted after also landing the END
  stack-reset fix `12d997c9fecc` (worker bundle now registers handleCommand; frontier is the
  `hostGetDaemonHandle` host binding); the stage10h chain (host binding + gated round trip →
  outage-hardened re-measure) is dispatched — your job is its recovery/review and the
  10e/10f/10g/10h acceptance decision.** Remaining after it: the live round trip if not yet
  achieved, the error-trace hang pin, parity closure (design row 8), ecosystem validation
  (row 9).
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
  inter-crank contract; any NEW side table must be ledgered the day it lands;
  `runtime_key_names` (s37): GC-invisible (no slot refs), runtime-only like `symbol_ids` —
  its live-state-across-suspend treatment is a named Pending-class follow-up (a serialized
  property slot keyed by a runtime-interned id needs the name map, or a stable re-mint order,
  across suspend); (s38) the END value-stack reset (`CallerState` entry-stack-length
  truncation at every END variant) is a metering-neutral correctness restoration — verify the
  truncation semantics against generator/async suspension frames at review;
  `dispatch_deliver` gates real-handler routing on full boot completion — a half-booted
  worker folds to an ack (verify no silent-ack masking once the round trip is live);
  F1(s37)/F2(s37) are CLOSED as honest named skips (`Object.assign` accessor/rejected-write,
  `sort:receiver-mutated-during-sort`); their full-fidelity graduation (re-entering the
  setter, constructing the oracle's catchable TypeError bit-exactly) is a named follow-up;
  cross-crank persistent-heap continuity fixtures — extend as new state
  becomes cross-crank-real; accessor properties use a holder-instance model (no side table;
  snapshot round-trip of an accessor property not explicitly tested — hardening follow-up);
  primitive-receiver accessors + non-array Map/Set iterables self-name; FUNCTION_* analytic
  decomposition (advisory); sub-computron construct-`this` + object-literal drifts (advisory);
  generator saved-slice metering residual (advisory); String.raw computron gap (advisory);
  native→JS host-frame + accessor-dispatch metering residuals (advisory — result-exact); the
  stage3-arrays/265 flatMap allocation +1 (documented result-gated case); module-goal oracle
  seam: COMPILE-only module entry landed — runtime module linking/evaluation + guest
  `Compartment.evaluate`-of-source (`compartment:evaluate-source-compile`) + `-c`/`-lc` ses
  modes belong to test262-convergence; F1 doctrine: shim widenings are high-risk, separately
  audited; BothAbort same-value/different-cost should graduate under the result bar
  (test262-convergence); dual-run runner must survive an ORACLE crash as a named class
  (verify when convenient); engine items still open: sort/toSorted/from/of residuals
  (user-comparator sort landed `7f8686284f`; holey/frozen receivers + result coercion remain
  named skips), string residuals; `XS_CODE_DELETE_PROPERTY_AT` computed delete; frozen-exotic
  integrity CLOSED for the freeze-ordinary kinds incl. F1's length/mutator/RegExp-lastIndex
  paths (s35-verified), harden-of-Array/RegExp traversal (s37-reviewed), array length/index
  gopd + ownKeys frozen flags (s38 worker-gaps) — still open: TypedArray freeze (spec-throws
  when non-empty), Proxy integrity traps, `seal`/`isSealed` on exotics; AT-key
  `re["lastIndex"]=N` misses the RegExp side table even non-frozen (fixer follow-up note);
  wrapper reads after freeze are pre-existing read-side skips; **the F1 bug CLASS is binding
  review doctrine (s34; re-validated by s37's Object.assign finding): any integrity/flag
  enablement on an exotic kind — and any NEW write/mutation path onto guest-reachable
  targets — must enumerate EVERY side-table mutation path / honor the property flags, never
  route through `set_own_unmetered` onto a target that can carry flagged or accessor keys**
  (s38: the fixer's caller sweep found `Object.assign` was the sole guest-reachable gap —
  future new callers inherit the doctrine); double-metering on native `.call`/`.apply`/
  bound-of-native trampolines (advisory, result-exact); u16 canonical symbol-space ceiling in
  long-lived persistent realms (~65535 names, append-only — theoretical; revisit at parity
  closure); complete function `Reflect.ownKeys` (length/name/prototype prepend);
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
  (s18) a workspace-green claim requires running the workspace at the claimed tip; (s27/s28)
  an acceptance-grade workspace run requires `cargo clean -p endor-compile -p endor-vm -p
  endor-oracle` AND an oracle built from a clean sha-verified moddable checkout at the
  declared pin `23b4d6b0a6`; (s34) the boot-gate count is the TEST BINARY's count (30 =
  `endor-262 --test boot_bundle_gate`); (s34) cite forbid as 7 anchored roots + oracle
  exempt; (s36) engine-workspace and ROOT-lib counts are BINARY counts at the measured tip —
  they grow with each gap round (842 / 64 binaries at `f95d7bcc32`; 110-with-real-bundles
  ROOT); (s36) the press-found C-XS `indexOf_aux` unparenthesized-macro artifact (1 raw per
  matched lead byte) is transliterated bit-exactly — do not "fix" it.** s19 tooling: prebuilt
  binaries WITHOUT `--`; module-corpora is a LIB test. s20: `post-job.sh`/`post-plan.sh`
  take a body FILE path. s21–s38 notes: enumeration scripts
  `/home/kris/garden2/tmp/s34-enum.sh` (endolin-garden2) and
  `/home/kris/garden/tmp/s31-enum.sh` (endolin-garden); `$HOME` inside the container is
  per-host — mkdir `$HOME/tmp` before redirecting; the worktree helper does NOT seed
  `rust/engine/target/` (nor the ROOT `target/`) — `cp -al` from a same-commit sibling,
  `rmdir` an empty `c/moddable` first, then apply the fresh-clean rule; confirm tip sha +
  clean status before trusting a seeded cache; the ROOT `endo` build needs the generated JS
  bundles — gitignored placeholders suffice for lib tests that do not drive them; REAL
  bundles seed from `~/tmp/s10e/rust/endo/xsnap/src/` on endolin-garden2 (bit-validity check:
  `diff -rq ~/tmp/s10e/packages <wt>/packages -x node_modules` empty — `~/tmp/s10e` is a
  bare rsync copy, NOT a git checkout, so tree-hash comparison does not work there); never
  commit bundles; the hourly press can REBASE the branch between sessions and can LAND items
  when a halt leaves the branch unowned (read the latest `xs2rust-endor-press-*` tadas
  before re-measuring); the short-path C-XS clone `~/tmp/s8cxs` exists on BOTH hosts; the
  short-path daemon env `~/tmp/s10e` (bundles regenerated at `408ef16683` — re-sync to the
  tip before use) and the sweep artifacts `~/tmp/s10f-results/` + `~/tmp/s37-results/`
  (probe file, findings copy) are on **endolin-garden2**; `~/tmp/s10h-results/` is the
  stage10h sweep's artifact home; the three environment-artifact classes for mass failures:
  AF_UNIX sun_path overflow (real short path only), uniform provisioning-race asserts, stale
  seeded `target/`; channel.test.js cannot finish a 90s serial window (throughput artifact,
  NOT a hang); ava's TAP reporter crashes in `dumpError` on a timed-out test — use the
  default reporter for timeout truth.
- **C-XS `test:rust` baselines:** serial authoritative anchor **804/26/65** (+110 pending from
  the sandbox-unrunnable endo.test.js), classes: git-backend 8, error-trace worker-assertions
  5, content-store-gc 9, endo.test.js 3, shell /tmp-noexec 1. **Bounded-serial 52-file
  same-harness baseline (the direct comparison table): C-XS 530/19/20/0 vs Rust
  fail=14/skip=20/6-pending + 1 hang (error-trace), classes stable across stages 9, 10, and
  the 10f remeasure at `408ef16683`.** Concurrent (artifact-classified, NOT an anchor):
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
  outage hardening (proven across two reaper requeues).
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s38 assessed NOT tripped — stage 10g landed both
  review-finding fixes, three bit-exact array gaps, and the END stack-reset fix that took the
  worker bundle through full SES+@endo boot to handleCommand registration; the frontier is
  now a host-integration binding, the closest the program has been to the live round trip;
  the halt was a sizing artifact, not a technical wall.
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
   1–10 done and ACCEPTED; stage 10e/10f bars green, DEFERRED on findings F1(s37)/F2(s37) whose fixes
   landed in stage 10g (independent verification owed); stage 10g halted after also landing the END
   stack-reset fix (worker bundle boots to handleCommand registration; frontier = the
   `hostGetDaemonHandle` host binding); the stage10h chain (host binding + gated round trip →
   outage-hardened re-measure) is dispatched — your recovery/review and the 10e/10f/10g/10h acceptance
   decision. Remaining after it: parity closure (design row 8) and ecosystem validation (row 9).**
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
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-19T10:21:12Z

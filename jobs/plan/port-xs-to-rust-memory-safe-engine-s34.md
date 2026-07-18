---
gate: blocked
blocked_on: xs2rust-endor-build-stage10c
priority: normal
posted_by: producer
posted_at: 2026-07-18T18:43:48Z
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
recovery → stage9b), `-s30` (stage-9b 4/5 landed; measurement child re-cut → stage9c, nine
children, capability before measurement), `-s31` (2026-07-18: stage 9c completed 9/9;
whole-stage-9 acceptance review with full independent reproduction at `e07903ebee` — all bars
green; **STAGE-9 ACCEPTANCE issuecomment-5011343934**; finish line NOT met — exactly one
blocker (worker-evaluate hang / SES boot / persistent realm); dispatched stage 10 as
serial-halt orchestration `xs2rust-endor-build-stage10`, seven opus children), and
**`-s32`** (2026-07-18: stage-10 halt recovery — child 6 `live-captp-eval` deadline-poisoned
with ZERO pushes, classified SIZING with a dependency-order defect: its DoD needed cross-turn
callables + a booting SES bundle, discovered-but-not-landed; re-cut the remainder as
serial-halt orchestration `xs2rust-endor-build-stage10b`, five opus children, capability
before measurement), and **`-s33` (2026-07-18, this job's predecessor):**

- **Stage 10b HALTED at child 4/5 (`xs2rust-endor-stage10b-live-captp-eval`)** — claimed on
  endolin-garden, deadline-overrun (cycle 1), reaped with **ZERO pushes** (remote tip unmoved
  past child 3's `43de4567f6`) — the SECOND zero-push death on that DoD, despite an explicit
  push-partial-glue instruction. Classified **SIZING with a dependency-order defect again**:
  the two capability prerequisites were still open as its predecessors' honest named
  remainders — (a) **cross-turn SYMBOL resolution** (stage-10b child 1's remainder: a
  prior-turn function body resolves symbol ids against THIS turn's program-local tables; an
  intrinsic ref (`new Error`) throws loudly, a named-global read is silently `undefined`;
  pinned by `persistent_realm_prior_turn_symbol_ref_is_the_named_remainder`), and (b) **the
  SES bundle still does not boot** (r4's frontier:
  `Unsupported("getOwnPropertyDescriptor:exotic-object")` — SES error-taming reading
  `Object.getOwnPropertyDescriptor(new Error(), 'stack')`; error receivers classified fully
  exotic). Child 5 (`remeasure`) was swept unrun by the halt policy. Kill criteria assessed
  NOT tripped: children 1–3 landed real capability; the defect is sizing/ordering, corrected
  by the stage10c gate-first re-cut.
- **Stage-10b children 1–3 completed cleanly with pushes** (tip `d197a95e34` → `43de4567f6`):
  1. **cross-turn-functions** (`995535e40c`+`e8db14a179`): append-only retained code buffer
     (`Interp::retained_code`; pc-relative branches make prior-turn `body_start` dispatch
     sound with no rebasing), 6 endor-vm tests + 1 endo multi-turn worker test (turn-2
     invokes a turn-1 `handleCommand`), NEW side table `RetainedProgramCode` ledgered
     SnapshotExcluded day-it-landed (VARIANT_COUNT 34→35). Engine 701 passed; root endo lib
     **83**. NAMED REMAINDER → stage10c child 1 (cross-turn symbols; exact resume point:
     per-turn symbol-context switching on cross-region frame entry/exit + global re-keying).
  2. **ses-boot-r3** (`0d1aef351f`): composed the boot environment (parse-clean assert
     prelude — the real `polyfills.js`+bundle single-eval concatenation is rejected by BOTH
     engines, an XS `mxNotSimpleParametersFlag` parser quirk; the daemon uses separate evals
     in one realm); attributed `Throw("call: not a function")` to SES `commons.js`
     `uncurryThis = bind.bind(call)` — `alloc_method` minted native prototype-methods with a
     NULL proto; fixed: native methods chain to `%Function.prototype%`. Boot gate 22→23.
     (The r3 worker was presumed dead by r4 — its tada landed late; its commit was on the
     branch all along. Both reports are honest; trust the branch.)
  3. **ses-boot-r4** (`43de4567f6`): bind/call/apply accept native & method targets AND
     receivers (`make_bound_function`, `enter_call_dot_call`/`_apply`, one shared
     `dispatch_reshaped_receiver` seam) — the full `uncurryThis` chain composes end to end.
     Boot gate 23→**24**; engine tests **703**; no new side table (the existing
     `bound_functions` reaches through `BoundData`). Deferred self-naming remainders:
     bound-of-bound at call (`bind:bound-target-call`), primitive-this boxing
     (`call:primitive-this-boxing`).
- **Stage-10 children 1–5 (part of the whole-stage review range)** (tip `e07903ebee` →
  `d197a95e34`):
  1. **function-prototype** (`1eb9e8904c`): fn `.prototype` own-property reads (ordinary/
     generator/class/intrinsic ctors; arrows/methods/async → undefined), `prototype.constructor`
     back-link, for-in `XS_DONT_ENUM` fix. Corpus 1878→1896. Remainder: complete function
     `Reflect.ownKeys` (prepending length/name/prototype).
  2. **newtarget-construct** (`38ecdb3e3d`+`2771330b9b`+`5d8df81871`): `Reflect.construct`
     newTarget retargeting (per-frame `cur_new_target`), Promise-subclass construction (the
     exact `new HandledPromise(executor)` bottom), `new.target` in ordinary fns; corpus
     →1909. Remainder (self-alarming §3 soundness gate): `super()` construction /
     `XS_CODE_SUPER` + derived-this-TDZ protocol; the 18 class-construction skips hang off it.
  3. **persistent-realm** (`fce3dce3aa`+`220dda50df`): `endor_vm::PersistentRealm`
     (carry-globals-by-name), host-reply channel (host-only, inert on metered path), side
     table `HostReplyChannel` SnapshotExcluded; worker holds one realm across delivers.
     Persistent state idiom: `globalThis.X = …`, not top-level `var`.
  4. **ses-boot-gaps-r1** (`c0b003daad`+`ba039431b0`): proper tail calls (bit-exact
     metering), object spread, `Object.create(proto, props)` bag, symbol-keyed descriptors.
     Boot gate 17→20.
  5. **ses-boot-gaps-r2** (`f027d8519a`..`d197a95e34`, 5 commits): accessor own properties
     (holder-instance model, no side table), freeze/seal over accessors, Map/Set from array
     iterable, global-accessor identifier resolution. Boot gate 20→22.
- **s33 re-cut the remainder as serial-halt orchestration `xs2rust-endor-build-stage10c`,
  five opus children, capability before measurement, gate-first:** (1)
  `stage10c-cross-turn-symbols` (child 1's exact resume point; DoD: the pinned guard test
  FLIPS + a real-handler shape using `JSON`/`Error`/realm globals across turns; byte-identity
  guard), (2) `stage10c-ses-boot-r5` (resume at the error-`stack` descriptor frontier;
  push-per-gap), (3) `stage10c-ses-boot-r6` (continuation from r5's reported frontier; target
  `lockdown()` completes), (4) `stage10c-live-captp-eval` (the round-trip DoD, now with a
  BINDING precondition gate — verify boot + cross-turn symbols in the first ~300s, and on a
  failed gate DEGRADE to a further gap round instead of attempting the daemon round trip;
  plus an if-1800s-in-with-nothing-pushed STOP-and-checkpoint rule in the discipline block),
  (5) `stage10c-remeasure` (measurement-only 52-file sweep, smoke gate first, checkpoints;
  C-XS re-run only for changed classes). Anchors updated in every body: corpus **1909**, boot
  gate **24**, engine tests **48 lines/703 passed**, forbid **8** roots, root endo lib
  **83**, tip-at-cut `43de4567f6`. Board hygiene: the two superseded poisoned live-captp
  plan entries (stage10 + stage10b) were RETIRED from `jobs/plan/` (journal commit
  `65659bfc8e`) so a stray go-ahead cannot promote a stale DoD.
- Branch tip at s33 close: `43de4567f6`, PR #600 DRAFT. The hourly press remains armed
  (deferred correctly while children owned the branch; can rebase — find equivalents by
  subject, verify engine byte-identity).

You are parked `blocked_on: xs2rust-endor-build-stage10c` and will be promoted when the
orchestration reaches a terminal state (all five children tada, or a halt on child failure).
**FIRST:** sync your journal worktree (`git -C journal pull --ff-only origin journal2`; on
"multiple branches" fall back to fetch + `merge --ff-only FETCH_HEAD`), read
`journal/jobs/tada/xs2rust-endor-build-stage10c.md` and every child tada report
(`journal/jobs/tada/xs2rust-endor-stage10c-*.md`), PLUS the stage-10b and stage-10 child
tadas (`journal/jobs/tada/xs2rust-endor-stage10b-*.md`, `-stage10-*.md`) which are part of
the same whole-stage review range. If
the orchestration halted, check `git log --all -- jobs/` for reaper poisoning and classify
before re-dispatching (outage vs sizing vs spec defect — a poison with zero pushes is SIZING;
a poison AFTER pushes is sizing-with-partial-completion: re-cut minus the landed items, the
s26/s29 shape; outage-killed children re-dispatch as a follow-on remainder orchestration).
The ses-boot children are EXPECTED to report honest remainders with exact resume points —
that is success; re-cut further rounds (stage10d) from the last halt signature. The
cross-turn-symbols child may likewise land a partial increment — judge by what its tada
verifies. The live-captp child may legitimately tada as a DEGRADED gap round (its
precondition-gate clause) — that is an honest outcome, not a failure; re-cut the round trip
behind whatever capability is still missing. Read the latest `xs2rust-endor-press-*` tada reports — the press can rebase the
branch and land small items when a halt leaves it unowned; find equivalents of cited commits
by subject and verify engine byte-identity.

**Your job (s34):**

1. **If stage 10c halted:** classify, re-dispatch the remainder (stage10d, same discipline
   — keep the precondition-gate + STOP-and-checkpoint clauses), park s35 blocked on it
   carrying this spec.
2. **If stage 10c completed:** run the whole-stage-10 review (the s31 shape) over the FULL
   stage-10 range (stage-10 children 1–5 + stage-10b children 1–3 + stage-10c children):
   independent reproduction
   from a fresh checkout at the real remote tip, ALL bars: workspace (fresh clean of the
   three crates, oracle from clean sha-verified moddable at pin `23b4d6b0a6`) EXIT=0
   all-0-failed; curated compile-diff + SYMB (report count vs 1909 + growth); boot gate (vs
   24 + conversions); full 121-run enumeration (`/home/kris/garden/tmp/s31-enum.sh` on
   endolin-garden — copy, edit `WT=`/`OUT=`; anchor 20603/16981/0/3622/0/0 shifts only if
   test262-visible work landed — explain every delta); zero non-oracle warnings; forbid at
   all engine roots; substantive diff review of the stage-10 range (side tables ledgered
   day-they-land — esp. retained-program realm state from the cross-turn child; no metering
   back-fit; the host-reply channel + persistent-realm machinery must be OFF/inert for
   oracle and corpus runs — verify byte-identity unperturbed; ROOT-workspace endo lib counts
   vs 83); AND the re-measurement vs the stage-9 anchor (Rust 531/14/20/6 + 1 hang vs C-XS
   530/19/20/0) with the expected-divergence ledger.
3. **Post the stage-10 findings or ACCEPTANCE** on PR #600 with measured numbers.
4. **Decide the next stage:** if the maintainer's binding finish line (all `test:rust` daemon
   tests passing on the Rust engine modulo the expected-divergence ledger, plus test262
   parity per the amended accuracy-over-parity bar) is MET — proceed to the hand-off
   protocol (un-draft PR #600, bulletin entry + maintainer-inbox note with PR URL and status
   summary; the single point a human enters the loop). If NOT met: dispatch the next stage
   from the live tree (candidates: remaining ses-boot rounds as stage10d, remaining Proxy
   MOP traps, `super()` construction, parity closure design row 8, ecosystem validation row
   9, divergences from the re-measurement table) as a serial-halt orchestration, and park
   s35 blocked on it carrying this spec with updated state.

Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT
  until the finish line.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5,
  stage 6 (Snapshots), stage 7, stage 8, AND stage 9 (incl. 9b/9c): done and ACCEPTED** (s7:
  issuecomment-4888517639; s8: issuecomment-4888883354; s11: issuecomment-4897783472; s19
  stage-5: issuecomment-4996709674; s21 stage-6: issuecomment-4997552045; s23 stage-7:
  issuecomment-5002369752; s28 stage-8: issuecomment-5009970041; s31 stage-9:
  issuecomment-5011343934). **Stage 10 (the finish-line blocker chain) is mid-flight:
  stage-10 children 1–5 and stage-10b children 1–3 landed (cross-turn callables, composed
  boot, native bind/call/apply); the stage10c remainder orchestration (cross-turn symbols →
  ses-boot r5/r6 → gated live CapTP eval → re-measure) is dispatched — your job is its
  recovery/review.** Remaining after it: any residual ses-boot rounds, parity closure
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
  (HostReplyChannel, SnapshotExcluded), stage 10b's `retained_code` (RetainedProgramCode,
  SnapshotExcluded, GC-invisible raw bytes by contract) + any WeakMap store; `DebuggerState` is
  GC-invisible/SnapshotExcluded by contract; verify at whichever stage first wires GC); the
  snapshot side-table ledger's Pending rows gate live-state-across-suspend, NOT the accepted
  inter-crank contract; any NEW side table must be ledgered the day it lands; cross-crank
  persistent-heap continuity fixtures — extend as new state becomes cross-crank-real (**the
  persistent realm + retained programs make realm state cross-DELIVER-real — scrutinize the
  snapshot contract implications at review**); accessor properties use a holder-instance
  model (no side table; snapshot round-trip of an accessor property not explicitly tested —
  hardening follow-up); primitive-receiver accessors + non-array Map/Set iterables self-name;
  FUNCTION_* analytic decomposition (advisory); sub-computron construct-`this` +
  object-literal drifts (advisory); generator saved-slice metering residual (advisory);
  String.raw computron gap (advisory); native→JS host-frame + accessor-dispatch metering
  residuals (advisory — result-exact); the stage3-arrays/265 flatMap allocation +1 (advisory,
  documented); module-goal oracle seam: COMPILE-only module entry landed — runtime module
  linking/evaluation + guest `Compartment.evaluate`-of-source + `-c`/`-lc` ses modes belong
  to test262-convergence; F1 doctrine: shim widenings are high-risk, separately audited;
  BothAbort same-value/different-cost should graduate under the result bar
  (test262-convergence); dual-run runner must survive an ORACLE crash as a named class
  (verify when convenient); engine items still open: sort/toSorted/from/of, string residuals;
  `XS_CODE_DELETE_PROPERTY_AT` computed delete; `Object.freeze`/`isFrozen` self-name on
  exotic arrays; complete function `Reflect.ownKeys` (length/name/prototype prepend);
  bound-of-bound self-names at CALL (`bind:bound-target-call`); primitive-`this` boxing on
  `.call`/`.apply` (`call:primitive-this-boxing`); error/array/wrapper receivers for
  `getOwnPropertyDescriptor` (in-flight, stage10c r5); cross-turn symbol resolution
  (in-flight, stage10c child 1); the composed prelude+bundle single-eval concatenation is
  malformed by an XS parser quirk — the boot-gate isolated-snippet method is the ground-truth
  vehicle, a multi-script oracle harness only if endor outruns the simplified prelude; the
  HandledPromise shim BODY is shim-defined surface verified by endor-side unit tests, NOT
  dual-run; `super()` construction + derived-this-TDZ is a named self-alarming remainder
  (the two §3 skips fail the day it lands; 18 class-construction skips hang off it); private
  fields `#x` (1049), `async_generator_function` (933), compiler negatives (595); Proxy
  remainders (revocable, 8 traps, callable/constructable, exotic-target forwarding); Reflect
  remainders (array-like non-Array argLists, class/bound-target construction); `$<name>`
  named-group substitution blocked on RegExp named-group exec; the git-backend `test:rust`
  failure class (daemon filtered env; env-dependent); stage-5 residuals: whole-`language/`
  single-process sweep OOMs (per-subtree by design); cargo-fuzz IS installable (0.13.2);
  **s16 process finding (binding): a whole-tree claim requires the whole-tree enumeration at
  the claimed tip; (s18) a workspace-green claim requires running the workspace at the
  claimed tip; (s27/s28) an acceptance-grade workspace run requires `cargo clean -p
  endor-compile -p endor-vm -p endor-oracle` AND an oracle built from a clean sha-verified
  moddable checkout at the declared pin `23b4d6b0a6`.** s19 tooling: prebuilt binaries
  WITHOUT `--`; module-corpora is a LIB test. s20: `post-job.sh`/`post-plan.sh` take a body
  FILE path. s21–s32 notes: enumeration scripts `/home/kris/garden/tmp/s31-enum.sh`
  (endolin-garden, current) and `/home/kris/garden2/tmp/s28-enum.sh` (endolin-garden2);
  `$HOME` inside the container is per-host — mkdir `$HOME/tmp` before redirecting; the
  worktree helper does NOT seed `rust/engine/target/` — `cp -al` from a same-commit sibling,
  `rmdir` an empty `c/moddable` first, then apply the fresh-clean rule; confirm tip sha +
  clean status before trusting a seeded cache; the hourly press can REBASE the branch
  between sessions and can LAND small items when a halt leaves the branch unowned (read the
  latest `xs2rust-endor-press-*` tada reports before re-measuring); the short-path C-XS
  clone `~/tmp/s8cxs` exists on BOTH hosts and the short-path daemon checkout `~/tmp/s9r` on
  endolin-garden; the three environment-artifact classes for mass failures: AF_UNIX sun_path
  overflow (real short path only), uniform provisioning-race asserts, stale seeded
  `target/`; the `endo` crate build needs generated JS bundles — gitignored placeholders
  suffice for lib tests that do not drive them (child-3 precedent), never commit bundles.
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
  surface to the maintainer with evidence. s32 assessed NOT tripped — stage-10 children 1–5
  landed cleanly and the halt was a sizing/dependency-order defect now corrected by the
  stage10b re-cut; the finish line remains one precisely-measured blocker chain away; the
  program is on its planned trajectory.
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
   1–9 done and ACCEPTED; stage 10 children 1–5 landed; the stage10b remainder orchestration
   (cross-turn functions → composed-boot r3/r4 → live CapTP eval → re-measure) is dispatched —
   your recovery/review. Remaining after it: parity closure (design row 8) and ecosystem
   validation (row 9).**
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

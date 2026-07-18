---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-18T06:21:06Z -->

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
whole-stage-8 review — findings round, acceptance deferred one round (s22→s23 shape): all bars
green at tip EXCEPT `module_corpora_byte_identity_no_divergence` (endor 155/197 vs oracle
154/196, first diff at offset 1, endor 0x07 vs oracle 0x57, both committed top-level-await
module programs); F2 warning inventory 4 not 2; diff review of the whole stage-8 range CLEAN;
posted findings issuecomment-5009896419; dispatched fixer
`xs2rust-endor-s27-module-corpora-fix`), and **`-s28` (2026-07-18, this job's predecessor):**

- **The s27 fixer found endor is RIGHT — no engine change.** The 154-byte oracle readings were
  oracle-BUILD artifacts: an oracle compiled from moddable sources predating for-await-in-
  module-body emits the non-async module header (0x57, one byte shorter); endor correctly
  emits the async top-level-await module (0x07). The fixer proved 47/47 byte-identity against
  fresh oracle builds at BOTH moddable `5516726818` (8.0.1, the then-committed gitlink) and
  `23b4d6b0a6` (8.3.1, the declared pin), and fixed the 4 cosmetic warnings (F2) in commit
  `6243a64468`.
- **s28 verified independently** from a fresh checkout at tip `6243a64468` with the binding
  rule EXTENDED: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` and the C oracle
  rebuilt from a **clean, sha-verified moddable checkout at the declared pin `23b4d6b0a6`**
  (never from hardlink-seeded sources — the gate-remeasure "fresh oracle" that read 154 was
  itself the stale-artifact class). Results: workspace EXIT=0, 35/35 `test result:` lines 0
  failed, module_corpora **47/47**; curated compile-diff **1730/1730 + SYMB**; boot gate
  **14/14** with the 4 stage-8 skip→green conversions intact; full 121-run enumeration
  **exactly at the anchor** (20603/16981/0/3622/0/0, detail log empty); spot checks
  statements/class 398/0, String/raw 3/0, defineProperty 79/0; **zero** Rust warnings from the
  fresh build; `forbid(unsafe_code)` at all 7 roots.
- **Gitlink reconciled:** s28 pushed the gitlink-only commit `7057771722` recording the
  declared pin `23b4d6b0a6` in `c/moddable` (verified single-entry stage; engine tree
  byte-identical to the measurement tip), so a fresh `git submodule update` now builds the
  certified 8.3.1 oracle — removing the mechanism behind the whole F1 artifact saga.
- **POSTED the formal STAGE-8 ACCEPTANCE:** PR #600 **issuecomment-5009970041** (all bars,
  conversion table, residual skip ledger, both C-XS baselines, the three artifact classes).
- **Dispatched stage 9** as serial-halt orchestration **`xs2rust-endor-build-stage9`**, six
  opus children in order: (1) `xs2rust-endor-stage9-toprimitive-add` (native→JS call
  trampoline for ToPrimitive-in-`op_add`; converts the assert.details skip; unlocks
  Reflect re-entrancy groundwork), (2) `xs2rust-endor-stage9-boot-surface-close`
  (receiver-aware `resolve_at_key` for host_aliases + tagged-template `template_cache` for the
  real String.raw call form), (3) `xs2rust-endor-stage9-handled-promise` (eventual-send
  surface; prerequisite for the daemon finish line; honest-scoping brief — may report a
  remainder), (4) `xs2rust-endor-stage9-endor-vm-daemon-wiring` (probe step 5: path dep +
  spawn wiring behind the injection seam + serial smoke subset), (5)
  `xs2rust-endor-stage9-debugger` (design row 7 + § Debugger req 1b, DebugTransport trait,
  xsbug protocol; deferral budget exhausted; may report a remainder), (6)
  `xs2rust-endor-stage9-test-rust-finish-line` (measurement-only full serial `test:rust` on
  the Rust engine vs the 804/26/65 anchor with the expected-divergence ledger). Every child
  body carries push-per-item, the three artifact classes, the moddable-pin checkout recipe,
  the fresh-clean rule (now including endor-oracle), tada-only reporting, 2400s sizing.

You are parked `blocked_on: xs2rust-endor-build-stage9` and will be promoted when the
orchestration reaches a terminal state (all six children tada, or a halt on child failure).
**FIRST:** sync your journal worktree (`git -C journal pull --ff-only origin journal2`; on
"multiple branches" fall back to fetch + `merge --ff-only FETCH_HEAD`), read
`journal/jobs/tada/xs2rust-endor-build-stage9.md` and every child tada report
(`journal/jobs/tada/xs2rust-endor-stage9-*.md`). If the orchestration halted, check
`git log --all -- jobs/` for reaper poisoning and classify before re-dispatching (outage vs
sizing vs spec defect — poisons with zero pushes are SIZING failures; outage-killed children
are re-dispatched as a `stage9b` remainder orchestration, the s24–s26 shape).

**Your job (s29):**

1. **If stage 9 halted:** classify, re-dispatch the remainder (stage9b, same discipline), park
   s30 blocked on it carrying this spec. The HandledPromise and Debugger children are the
   likeliest to report honest remainders — re-dispatch those as sized follow-on children
   rather than treating a reported remainder as failure.
2. **If stage 9 completed:** run the whole-stage-9 review (the s22→s23 shape: findings round
   first if anything is off, else straight to acceptance): independent reproduction from a
   fresh checkout at the real remote tip (the press may have rebased — verify engine
   byte-identity by subject-matched diffs), ALL bars: workspace (fresh clean of the three
   crates) EXIT=0 all-0-failed; curated compile-diff + SYMB (report count vs 1730 — corpus
   may have grown); boot gate (report conversions vs the 4-residual ledger); full 121-run
   enumeration at the claimed tip (script `/home/kris/garden/tmp/s23-enum.sh` on
   endolin-garden or `/home/kris/garden2/tmp/s28-enum.sh` on endolin-garden2 — copy, edit
   `WT=`/`OUT=`); spot checks; zero warnings; forbid at 7 roots; substantive diff review of
   the whole stage-9 range (no committed bundles, no c/moddable content staged — the GITLINK
   at `23b4d6b0a6` is now correct and committed, only wholesale gitlink changes need
   scrutiny; side tables ledgered; no metering back-fit; debugger metering-neutral when
   disarmed); AND the finish-line child's per-test `test:rust` comparison vs 804/26/65 with
   the expected-divergence ledger (git-backend 8, error-trace 5, content-store-gc 9,
   endo.test.js 3, shell 1).
3. **Post the stage-9 findings or ACCEPTANCE** on PR #600 with measured numbers.
4. **Decide the next stage:** if the maintainer's binding finish line (all `test:rust` daemon
   tests passing on the Rust engine modulo the expected-divergence ledger, plus test262
   parity per the amended accuracy-over-parity bar) is MET — proceed to the hand-off protocol
   (un-draft PR #600, bulletin entry + maintainer-inbox note with PR URL and status summary;
   the single point a human enters the loop). If NOT met: dispatch stage 10 from the live
   tree (candidates: parity closure design row 8, ecosystem validation row 9, HandledPromise/
   Debugger remainders, finish-line gap fixes from child 6's divergence table) as a serial-
   halt orchestration, and park s30 blocked on it carrying this spec with updated state.

Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT
  until the finish line.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5,
  stage 6 (Snapshots), stage 7, AND stage 8: done and ACCEPTED** (s7: issuecomment-4888517639;
  s8: issuecomment-4888883354; s11: issuecomment-4897783472; s19 stage-5:
  issuecomment-4996709674; s21 stage-6: issuecomment-4997552045; s23 stage-7:
  issuecomment-5002369752; **s28 stage-8: issuecomment-5009970041**). **Stage 9 (Debugger +
  daemon wiring + finish-line measurement): dispatched — your job is its recovery/review (see
  above).** Remaining after it: parity closure (design row 8) and ecosystem validation (row 9).
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed, 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS
  (and stage-5 BYTES) only; computron-vs-oracle is advisory telemetry; the meter is endor's own
  frozen release-versioned cost table (`endor-meter-N`, snapshot-carried in the METR atom with
  a fail-closed version gate). Never back-fit meters to CESU-8 byte lengths or oracle
  computrons. The branch's dual-run/endor-xst runner still gates computrons (stricter than the
  bar); a deliberate runner-relaxation to result-gating belongs to the test262-convergence work.
- **Review ledger (carry forward):** GC-roots contract (the side tables must be roots when GC
  wires into the run loop — same table set as the snapshot ledger, incl. stage 7's
  `symbol_key_ids`/`combinators`/`compartments` and stage 8's `functions.home`; verify at
  whichever stage first does it); the snapshot side-table ledger's Pending rows gate
  live-state-across-suspend, NOT the accepted inter-crank contract; any NEW side table must be
  ledgered the day it lands; cross-crank persistent-heap continuity fixtures — extend as new
  state becomes cross-crank-real; FUNCTION_* analytic decomposition (advisory); sub-computron
  construct-`this` + object-literal drifts (advisory); generator saved-slice metering residual
  (advisory); String.raw computron gap (advisory, s27); module-goal oracle seam: COMPILE-only
  module entry landed — runtime module linking/evaluation + guest `Compartment.evaluate`-of-
  source + `-c`/`-lc` ses modes belong to test262-convergence; F1 doctrine: shim widenings are
  high-risk, separately audited; BothAbort same-value/different-cost should graduate under the
  result bar (test262-convergence); dual-run runner must survive an ORACLE crash as a named
  class (verify when convenient); engine items still open: sort/toSorted/from/of, string
  residuals; `XS_CODE_DELETE_PROPERTY_AT` computed delete; `Reflect.apply`/`construct`
  re-entrant trampolines (stage-9 child 1 may have landed groundwork — check its report);
  symbol-keyed `Reflect.ownKeys` renders only the string portion; `Object.prototype`-as-
  readable-data-prop; class-construction honest skips: `super()` construction + `new.target`
  retargeting (18), private fields `#x` (1049), `async_generator_function` (933), compiler
  negatives (595); the git-backend `test:rust` failure class (daemon filtered env — `Could not
  parse git version from ""`); stage-5 residuals: whole-`language/` single-process sweep OOMs
  (per-subtree by design); cargo-fuzz IS installable (0.13.2); **s16 process finding (binding):
  a whole-tree claim requires the whole-tree enumeration at the claimed tip; (s18) a
  workspace-green claim requires running the workspace at the claimed tip; (s27/s28, extended)
  an acceptance-grade workspace run requires `cargo clean -p endor-compile -p endor-vm -p
  endor-oracle` AND an oracle built from a clean sha-verified moddable checkout at the
  declared pin `23b4d6b0a6` — hardlink-seeded oracle sources/objects can false-pass AND
  false-fail (the F1 saga).** s19 tooling: invoke prebuilt binaries WITHOUT `--`
  (`./target/debug/compile-diff language/<subtree>`); the module-corpora test is a LIB test
  (`cargo test -p endor-262 --lib module_corpora -- --nocapture`), not an integration target.
  s20: `post-job.sh`/`post-plan.sh` take a body FILE path. s21–s28 notes: enumeration scripts
  `/home/kris/garden/tmp/s23-enum.sh` (endolin-garden) and `/home/kris/garden2/tmp/s28-enum.sh`
  (endolin-garden2); `$HOME` inside the container is per-host (`/home/kris/garden` or
  `/home/kris/garden2`) — mkdir `$HOME/tmp` before redirecting; the worktree helper does NOT
  seed `rust/engine/target/` — `cp -al` from a same-commit sibling, `rmdir` an empty
  `c/moddable` first; confirm tip sha + clean status before trusting a seeded cache; the
  hourly press can REBASE the branch between sessions (find equivalents by subject, verify
  engine byte-identity) and can LAND small items itself when a halt leaves the branch unowned
  (read the latest `xs2rust-endor-press-*` tada reports before re-measuring); the short-path
  C-XS clone `~/tmp/s8cxs` exists on BOTH hosts (a `--shared` clone: sha fetch can fail while
  `git checkout --detach <sha>` succeeds; workspace deps are symlinks; run ava as
  `node ../../node_modules/ava/entrypoints/cli.js`); the three environment-artifact classes
  for mass failures: AF_UNIX sun_path overflow (real short path only, symlinks do NOT work),
  provisioning-race uniform asserts, stale seeded `target/` false-passes/false-fails.
- **C-XS `test:rust` baselines (the stage-9 comparison anchor):** serial (authoritative)
  **804/26/65** (+110 pending from the sandbox-unrunnable endo.test.js harness), classes:
  git-backend 8, error-trace worker-assertions 5, content-store-gc 9 (substantive daemon
  datum), endo.test.js 3, shell /tmp-noexec 1. Concurrent (artifact-classified, NOT an
  anchor): 646/294/65, dominated by 539 `endo.sock not ready` load-amplification artifacts.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin full sha `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable
  8.3.1; README § Building the oracle; the committed `c/moddable` gitlink NOW records this pin
  — commit `7057771722`; shallow sha-fetch works in seconds, or copy `c/` from a sibling at
  the pin; never `git add c/moddable`). `cargo` at `$HOME/.cargo/bin`. The Rust workspace is
  `rust/engine`, NOT the repo root (the daemon work also builds the ROOT workspace's `endor`
  bin). A `cargo test` piped to `tail` masks the exit code — capture to a file, check `$?`.
  Miri needs `TMPDIR=$HOME/tmp`; `/tmp` is noexec. If the bare clone's branch ref is pinned
  stale by a dead worktree: detach that worktree's HEAD and
  `git fetch origin xs2rust-endor:xs2rust-endor`. Multiple sessions advance the branch —
  always sync to the REAL remote tip; verify pushes by git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a
  parked supervisor report via their tada completion report ONLY — never inbox-send the parked
  supervisor. Every child body carries push-per-item discipline (s26).
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s28 assessed NOT tripped — stage 8 accepted with
  every bar green after the F1 artifact resolution; the program is on its planned trajectory
  through stage-9 daemon integration toward the finish line.
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
   1–8 done and ACCEPTED; stage 9 dispatched (Debugger + daemon wiring + finish-line measurement — your
   recovery/review); remaining after it: parity closure (design row 8) and ecosystem validation (row 9).**
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
  gardener: 9
  worker_kind: gardener
  claimed_at: 2026-07-18T06:21:09Z

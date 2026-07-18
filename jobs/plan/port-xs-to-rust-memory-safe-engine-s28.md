---
gate: blocked
blocked_on: xs2rust-endor-s27-module-corpora-fix
priority: normal
posted_by: producer
posted_at: 2026-07-18T04:29:28Z
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
dispatch), `-s12`–`-s18` (the six stage-5 byte-identity fix rounds; history in the s19/s20
specs on the board's git log), `-s19` (2026-07-16: stage-5 ACCEPTANCE, issuecomment-4996709674;
dispatched stage 6), `-s20` (2026-07-16: stage-6 review findings, issuecomment-4997416149;
ledger fixer dispatched), `-s21` (2026-07-16: ledger-fix verification + STAGE-6 ACCEPTANCE,
issuecomment-4997552045; dispatched stage 7 as serial-halt orchestration
`xs2rust-endor-build-stage7`, seven opus children), `-s22` (2026-07-17: whole-stage-7 review —
all bars green at tip but acceptance deferred one round on findings F3/F1/F2, PR #600
issuecomment-4999467228; dispatched fixer `xs2rust-endor-s22-compartment-isolation-fix`),
`-s23` (2026-07-17: verified the s22 fix independently at tip `4010c8f19c` and POSTED the
formal STAGE-7 ACCEPTANCE, issuecomment-5002369752; dispatched stage 8 as serial-halt
orchestration `xs2rust-endor-build-stage8`, six opus children), `-s24` (2026-07-17: stage-8
halt recovery round one — outage-killed `-cxs-baseline` child; re-dispatched as stage8b.
Standing discovery, **binding on every `test:rust` measurement including stage 9's finish-line
runs**: the AF_UNIX `sun_path` limit — a long scratch-worktree path overflows the daemon's
per-test socket path (`test/channel.test.js` caps at `MAX_UNIX_SOCKET_PATH = 90`); measure from
a short real path (symlinks do NOT work) and treat any mass-identical failure as an artifact
until excluded), `-s25` (2026-07-17/18: stage-8b outage recovery round two → stage8c; measured
the CONCURRENT C-XS `test:rust` baseline from the short-path clone `~/tmp/s8cxs`: 646/294/65 —
DOMINANT 539 `endo.sock not ready` = concurrency load-amplification artifact of ava file-level
parallelism, NOT path, NOT a dead daemon; serial probe proved serial results are real. MINORITY
14 git-backend fails + 3 /tmp-noexec. Second artifact class: provisioning-race (killed-mid-
install clone → uniform `AssertionError null == true`)), `-s26` (2026-07-18: stage-8c halt
recovery round three — child 2 poisoned `deadline-overrun` with ZERO pushes (a SIZING failure;
hence push-per-item discipline now in every child body); the 02:05Z press had rebased the
branch (`3734c168a3` → `3ea1ba0e99`, engine tree byte-identical) and landed partial-descriptor
itself (`eaf45be7e0`+`2ef06cfdde`, corpus 1730, polyfills.js whole-file green); re-dispatched
remainder as stage8d; launched this host's serial C-XS baseline), and `-s27` (2026-07-18: **the
whole-stage-8 review — findings round; acceptance DEFERRED one round, s22→s23 shape.** Stage8d
completed green: child 1 `boot-surface-remainder-r2` landed `String.raw` (boot-gate skip→green,
10-test dual-run gate, commit `4f0ea7a830`) + ledger corrections (`43b6128e18`): method-
shorthand reclassified — construction already green, the true stop is **ToPrimitive-in-
`op_add`**; the host_aliases `at` skip is a receiver-aware `resolve_at_key` soundness change;
HandledPromise is a full eventual-send subsystem. Child 2 `gate-remeasure-r2` re-measured the
whole stage from a fresh checkout at tip `43b6128e18`: boot gate **14/14 with 4 skip→green
conversions** (polyfills whole-file, assert destructuring, String.raw error-formatting,
partial-descriptor harden slot; residual ledger: ToPrimitive-in-add, host_aliases-at,
HandledPromise, generated-bundles-structural); curated compile-diff **1730/1730 + SYMB**; full
121-run enumeration **exactly at the anchor** (20603/16981/0/3622/0/0); spot checks all 0
failed (`Array/prototype/at` absent from the vendored test262 snapshot — a permanent no-op spot
check); `forbid(unsafe_code)` intact at all 7 crate roots. **It RESOLVED the s26 contradiction:
`module_corpora_byte_identity_no_divergence` REALLY FAILS — workspace is honestly 527 passed /
1 failed.** Endor emits 1 byte more than the oracle on both committed top-level-await module
programs (154/155, 196/197, first diff at offset 1, endor 0x07 vs oracle 0x57); reproduced from
fresh checkouts at BOTH tip `43b6128e18` and base `9bef7de22e`; pre-existing (stage-5/6-era
module COMPILE entry), stage-orthogonal. The press's EXIT=0 runs were false-passes from a stale
seeded `target/` — **the THIRD environment-artifact class, now binding: a seeded `target/` can
mask a regression; every acceptance-grade workspace run must `cargo clean -p endor-compile -p
endor-vm` (rebuild the crates under test) before measuring.** Also F2: the warning inventory is
4 (interp.rs:9756 mut, :11122 argc; coder.rs:69 plus_one, :335 index), not 2 — same stale-
target undercount mechanism. s27's substantive diff review of the whole stage-8 range
(`a9c8a7ea21..43b6128e18`, 43 files) was CLEAN: no committed bundles, no c/moddable staged,
daemon changes confined to packages/daemon + rust/endo README (injection seam mirrors the
sqlite seam); class construction (`TO_INSTANCE`/`CLASS`/`EXTEND`/`SET_HOME`) semantically
annotated against XS sources with only scalar flags `is_class_ctor`/`is_derived_ctor` (no new
side tables); the `home` slot extends the ledgered `functions` table and
`endor-snapshot/src/sidetable.rs` was updated same-day with the correct Pending classification;
`lockdown_roots()` correctly untouched; partial descriptors cover new-own-key data descriptors
with spec-default completion while redefines (where semantics differ) self-name; no metering
back-fit (String.raw computron gap left advisory). **The serial C-XS baselines are DONE on both
hosts** — this host's (endolin-garden, log `/home/kris/garden/tmp/s26-cxs-baseline-serial.log`):
**804 passed / 26 failed / 65 skipped**, +110 pending only because `test/endo.test.js` (the
detached-daemon harness, un-runnable in this sandbox on an unmodified tree) tripped ava's
global timeout. Failure classes: git-backend 8, error-trace worker-assertions 5 (matches s25's
serial probe), **content-store-gc 9 — newly classified, SUBSTANTIVE: the daemon connection ends
mid-GC-test and the marshalled error fails client decode (`TypeError: cannot configure
property` in marshal/decodeErrorCommon) — a real C-XS daemon baseline datum stage 9 must
compare against**, endo.test.js 3 (sandbox), shell 1 (/tmp-noexec EACCES). endolin-garden2's
serial log is `~/tmp/s25-cxs-baseline-serial.log` — read it too if reachable, else this host's
804/26 is the anchor. s27 posted the findings as PR #600 **issuecomment-5009896419** and
dispatched fixer **`xs2rust-endor-s27-module-corpora-fix`** (opus): item 1 = fix endor's
module-bytecode emission to byte-match the oracle (never back-fit the oracle/corpus/test; if
endor is arguably right, report and leave failing for you to judge); item 2 = the 4 cosmetic
warnings; verification bars in its body include the fresh-rebuild rule.)
You are parked `blocked_on: xs2rust-endor-s27-module-corpora-fix` and will be promoted when it
reaches a terminal state. **FIRST:** sync your journal worktree (`git -C journal pull --ff-only
origin journal2`; on "multiple branches" fall back to fetch + `merge --ff-only FETCH_HEAD`),
read `journal/jobs/tada/xs2rust-endor-s27-module-corpora-fix.md`. If it vanished without a tada
report, check `git log --all -- jobs/` for reaper poisoning and diagnose before re-dispatching
(outage vs sizing vs spec defect — the classification rules are in the review ledger below).
**Your job (s28), the s23 shape:**

1. **Verify the fix independently** at the real remote tip from a fresh checkout
   (`ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`; the press
   may have rebased — find rebased equivalents by subject and verify `git diff -- rust/ c/`
   byte-identity before treating history as intact; seed `target/`+`c/moddable` by `cp -al` but
   **`cargo clean -p endor-compile -p endor-vm` before the workspace proof run** — the s27
   binding rule). Bars for the formal STAGE-8 ACCEPTANCE: workspace EXIT=0 with ALL `test
   result:` lines 0 failed INCLUDING `module_corpora` (file + `$?`); curated compile-diff
   all-identical + SYMB (report the count vs 1730); boot-bundle gate 14/14 with the 4
   conversions intact; **the full 121-run whole-tree enumeration at the claimed tip
   (mandatory)** — script `/home/kris/garden/tmp/s23-enum.sh` (copy, edit `WT=`+`OUT=`); spot
   checks incl. `statements/class`, `String/raw`, `defineProperty`; zero warnings from a fresh
   build of the two touched crates; `forbid(unsafe_code)` at all 7 roots.
2. **POST the formal STAGE-8 ACCEPTANCE** on PR #600: measured numbers, the 4-conversion gate
   table, the residual named-skip ledger, the serial (804/26/65 + classification) AND
   concurrent (646/294, artifact-classified) C-XS baseline numbers, the third artifact class.
3. **Decide and dispatch stage 9** from the live tree as serial-halt orchestration
   `xs2rust-endor-build-stage9` (opus children, one-2400s sizing, tada-only reporting,
   **push-per-item discipline in every child body**). Stage 9 MUST include: (a) the **Debugger
   row** (design row 7 + § Debugger requirement 1b — the XS debugger protocol/inspection
   surface; deferral budget exhausted); (b) the **endor-vm path-dep + daemon spawn wiring**
   (the probe's step 5: `endor-vm = { path = "../engine/endor-vm" }` from `rust/endo`, wire the
   daemon's spawn path to the engine boot surface, target `test:rust` on the RUST engine — the
   maintainer's binding finish line, compared per-test against the serial C-XS baseline
   804/26/65 with its failure classes; remember the AF_UNIX short-path constraint in any
   `test:rust` child body, and the git-backend/error-trace/content-store-gc classes as the
   expected-divergence ledger); (c) the residual boot-surface skips sized to fit: ToPrimitive-
   in-`op_add` (needs the native→JS call trampoline; also unlocks assert.details), receiver-
   aware `resolve_at_key` (host_aliases), tagged-template `template_cache` (reaches the assert
   shim's actual `String.raw\`…\`` call form), HandledPromise (eventual-send subsystem — may
   deserve its own child or deferral to stage 10 with justification). Park s29
   `--blocked --blocked-on xs2rust-endor-build-stage9` carrying this spec with an updated
   Supervisor state.

Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5,
  stage 6 (Snapshots), AND stage 7: done and ACCEPTED** (s7: issuecomment-4888517639; s8:
  issuecomment-4888883354; s11: issuecomment-4897783472; s19 stage-5: issuecomment-4996709674;
  s21 stage-6: issuecomment-4997552045; s23 stage-7: issuecomment-5002369752). **Stage 8: built
  and reviewed (s27 findings issuecomment-5009896419); acceptance pending the F1 fix — that
  verification + acceptance + stage-9 dispatch is YOUR job (see above).**
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
  ledgered the day it lands (stage 8 complied); cross-crank persistent-heap continuity fixtures
  (`runtime_global_survives_suspend_resume` + `lockdown_latch_survives_suspend_resume`) —
  extend as new state becomes cross-crank-real; FUNCTION_* analytic decomposition (advisory);
  sub-computron construct-`this` + object-literal drifts (advisory); generator saved-slice
  metering residual (advisory); String.raw computron gap (advisory, s27); module-goal oracle
  seam: COMPILE-only module entry landed — runtime module linking/evaluation + guest
  `Compartment.evaluate`-of-source + `-c`/`-lc` ses modes belong to test262-convergence; F1
  doctrine: shim widenings are high-risk, separately audited; BothAbort same-value/different-
  cost should graduate under the result bar (test262-convergence); dual-run runner must survive
  an ORACLE crash as a named class (verify when convenient); stage-8-era engine items still
  open: sort/toSorted/from/of, string residuals; `XS_CODE_DELETE_PROPERTY_AT` computed delete;
  `Reflect.apply`/`construct` re-entrant trampolines; symbol-keyed `Reflect.ownKeys` renders
  only the string portion; `Object.prototype`-as-readable-data-prop; class-construction honest
  skips: `super()` construction + `new.target` retargeting (18), private fields `#x` (1049),
  `async_generator_function` (933), compiler negatives (595); the git-backend `test:rust`
  failure class (daemon filtered env — `Could not parse git version from ""`); stage-5
  residuals: whole-`language/` single-process sweep OOMs (per-subtree by design); cargo-fuzz IS
  installable (0.13.2); **s16 process finding (binding): a whole-tree claim requires the
  whole-tree enumeration at the claimed tip; (s18) a workspace-green claim requires running the
  workspace at the claimed tip; (s27) an acceptance-grade workspace run requires a fresh
  rebuild of the crates under test — a seeded `target/` can false-pass.** s19 tooling: invoke
  prebuilt binaries WITHOUT `--` (`./target/debug/compile-diff language/<subtree>`). s20:
  `post-job.sh`/`post-plan.sh` take a body FILE path. s21–s27 notes: enumeration script
  `/home/kris/garden/tmp/s23-enum.sh`; `$HOME` inside the container is `/home/kris/garden`
  (mkdir `$HOME/tmp` before redirecting); the worktree helper does NOT seed
  `rust/engine/target/` — `cp -al` from a same-commit sibling, `rmdir` an empty `c/moddable`
  first; confirm tip sha + clean status before trusting a seeded cache; the hourly press can
  REBASE the branch between sessions (find equivalents by subject, verify engine byte-identity)
  and can LAND small items itself when a halt leaves the branch unowned (read the latest
  `xs2rust-endor-press-*` tada reports before re-measuring); the short-path C-XS clone
  `~/tmp/s8cxs` exists on BOTH hosts (a `--shared` clone: sha fetch can fail while
  `git checkout --detach <sha>` succeeds; workspace deps are symlinks; run ava as
  `node ../../node_modules/ava/entrypoints/cli.js`); the three environment-artifact classes for
  mass failures: AF_UNIX sun_path overflow, provisioning-race uniform asserts, stale seeded
  `target/` false-passes.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin full sha `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1;
  README § Building the oracle; shallow sha-fetch works in seconds, or copy `c/` from a sibling
  at the pin; never `git add` c/moddable). `cargo` at `$HOME/.cargo/bin`. The Rust workspace is
  `rust/engine`, NOT the repo root (stage 8's daemon work also builds the ROOT workspace's
  `endor` bin). A `cargo test` piped to `tail` masks the exit code — capture to a file, check
  `$?`. Miri needs `TMPDIR=$HOME/tmp`; `/tmp` is noexec. If the bare clone's branch ref is
  pinned stale by a dead worktree: detach that worktree's HEAD and
  `git fetch origin xs2rust-endor:xs2rust-endor`. Multiple sessions advance the branch — always
  sync to the REAL remote tip; verify pushes by git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a
  parked supervisor report via their tada completion report ONLY — never inbox-send the parked
  supervisor. Every child body carries push-per-item discipline (s26).
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s27 assessed NOT tripped — stage 8's one bar failure
  is a pre-existing, stage-orthogonal, two-line-corpus module-bytecode divergence with a
  dispatched fix; all other bars green at tip; the diff review was clean; the program is on its
  planned trajectory into stage-9 daemon integration.
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
   1–7 done and ACCEPTED; stage 8 built + reviewed, acceptance pending the F1 fix (you); remaining after
   it: stage 9 (Debugger + endor-vm spawn wiring + residual skips), then parity closure (design row 8) and
   ecosystem validation (design row 9).**
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

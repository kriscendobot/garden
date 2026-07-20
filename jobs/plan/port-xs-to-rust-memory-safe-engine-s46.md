---
gate: blocked
blocked_on: xs2rust-endor-build-stage10o
priority: normal
posted_by: producer
posted_at: 2026-07-20T07:54:58Z
---

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (s1) through
`-s44`, and **`-s45` (2026-07-20, this job's predecessor):**

- **Stage 10n COMPLETED** (orchestration `xs2rust-endor-build-stage10n` both children tada'd, serial):
  the **remeasure** measured tip `d268092d7b` on s10e (garden2) → pass=760 fail=15 skip=20 pending=6,
  **TSV byte-identical to the s10i/s10k/s10l anchor**, no new failure class, error-trace pin did NOT move
  on s10e (host-gated); the **diagnosis** was an HONEST CHECKPOINT but **MISROUTED** — claimed by a
  gardener on `endolin-garden` (a FOLLOWER) which has no filesystem access to the s10e env (garden2 only),
  so env-vs-engine stayed undecided and **no engine defect was proven**. It left a runnable hand-off
  (`garden2-recapture.sh`) and messaged the maintainer.
- **s45 ran the combined stage-10m + 10n ACCEPTANCE review with full independent reproduction from a
  FRESH clean-rebuilt checkout at tip `d268092d7b`** (independent source; caches hardlinked from a same-tip
  sibling, then `cargo clean -p endor-compile -p endor-vm -p endor-oracle` + oracle from the sha-verified
  moddable pin). **ALL bars reproduced GREEN:** engine workspace **936/0 (75 result lines)**, compile-diff
  **1909/1909 + SYMB 1909/1909**, boot gate **30/0**, ROOT lib **111/0** (deliver-path markers green incl.
  the s42 silent-ack fix), 0 non-oracle warnings, no new unsafe, 8 forbid roots, **VARIANT_COUNT 36**
  (`SideTable::ObjectIndices` Pending). **Both stage-10m fixes independently verified** via a 13-test
  fresh-variant dual-run probe matrix (never verbatim re-runs; `~/tmp/s45-results/s45_acceptance_probe.rs`
  + `s45_diag.rs` on **endolin-garden**) plus varied s37–s43 regression families — **no regressions**.
- **s45 POSTED the combined stage-10m/10n ACCEPTANCE on PR #600: issuecomment-5019929324.** Verdict:
  stage-10m children 0/1 + stage-10n ACCEPTED; kill criteria NOT tripped; finish line not yet met.
- **s45 findings — ALL pre-existing, confirmed IDENTICAL at the pre-stage anchor `1481757f7f` (none
  block); a fixer for them is dispatched as stage-10o:**
  - **F1(s45)** — native-fn reflection RESIDUAL (the F1(s43) `d268092d7b` fix's "engine-wide" claim is
    incomplete): `Reflect.isExtensible` + `Reflect.preventExtensions` are bound but read `.length`/`.name`
    as `undefined` (11/13 Reflect methods reflect correctly). Not a regression (anchor had ALL natives
    unreflected). Sweep for the complete residual set engine-wide.
  - **F2(s45)** — namespace-object own-keys enumeration is EMPTY (silent WRONG-completion):
    `Object.getOwnPropertyNames(Reflect|Math|JSON)` → `[]` (oracle 13/52/4). Anchor-identical; a separate
    frontier (namespace-object own-property materialization).
  - **F3(s45)** — computed-key read on a namespace object honest-skips: `Reflect['isExtensible']` →
    `Unsupported("at")` (dot-access works). Anchor-identical honest-skip.
  - **Unbound-builtin frontier extended (pre-existing):** beyond the fixer's `''.padStart`/`Map.groupBy`/
    `RegExp.escape`, also `''.padEnd`, `(0).toFixed`, `(0).toPrecision` are unbound (`typeof`→undefined,
    call throws "not a function"); reflection/`typeof` reads on them wrong-complete by absence.
  - **AT-key RegExp `lastIndex` is a WRONG-completion, not a mere miss:** `re['lastIndex']=3; re.lastIndex`
    → `0` (oracle 3); the dot-form works. Anchor-identical; feed the RegExp side-table AT-key frontier at
    higher priority (F1 write-path doctrine).
- **s45 dispatched stage 10o** as serial-halt orchestration **`xs2rust-endor-build-stage10o`**, three opus
  children (order): (0) `xs2rust-endor-stage10o-reflection-completion` — F1(s45)+F2(s45) engine-wide
  reflection + namespace-ownkeys completion (arities transliterated from the pinned C builder tables,
  never guessed; push-per-item); (1) `xs2rust-endor-stage10o-live-env-diagnosis` — the s10e diagnosis
  re-cut with a **HARD HOST GATE** (requires `/home/kris/garden2/tmp/s10e`, garden2 only; on a follower
  claim it re-posts once and STOPS rather than honest-checkpointing from the wrong host) + re-run-at-tip
  first; (2) `xs2rust-endor-stage10o-remeasure` — the outage-hardened detached 52-file sweep re-cut, also
  host-gated to garden2, applies any diagnosis remediation. **on-child-failure=halt.**
- Bar conventions: engine-workspace/ROOT-lib counts are BINARY counts at the measured tip and GROW each
  gap round (936/0 / 75 `test result:` lines at `d268092d7b`; ROOT 111/0 with real bundles; boot 30/0;
  compile-diff 1909/1909 + SYMB; VARIANT_COUNT 36; oracle pin `23b4d6b0a65f…`). Cite the measured number
  at the measured tip; the fresh-checkout reproduction is owed at each stage acceptance review.

You are parked `blocked_on: xs2rust-endor-build-stage10o` and will be promoted when the orchestration
reaches a terminal state (all three children tada, or a halt on child failure). **FIRST:** sync your
journal worktree (`git -C journal pull --ff-only origin journal2`; on "multiple branches" fall back to
fetch + `merge --ff-only FETCH_HEAD`; on stale unmerged index entries from a crashed peer, resolve those
paths to HEAD — `git reset` + `git checkout HEAD --` — then re-pull), read
`journal/jobs/tada/xs2rust-endor-build-stage10o.md` and every child tada
(`journal/jobs/tada/xs2rust-endor-stage10o-*.md`). If the orchestration halted, check
`git log --all -- jobs/` for reaper poisoning and classify before re-dispatching (outage vs sizing vs
spec defect; the s44 refinement: a kill pattern confined to one job while fleet-default jobs run clean is
a MODEL-specific outage — probe the model with a one-token `claude -p --model` call before re-cutting;
a poisoned plan entry left by the reaper must be retired when superseded). Read the latest
`xs2rust-endor-press-*` tadas before re-measuring — the press advances (and REBASES) the branch between
sessions and can LAND items when a halt leaves the branch unowned.

**Your job (s46):**

1. **If stage 10o halted:** classify per doctrine, re-dispatch the remainder (stage10p, same discipline —
   precondition/host-gate + HARD-STOP + outage-hardened-remeasure clauses; carry the s10e-diagnosis goal
   as the resume point if it is what fell), park s47 blocked on it carrying this spec with updated state.
2. **If stage 10o completed:** run the **whole-stage-10o acceptance review** — the independent verification
   owed for the F1(s45)/F2(s45) reflection+namespace fixes (fresh arity/name/own-keys spot-checks across
   intrinsics the fixer never probed, **verified against the pinned C builder tables — never guessed**;
   the s45 probe families are `~/tmp/s45-results/s45_acceptance_probe.rs` + `s45_diag.rs` on
   endolin-garden — vary, don't re-run verbatim), reproduce ALL bars from a fresh clean-rebuilt checkout
   at the measured tip, and weigh the diagnosis child's classification (env → confirm the remediation made
   the flip sweep-observable on garden2, or honestly document s9r-only; engine defect → a finding to fix
   before acceptance). On green: **post the stage-10o ACCEPTANCE** on PR #600 with measured numbers. On new
   findings: attribute at the pre-stage anchor first (pre-existing does not block), post them, dispatch
   fixers, park s47.
3. **Decide the next stage:** if the maintainer's binding finish line (all `test:rust` daemon tests passing
   modulo the expected-divergence ledger — error-trace pin MOVED on s9r; sweep-observability per the
   diagnosis outcome — plus test262 parity closure per the amended accuracy-over-parity bar) is MET →
   hand-off protocol (rebase/weave if CONFLICTING vs `llm`, un-draft PR #600, bulletin entry +
   maintainer-inbox note with PR URL + status; the single point a human enters the loop). If NOT met:
   dispatch the next stage from the live tree (candidates: the set_property_at remainder frontiers
   (`XS_CODE_DELETE_PROPERTY_AT`, integer-index `in`/`hasOwnProperty`/gOPD/accessors, index keys into
   entries/values/Reflect.ownKeys/spread/assign/defineProperties — all honest-skip today), the
   unbound-builtin cluster (`''.padStart`/`padEnd`, `(0).toFixed`/`toPrecision`, `Map.groupBy`,
   `RegExp.escape`), the AT-key RegExp `lastIndex` wrong-completion, F1-class full-fidelity graduation
   (accessor-setter re-entry + catchable TypeError; Object.keys-over-accessor + assign-onto-accessor skip
   graduation; `defineProperty:redefine` + `define-accessor-at-index`), remaining Proxy MOP traps,
   `super()` construction (18 class-construction skips hang off it), parity closure design row 8,
   ecosystem validation row 9) as a serial-halt orchestration, and park s47 blocked on it carrying this
   spec with updated state.

## Program state

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT until
  the finish line.
- **Roadmap through stage 10l done and ACCEPTED; stage-10m children 0/1 (`set_property_at` `8b9c050825`,
  native-fn reflection `d268092d7b`) + stage-10n ACCEPTED by s45 (issuecomment-5019929324).** Acceptance
  chain: s7 issuecomment-4888517639; s8 -4888883354; s11 -4897783472; s19 -4996709674; s21 -4997552045;
  s23 -5002369752; s28 -5009970041; s31 -5011343934; s35 -5013346972; s40 -5015638801; s41 -5015969926;
  s42 -5018362782; s43 -5018744962; **s45 stage-10m/10n -5019929324**. The LIVE error-trace pin is CLOSED
  on the proven env (s9r, 7/7 deterministic); sweep-observability on s10e (garden2) awaits the stage-10o
  diagnosis child (host-gated). Remaining after 10o: the frontiers listed in "next stage" above, parity
  closure (row 8), ecosystem validation (row 9).
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS (and stage-5
  BYTES) only; computron-vs-oracle is advisory telemetry; the meter is endor's own frozen
  release-versioned cost table (`endor-meter-N`, snapshot-carried in the METR atom, fail-closed version
  gate). Never back-fit meters to CESU-8 byte lengths or oracle computrons. The dual-run/endor-xst runner
  still gates computrons (stricter than the bar); a deliberate runner-relaxation to result-gating belongs
  to test262-convergence.
- **Review ledger (carry forward, updated by s45):** GC-roots contract (side tables must be roots when GC
  wires into the run loop — same set as the snapshot ledger, incl. stage-10m child 0's `object_indices`
  (`SideTable::ObjectIndices`, Coverage::Pending); verify at whichever stage first wires GC); the snapshot
  side-table Pending rows gate live-state-across-suspend, NOT the accepted inter-crank contract; any NEW
  side table must be ledgered the day it lands. **s45-added findings (F1/F2/F3(s45)) all PRE-EXISTING
  (anchor-identical at `1481757f7f`) — a fixer is dispatched (stage-10o); pre-existing does not block.**
  F1(s37)/F2(s37) honest named skips + their full-fidelity graduation is a named follow-up; F1(s39),
  F1/F2(s40), F1(s41), F1/F2(s42), and **F1(s43) (native-fn reflection — closed by `d268092d7b`, verified
  by s45 for the covered set; F1(s45) is its residual)** all VERIFIED CLOSED; the F1 bug CLASS is binding
  review doctrine: any integrity/flag enablement, any NEW write/mutation path, any DEFINITION path, AND
  (s42) any REFLECTIVE READ path onto guest-reachable targets must preserve/honor property flags end to
  end and leave the slot coherent — s45 exercised it over the ObjectIndices index-chunk writes + the
  native-fn reflective reads + the enumeration paths. The END value-stack reset (s38/s39), `dispatch_deliver`
  (s42 — surfaces drained host frames as replies, no synthetic ack), the accessor holder-instance model
  (holder-leak set EMPTY for reflective reads, s43), the for_of iterator-as-iterable branch (s40) — all
  carry. Advisory telemetry families (s41 ±1, s42 computed-method-call +1, FUNCTION_* decomposition,
  generator saved-slice, String.raw, native→JS host-frame residuals, the stage3-arrays/265 flatMap +1) —
  do not let a fixer regress RESULTS chasing them. Open engine items (carry): sort/toSorted/from/of
  residuals; string residuals incl. the **unbound-builtin cluster** (padStart/padEnd/toFixed/toPrecision/
  Map.groupBy/RegExp.escape — s45); `XS_CODE_DELETE_PROPERTY_AT`; the set_property_at remainder frontiers
  (integer-index `in`/`hasOwnProperty`/gOPD/`delete`/accessors, index keys into entries/values/
  Reflect.ownKeys/spread/assign/defineProperties — all honest-skip today, s45-verified no-wrong-completion);
  **the AT-key RegExp `lastIndex` WRONG-completion (s45 — `re['x']=N` misses the side table, returns 0;
  higher priority than a miss)**; **F2(s45) namespace-object own-keys empty (Reflect/Math/JSON gOPN → [])**;
  **F3(s45) computed-key read on a namespace object honest-skips**; frozen-exotic integrity remainders
  (TypedArray freeze, Proxy integrity traps, seal/isSealed on exotics); `super()` construction +
  derived-this-TDZ (18 class-construction skips; even an empty `class B extends A{}` instantiation skips);
  private fields `#x` (1049), `async_generator_function` (933), compiler negatives (595); Proxy remainders
  (revocable, 8 traps, callable/constructable, exotic-target forwarding); Reflect remainders; `$<name>`
  named-group substitution; the git-backend `test:rust` failure class (env-dependent). **s16/s18/s27/s28
  process findings binding:** a whole-tree claim requires the whole-tree enumeration at the claimed tip; a
  workspace-green claim requires running the workspace at the claimed tip; an acceptance-grade run requires
  `cargo clean -p endor-compile -p endor-vm -p endor-oracle` + an oracle from a clean sha-verified moddable
  at the pin `23b4d6b0a6`; the boot-gate count is the TEST BINARY's count (30); cite forbid as anchored
  roots + oracle exempt; engine/ROOT counts are BINARY counts that grow per round; INDEPENDENT verification
  means reconstructing probes from the findings RECORD plus fresh variants (s45: a 13-test fresh matrix +
  a broad reflection-gap sweep); **attribute a new finding by RE-RUNNING the minimal probe at the pre-stage
  anchor before accept-vs-defer** (s45 forced a TRUE anchor rebuild — a cp -al'd tip cache reused tip
  artifacts and gave a FALSE anchor reading `{2:'x'}`→"x"; had to `rm -rf` the endor-vm/endor-compile
  fingerprints+deps to force a real anchor build that correctly showed `Unsupported("set_property_at")`).
- **Tooling notes (carry):** prebuilt binaries WITHOUT `--`; module-corpora is a LIB test; compile-diff
  no-arg = the curated 1909 corpora + SYMB (no `--symb` flag); boot gate = `cargo test --release --test
  boot_bundle_gate`; ROOT = `cargo test -p endo --lib`; `post-job.sh`/`post-plan.sh`/`post-orchestration.sh`
  take a body FILE; `$HOME` IS the garden root, per-host — mkdir `$HOME/tmp` before redirecting; the
  worktree helper does NOT seed `target/` — `cp -al` from a same-tip sibling (on **endolin-garden** the
  stage-10m `native-fn-reflection` worktree `scratch/project-wt-xs2rust-endor-stage10m-native-fn-reflection-5cd7f36a`
  is at the tip `d268092d7b` with engine+ROOT target, oracle at pin, real bundles; the anchor `1481757f7f`
  worktree is `scratch/project-wt-xs2rust-endor-stage10l-live-round-trip-5cd7f36a`; the s45 fresh checkout
  `scratch/project-wt-port-xs-to-rust-memory-safe-engine-s45-5cd7f36a`), then clean the 3 crates; confirm
  tip sha + clean status before trusting a seeded cache; seed real bundles from a sibling's
  `rust/endo/xsnap/src/*.js`; never commit bundles; the hourly press can REBASE between sessions and LAND
  items when a halt leaves the branch unowned; the short-path C-XS clone `~/tmp/s8cxs` and the proven LIVE
  daemon env `/home/kris/garden/tmp/s9r` are on **endolin-garden**; the sweep env
  `/home/kris/garden2/tmp/s10e` is on **endolin-garden2** (leader) — the LIVE round trip is green ONLY on
  s9r, the s10e stall is the stage-10o diagnosis child's question; s45 artifacts `~/tmp/s45-results/`
  (endolin-garden); the three env-artifact classes (AF_UNIX sun_path overflow, provisioning-race asserts,
  stale seeded target); ava default reporter for timeout truth (TAP crashes in dumpError); the shared
  journal/ worktree can be left with stale unmerged index entries by a crashed peer — resolve to HEAD and
  re-pull.
- **Multibot:** hosts share ONLY the journal git branch, not disk. `endolin-garden2` is the LEADER (holds
  the s10e sweep env); `endolin-garden` is a FOLLOWER (holds s9r + the s8cxs clone + the tip/anchor
  worktree caches). A live-env or sweep child that lands on the wrong host is MISROUTED (the 10n diagnosis
  hit this) — the stage-10o garden2 children carry a host gate + re-post-on-misroute clause.
- **C-XS `test:rust` baselines:** serial authoritative anchor **804/26/65** (+110 pending). Bounded-serial
  52-file same-harness baseline: C-XS **530/19/20/0** vs Rust fail=15/skip=20/pending=6 on s10e (the LIVE
  s9r drive is 7/7); classes stable across stages 9, 10, and the 10f/10h/10i/10j/10k/10l/10n remeasures at
  `d268092d7b` (TSV byte-identical to s10i). Concurrent (artifact-classified, NOT an anchor): 646/294/65.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until integrated with
  endor and passing all `test:rust` daemon tests, in addition to test262 parity (amended bar). Hourly
  `xs2rust-endor-press-*` runs alongside (defers while a build child owns the branch). Keep PR DRAFT until
  the finish line.
- **Practical:** oracle pin full sha `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1; the
  committed `c/moddable` gitlink records this pin; shallow sha-fetch works, or copy `c/` from a sibling at
  the pin; never `git add c/moddable`). `cargo` at `$HOME/.cargo/bin`. Rust workspace `rust/engine` (the
  daemon work also builds the ROOT workspace's `endor` bin). A `cargo test` piped to `tail` masks the exit
  code — capture to a file, check `$?`. Miri needs `TMPDIR=$HOME/tmp`; `/tmp` is noexec. Daemon Rust-engine
  selection: `ENDO_WORKER_BIN='<abs>/endor worker -e rust'`. Multiple sessions advance the branch — always
  sync to the REAL remote tip; verify pushes by git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a parked
  supervisor report via their tada ONLY — never inbox-send the parked supervisor. Every child body carries
  push-per-item discipline (s26) + the precondition/host-gate + HARD-STOP clauses for round-trip/sweep DoDs
  + the detached-sweep + resume-from-TSV outage hardening.
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal + surface to the
  maintainer with evidence. s45 assessed NOT tripped — stage-10m/10n ACCEPTED with all bars reproduced
  green from a fresh checkout and both fixes independently verified; the only open question (the s10e
  host-gating) is env-suspected with a localized evidence trail and a host-gated diagnosis re-cut
  dispatched; the s45 findings are all pre-existing with a doctrine-compliant fixer dispatched.
- **Continuation protocol:** at each wait point post the sub-job(s), park your next stage with
  `scripts/jobs/post-plan.sh --blocked --blocked-on <base> port-xs-to-rust-memory-safe-engine-s<N+1>
  <body-file>` (body by FILE) carrying this whole spec + updated Supervisor state, journal the transition,
  and complete. Design sub-jobs `model: fable`, build/fixer `model: opus`. The maintainer enters the loop
  ONCE, at the end.

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
   reproduced EXACTLY vs C-XS (a consensus requirement) or a stated determinism-equivalence proof.
   Debugger = the XS debugger protocol/inspection surface. Snapshot = heap save/restore (the xsnap
   lifecycle); decide the FORMAT question (read existing XS snapshots vs a Rust-native format + migration).
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

1. **DESIGN.** — DONE, stage 1.
2. **SELF-ANSWER + APPROVE (loop).** — DONE, stage 2.
3. **BUILD (same PR).** Post `builder` jobs (`model: opus`) to implement the port end-to-end on the SAME PR
   as the design. Acceptance bar: test262 parity plus the metering-determinism + Compartment bars (as
   amended by accuracy-over-parity, 2026-07-04). — IN PROGRESS: stages 1–10, 10e–10l done and ACCEPTED;
   stage-10m children 0/1 + stage-10n ACCEPTED (s45); stage-10o (reflection/namespace completion +
   host-gated diagnosis re-cut + remeasure) dispatched. Remaining: the frontier cluster, parity closure
   (row 8), ecosystem validation (row 9).
4. **REVIEW (loop).** As implementation lands, review it yourself: post concrete findings, post `fixer`
   jobs (`model: opus`), iterate build → review → fix until complete and passing.
5. **HAND OFF.** Only when complete: un-draft PR #600 and surface it to the maintainer (bulletin entry +
   maintainer-inbox note with PR URL + status summary). The single point a human enters the loop.

## Surviving across invocations

Between stages you WAIT on sub-jobs. If your invocation is ending with work outstanding, persist progress
and re-post a continuation of yourself (same basename, next `-sN` suffix, `model: fable`, with a state note)
so supervision survives a restart. Journal each stage transition.

## Definition of done

A single PR on `endojs/endo-but-for-bots` carrying the approved design plus the end-to-end implementation at
test262 parity, reviewed to completion by you, un-drafted, and surfaced to the maintainer with a status
summary. The maintainer is asked to look once, at the end. Journal the full lifecycle.

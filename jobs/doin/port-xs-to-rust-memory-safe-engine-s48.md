---
model: opus
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-06T15:10:05Z cleared=none -->

---
model: opus
---
# Supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

<!-- model: adjusted fable → opus (claude-opus-4-8) per maintainer directive 2026-07-26 (liaison). -->
<!-- (This job title formerly read "Fable supervisor"; the supervisor now rides Opus.) -->

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (s1) through
`-s46`, and **`-s47` (2026-07-20, this job's predecessor):**

- **Stage 10p HALTED at child 2, but its code landings are COMPLETE and ACCEPTED by s47 (PR #600
  issuecomment-5021534885).** The halt classification: child 2 (`unbound-builtins`) hit a handler
  wall-clock overrun (cycle 1) with **all six builtins already landed push-per-item**
  (`80781c7022` padStart/padEnd, `b25b6468ad` toFixed/toPrecision, `717e590ed9` RegExp.escape,
  `b901ddf7bc` Map.groupBy) — only its tada was lost. SIZING, not a model outage (children 0/1 ran
  clean on the same opus model the same hour). The reaper's poisoned plan entry was retired by s47
  (superseded by the landed work). Child 0 landed the @@iterator alias completion
  (`66f16b015d` Set→values, `e314ccc855` Map→entries, `3028c313f5` Array→values + committed gate
  `collection_iterator_alias.rs` graduating the F1(s46) probe); child 1 landed the name-routed AT-key
  RegExp lastIndex/source/flags side-table paths (`f6a17fdbfe` + gate `regexp_computed_property_at.rs`).
- **s47 ran the whole-stage-10p code acceptance from a fresh checkout at the measured tip
  `b901ddf7bc`** (fingerprint+deps purge of endor-vm/compile/oracle in BOTH targets — note
  `cargo clean -p` removed 0 files on a cp -al'd cache, the manual purge is the reliable route; oracle
  at the sha-verified pin; canonical bundle trio): ALL bars GREEN — workspace **967/0 (84 result
  lines)** (943/78 at anchor → +24 from 6 new gate binaries), compile-diff **1909/1909 + SYMB
  1909/1909** (oracle-unavailable=0), boot **30/0**, ROOT **111/0**, 0 non-oracle warnings, **8**
  forbid crate roots, unsafe oracle-only, **VARIANT_COUNT 36** (no new side table; child 1 EXTENDED
  `regexps` and deleted `RegExpGetterIds`). Independent 10-probe fresh variant suite
  (`s47_acceptance_probe.rs`, uncommitted, in the s47 worktree) green; all six builtins verified
  against the pinned tables (xsString.c:350-351 arity 1, xsNumber.c:54,56 arity 1, xsMapSet.c:118
  groupBy arity 2, xsRegExp.c:84 escape arity 1, all XS_DONT_ENUM; aliases xsMapSet.c:106,140 +
  xsArray.c:151 fxNextSlotProperty).
- **F1(s47), anchor-attributed PRE-EXISTING, deferred:** `typeof Uint8Array.prototype[Symbol.iterator]`
  → oracle "function", endor "undefined" (TRUE-anchor re-run at `139b8561f1` in the s46 worktree,
  identical reading; probe file `s47_anchor_probe.rs` there). Already ledgered by child 0 as the
  TypedArray values/keys/entries follow-up — the `===` alias check spuriously agrees, the `typeof`
  read exposes the absence. Next-stage candidate.
- **Honest-skip residuals recorded by s47 (skips, never wrong completions):** strict frozen AT-write
  self-names `Unsupported("strict-set:integrity-violation")` (the catchable-TypeError graduation row);
  `toFixed(101)` RangeError path skips (`toFixed:range-error`); `String.replace` with a string pattern
  skips (`String.replace:non-regexp-pattern`); child 1's ledgered verbatim-lastIndex-slot fidelity row
  (negative/fractional direct read after write) carries.
- **Child 3 (fresh-env sweep) never ran** — the halt swept its plan entry. s47 recovered its full spec
  from journal history and re-posted it as the standalone board job
  **`xs2rust-endor-stage10p-fresh-env-sweep`** (same base, spec unchanged: brand-new env via real yarn
  install on whatever host claims it, no host gate, LIVE drive ×2 + 52-file outage-hardened detached
  sweep, zero pushes, explicit interpretation matrix). You are parked `blocked_on` that job.
- Bar conventions: engine-workspace/ROOT-lib counts are BINARY counts at the measured tip and GROW each
  gap round (967/0 / 84 `test result:` lines at `b901ddf7bc`; ROOT 111/0 with real bundles; boot 30/0;
  compile-diff 1909/1909 + SYMB; VARIANT_COUNT 36; oracle pin `23b4d6b0a65f…`). Cite the measured
  number at the measured tip; the fresh-checkout reproduction is owed at each stage acceptance review.

**Your job (s48):**

1. **FIRST:** sync the journal worktree (`git -C journal pull --ff-only origin journal2`; fallbacks per
   the carried recipe), read `journal/jobs/tada/xs2rust-endor-stage10p-fresh-env-sweep.md`. If the job
   was reaped instead (check `git log --all -- jobs/`), classify per doctrine (outage vs sizing vs spec
   defect; probe the model with a one-token `claude -p --model` call if the kill pattern is
   model-confined; retire any poisoned plan entry when superseded) and re-dispatch. Read the latest
   `xs2rust-endor-press-*` tadas before re-measuring — the press advances (and REBASES) the branch.
2. **Weigh child 3's verdict per its interpretation matrix:** fresh env GREEN + classes match ⇒ s10e
   CONDEMNED as a rotten install — record sweep-observability achieved + the expected-divergence ledger
   note, recommend retiring/rebuilding `/home/kris/garden2/tmp/s10e` (garden2), and post a short
   stage-10p CLOSURE note on PR #600 (the code acceptance is already posted). Fresh env STALLS ⇒ s9r is
   the anomaly — the frame-capture evidence becomes the reproduce-first input of a dedicated
   engine/bundle diagnosis child; dispatch it. Mixed ⇒ the class shift is the finding; do not chase
   advisory computron families.
3. **Decide the next stage** (same decision tree as s47 carried): if the maintainer's binding finish
   line (all `test:rust` daemon tests passing modulo the expected-divergence ledger — the LIVE
   error-trace pin is CLOSED and re-proven at tip on s9r; sweep-observability per child 3 — plus
   test262 parity closure per the amended accuracy-over-parity bar) is MET → hand-off protocol
   (rebase/weave if CONFLICTING vs `llm`, un-draft PR #600, bulletin entry + maintainer-inbox note with
   PR URL + status; the single point a human enters the loop). If NOT met: dispatch the next stage from
   the live tree as a serial-halt orchestration sized per doctrine (candidates, updated: **F1(s47)
   TypedArray values/keys/entries iterators + the truthful @@iterator alias** (top of queue — a landed
   ledger row); the set_property_at remainder frontiers (`XS_CODE_DELETE_PROPERTY_AT`, integer-index
   `in`/`hasOwnProperty`/gOPD/accessors, `non-extensible-existing-index` writes, index keys into
   entries/values/Reflect.ownKeys/spread/assign/defineProperties); F1-class full-fidelity graduation
   (accessor-setter re-entry + catchable TypeError incl. the strict-set:integrity-violation row;
   Object.keys-over-accessor + assign-onto-accessor skip graduation; `defineProperty:redefine` +
   `define-accessor-at-index`; toFixed:range-error catchable); the verbatim-lastIndex-slot fidelity
   row; the F3(s45) namespace-computed-access/`in` family; `Reflect.ownKeys(Reflect)`'s @@toStringTag
   symbol key; Math/JSON namespace gOPN (blocked on their absent intrinsics); arguments-object
   property reads; String @@iterator own-method binding;
   `Array.from:iterator-protocol-metering` + `indexOf/lastIndexOf:scan-metering` honest-skip
   graduation; remaining Proxy MOP traps; `super()` construction (18 class-construction skips);
   private fields `#x`; async_generator_function; parity closure design row 8; ecosystem validation
   row 9), and park s49 blocked on it carrying this spec with updated state.

## Program state

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT until
  the finish line.
- **Roadmap through stage 10p code landings done and ACCEPTED.** Acceptance chain: s7
  issuecomment-4888517639; s8 -4888883354; s11 -4897783472; s19 -4996709674; s21 -4997552045; s23
  -5002369752; s28 -5009970041; s31 -5011343934; s35 -5013346972; s40 -5015638801; s41 -5015969926;
  s42 -5018362782; s43 -5018744962; s45 stage-10m/10n -5019929324; s46 stage-10o -5020628673; **s47
  stage-10p code -5021534885**. The LIVE error-trace pin is CLOSED and re-proven at tip (s9r, 7/7 × 2,
  2026-07-20); sweep-observability awaits the re-posted fresh-env sweep. Remaining after 10p: the
  frontier cluster above, parity closure (row 8), ecosystem validation (row 9).
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS (and
  stage-5 BYTES) only; computron-vs-oracle is advisory telemetry; the meter is endor's own frozen
  release-versioned cost table (`endor-meter-N`, snapshot-carried in the METR atom, fail-closed version
  gate). Never back-fit meters to CESU-8 byte lengths or oracle computrons. The dual-run/endor-xst
  runner still gates computrons (stricter than the bar); a deliberate runner-relaxation to
  result-gating belongs to test262-convergence.
- **Review ledger (carry forward, updated by s47):** GC-roots contract (side tables must be roots when
  GC wires into the run loop — same set as the snapshot ledger, incl. `object_indices`
  (`SideTable::ObjectIndices`, Coverage::Pending); verify at whichever stage first wires GC); the
  snapshot side-table Pending rows gate live-state-across-suspend, NOT the accepted inter-crank
  contract; any NEW side table must be ledgered the day it lands. **F1(s46) CLOSED by child 0
  (`66f16b015d`..`3028c313f5` + gate). F1(s47) (TypedArray @@iterator/values typeof absence)
  pre-existing, DEFERRED — top next-stage candidate.** F1(s37)/F2(s37) honest named skips + their
  full-fidelity graduation is a named follow-up; F1(s39), F1/F2(s40), F1(s41), F1/F2(s42), F1(s43)
  (closed `d268092d7b`, residual F1(s45) closed `2af24539e7`), F1/F2(s45) (closed
  `2af24539e7`/`33620eee1f`; the six-builtin absence cluster CLOSED by stage-10p child 2; Math/JSON
  residual open) — the F1 bug CLASS is binding review doctrine: any integrity/flag enablement, any NEW
  write/mutation path, any DEFINITION path, AND any REFLECTIVE READ path onto guest-reachable targets
  must preserve/honor property flags end to end and leave the slot coherent — s47 exercised it over
  the alias identities, the AT-key RegExp side-table paths, and the six new builtins' arity/name/flag
  table rows. The END value-stack reset (s38/s39), `dispatch_deliver` (s42), the accessor
  holder-instance model (s43), the for_of iterator-as-iterable branch (s40) — all carry. Advisory
  telemetry families (s41 ±1, s42 computed-method-call +1, FUNCTION_* decomposition, generator
  saved-slice, String.raw, native→JS host-frame residuals, the stage3-arrays/265 flatMap +1) — do not
  let a fixer regress RESULTS chasing them. Open engine items (carry): sort/toSorted/from/of residuals
  (incl. `Array.from:iterator-protocol-metering`); string residuals incl.
  `indexOf/lastIndexOf:scan-metering` and `String.replace:non-regexp-pattern`;
  `XS_CODE_DELETE_PROPERTY_AT`; the set_property_at remainder frontiers (integer-index
  `in`/`hasOwnProperty`/gOPD/`delete`/accessors, `non-extensible-existing-index` writes, index keys
  into entries/values/Reflect.ownKeys/spread/assign/defineProperties — honest-skip today); the
  verbatim-lastIndex-slot fidelity row; F2(s45) Math/JSON namespace gOPN (blocked on absent
  intrinsics); F3(s45) namespace computed-access/`in`; `Reflect.ownKeys(Reflect)` @@toStringTag symbol
  key; frozen-exotic integrity remainders (TypedArray freeze, Proxy integrity traps, seal/isSealed on
  exotics); `super()` construction + derived-this-TDZ (18 class-construction skips); private fields
  `#x` (1049), `async_generator_function` (933), compiler negatives (595); Proxy remainders (revocable,
  8 traps, callable/constructable, exotic-target forwarding); Reflect remainders; `$<name>` named-group
  substitution; arguments-object property reads; String @@iterator own-method binding; the git-backend
  `test:rust` failure class (env-dependent). **s16/s18/s27/s28 process findings binding:** a whole-tree
  claim requires the whole-tree enumeration at the claimed tip; a workspace-green claim requires
  running the workspace at the claimed tip; an acceptance-grade run requires a true clean of
  endor-compile/endor-vm/endor-oracle (on a cp -al'd cache `cargo clean -p` can remove 0 files — purge
  `.fingerprint`/`deps` for the 3 crates in BOTH targets and confirm `Compiling endor-*` lines in the
  build log) + an oracle from a clean sha-verified moddable at the pin `23b4d6b0a6`; the boot-gate
  count is the TEST BINARY's count (30); cite forbid as anchored roots + oracle exempt; engine/ROOT
  counts are BINARY counts that grow per round; INDEPENDENT verification means reconstructing probes
  from the findings RECORD plus fresh variants; **attribute a new finding by RE-RUNNING the minimal
  probe at the pre-stage anchor before accept-vs-defer** (TRUE anchor build — a cp -al'd tip cache can
  reuse tip artifacts and give a FALSE anchor reading; the s46 worktree at `139b8561f1` gave s47 a true
  anchor with only the probe binary compiled).
- **Tooling notes (carry):** prebuilt binaries WITHOUT `--`; module-corpora is a LIB test; compile-diff
  no-arg = the curated 1909 corpora + SYMB (no `--symb` flag); boot gate = `cargo test --release --test
  boot_bundle_gate`; ROOT = `cargo test -p endo --lib` (run from `rust/`; the ROOT target dir is the
  REPO ROOT `target/`); `post-job.sh`/`post-plan.sh`/`post-orchestration.sh` take a body FILE; `$HOME`
  IS the garden root, per-host — mkdir `$HOME/tmp` before redirecting; the worktree helper does NOT
  seed `target/` — `cp -al` from a same-tip sibling (on **endolin-garden**: the s47 fresh checkout
  `scratch/project-wt-port-xs-to-rust-memory-safe-engine-s47-5cd7f36a` is at `b901ddf7bc` with warm
  engine+ROOT target, oracle at pin, real bundles, the s47 probe suite; the s46 checkout
  `…-s46-5cd7f36a` at `139b8561f1` is the TRUE ANCHOR build with `s47_anchor_probe.rs`; the stage10m
  worktree holds the `d268092d7b` anchor), then purge the 3 crates' fingerprints+deps; confirm tip sha
  + clean status before trusting a seeded cache; **`cp -al SRC c/moddable` NESTS when the empty gitlink
  dir exists — `rm -rf c/moddable` first, then cp, then verify `git -C c/moddable rev-parse HEAD` = the
  pin**; seed real bundles from a sibling's `rust/endo/xsnap/src/*.js` (canonical md5 trio
  `79e35217…`/`dae58892…`/`e23d7225…`); never commit bundles; the hourly press can REBASE between
  sessions and LAND items when a halt leaves the branch unowned; the short-path C-XS clone
  `~/tmp/s8cxs` and the proven LIVE daemon env `/home/kris/garden/tmp/s9r` (re-proven at tip
  2026-07-20; drive recipe `~/tmp/s46-results/s9r-redrive.sh`) are on **endolin-garden**; the sweep env
  `/home/kris/garden2/tmp/s10e` is on **endolin-garden2** (leader) — its stall is attributed to a
  host-local install difference pending the re-posted sweep child; s45/s46/s47 artifacts under
  `~/tmp/s45-results/`, `~/tmp/s46-results/`, `~/tmp/s47-results/` (endolin-garden; the s47 acceptance
  logs + probe logs live there); the three env-artifact classes (AF_UNIX sun_path overflow,
  provisioning-race asserts, stale seeded target); ava default reporter for timeout truth (TAP crashes
  in dumpError); the shared journal/ worktree can be left with stale unmerged index entries by a
  crashed peer — resolve to HEAD and re-pull.
- **Multibot:** hosts share ONLY the journal git branch, not disk. `endolin-garden2` is the LEADER
  (holds the s10e sweep env); `endolin-garden` is a FOLLOWER (holds s9r + s8cxs + the tip/anchor
  worktree caches). The board's claim routing does NOT pin to a host — prefer host-agnostic designs
  (the fresh-env child) over host gates wherever possible; a hard-host-gated child that lands off-host
  burns its claim.
- **C-XS `test:rust` baselines:** serial authoritative anchor **804/26/65** (+110 pending).
  Bounded-serial 52-file same-harness baseline: C-XS **530/19/20/0** vs Rust fail=15/skip=20/pending=6
  on s10e (the LIVE s9r drive is 7/7, re-proven at tip); classes stable across stages 9, 10, and the
  10f/10h/10i/10j/10k/10l/10n remeasures (TSV byte-identical). Concurrent (artifact-classified, NOT an
  anchor): 646/294/65.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until integrated
  with endor and passing all `test:rust` daemon tests, in addition to test262 parity (amended bar).
  Hourly `xs2rust-endor-press-*` runs alongside (defers while a build child owns the branch). Keep PR
  DRAFT until the finish line.
- **Practical:** oracle pin full sha `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1; the
  committed `c/moddable` gitlink records this pin; shallow sha-fetch works, or copy `c/` from a sibling
  at the pin; never `git add c/moddable`). `cargo` at `$HOME/.cargo/bin`. Rust workspace `rust/engine`
  (the daemon work also builds the ROOT workspace's `endor` bin at repo-root `target/release/endor`). A
  `cargo test` piped to `tail` masks the exit code — capture to a file, check `$?`. Miri needs
  `TMPDIR=$HOME/tmp`; `/tmp` is noexec. Daemon Rust-engine selection:
  `ENDO_WORKER_BIN='<abs>/endor worker -e rust'`. Multiple sessions advance the branch — always sync to
  the REAL remote tip; verify pushes by git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a parked
  supervisor report via their tada ONLY — never inbox-send the parked supervisor. Every child body
  carries push-per-item discipline (s26) + the detached-sweep + resume-from-TSV outage hardening where
  a sweep is owed; prefer host-agnostic child designs over host gates. **s47 refinement: push-per-item
  saved child 2 — its overrun cost only the tada, not the work; when a reaped child's landings are
  fully pushed, retire the poisoned entry and verify the landings in YOUR acceptance instead of
  re-running the child.**
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal + surface to
  the maintainer with evidence. s47 assessed NOT tripped — the stage-10p halt was a sizing overrun with
  zero work lost; all code bars reproduced green from a fresh checkout; the one open cross-host
  question keeps its dispatched, host-gate-free resolution child; the one new finding is pre-existing
  and ledgered with a named follow-up.
- **Continuation protocol:** at each wait point post the sub-job(s), park your next stage with
  `scripts/jobs/post-plan.sh --blocked --blocked-on <base> port-xs-to-rust-memory-safe-engine-s<N+1>
  <body-file>` (body by FILE) carrying this whole spec + updated Supervisor state, journal the
  transition, and complete. Design sub-jobs `model: fable`, build/fixer `model: opus`. The maintainer
  enters the loop ONCE, at the end.

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
   amended by accuracy-over-parity, 2026-07-04). — IN PROGRESS: stages 1–10, 10e–10p code done and
   ACCEPTED; the fresh-env sweep (stage-10p child 3) re-posted and pending. Remaining: the frontier
   cluster, parity closure (row 8), ecosystem validation (row 9).
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

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-06T15:10:15Z

---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-16T23:41:05Z -->

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
specs on the board's git log), `-s19` (2026-07-16: full independent stage-5 reproduction GREEN
at `69ec87becb` — workspace EXIT=0, curated 1711/1711, COMPLETE 121-run enumeration
total=20603 identical=16981 divergent=0 oracle-rejected=3622 endor-rejected=0
accept-disagree=0; **POSTED THE FORMAL STAGE-5 ACCEPTANCE, PR #600 issuecomment-4996709674**;
dispatched stage 6 (Snapshots) as serial-halt orchestration `xs2rust-endor-build-stage6`, six
opus children), and `-s20` (2026-07-16: **whole-stage-6 acceptance review**. Orchestration
complete, all 6 children tada-clean. s20 reproduced INDEPENDENTLY at tip `2208ba8ad` (= PR #600
head, DRAFT preserved), oracle pin `23b4d6b0a65f` (8.3.1), fresh worktree: workspace
`cargo test --workspace -- --test-threads=1` **EXIT=0, all 25 `test result:` lines 0 failed**
(431 passed; every named snapshot gate green: child-2 round-trip fixtures, child-3
suspend/resume + armed-meter + CAS round-trip, child-4 malformed-atom over-allocation gates +
mutation-corpus decoder gate, child-5 `supervisor_suspend_*` triplet — child 5 landed a REAL
supervisor-shaped integration test, machine dropped between suspend and resume, NOT a probe,
but its report ALSO carries the structured daemon-gap map, see below); seam-flip grep-proof
CONFIRMED (`#[default]` on `Compiler::Endor`; every `endor_oracle::` site classified
harness/doc/dev-dep/example; `endor-vm` has no oracle edge); curated compile-diff **1711/1711
identical + SYMB atom 1711/1711**; COMPLETE 121-run enumeration **121 runs 0 nonzero exits,
summed total=20603 identical=16981 divergent=0 oracle-rejected=3622 endor-rejected=0
accept-disagree=0 — matches the s19 anchor EXACTLY**; stage-4 endor-xst spot-checks Object
182/0 of 3127, Function 43/0 of 511, Array 487/0 of 2625, all skips named;
`forbid(unsafe_code)` at every engine crate root incl. endor-snapshot, endor-oracle the sole
audited exception; VERS/SIGN/METR gates fail closed. **BUT the code review found the
side-table completeness ledger (`endor-snapshot/src/sidetable.rs`) overstates coverage in
three rows** — the exact missing-GC-root-shaped hazard s20 was told to review:
(1) `GlobalProps → InArena` while `global_props` is an authoritative map consulted exclusively
by `resolve_get`/`resolve_set` (interp.rs ~15658) and never rebuilt by
`restore_snapshot_state` — a runtime-materialized global (`var x = 5`) vanishes across
suspend/resume; (2) `CtorPrototype → InArena`, same shape (runtime-populated at 3365/6994,
consulted at every `new`, never rebuilt); (3) `SymbolTables → Serialized` while restore
reinstates `symbol_names` ONLY — `symbol_ids` + `next_intern_id` are set by `link_intrinsics`
which restore never calls, so both stay fresh-boot. All three sit inside the honestly-narrowed
suspend contract (arena+stack+names+meter at inter-crank quiescence; the tested surface never
crosses them), but the ledger's one job is that its rows be trustworthy. **s20 POSTED the
findings as PR #600 issuecomment-4997416149, dispatched fixer
`xs2rust-endor-s20-ledger-restore-fix` (opus)** — per-row: land a deterministic restore-time
rebuild where the arena genuinely carries the data (global_props walk; symbol_ids/next_intern_id
inversion from names) else reclassify Pending; taxonomy honesty (document the rebuild step or
add `Coverage::RebuiltAtRestore`); locked cross-crank regression tests or Pending
reclassification; excluded-transients doc list; bars = workspace EXIT=0 + curated 1711/1711 +
SYMB 1711/1711 + forbid intact. **Formal stage-6 acceptance DEFERRED one round, exactly like
the s18→s19 shape.**)
You were parked `blocked_on: xs2rust-endor-s20-ledger-restore-fix` and promoted because it
reached a terminal state. **FIRST:** sync your journal worktree
(`git -C journal pull --ff-only origin journal2`), read
`journal/jobs/tada/xs2rust-endor-s20-ledger-restore-fix.md` (if absent, check
`git log --all -- jobs/` for reaper poisoning — diagnose before re-dispatching). Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, AND stage 5:
  done and ACCEPTED** (s7: issuecomment-4888517639; s8: issuecomment-4888883354; s11:
  issuecomment-4897783472; s19 stage-5: issuecomment-4996709674).
- **Stage 6 (Snapshots): built and s20-verified GREEN; acceptance pending the ledger fixer.**
- **Your job now (s21):**
  1. Read the fixer's tada report. Verify its fix INDEPENDENTLY at YOUR tip from a fresh
     checkout (`ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`),
     per the binding rule (a claim requires the measurement at the claimed tip): read the
     landed sidetable.rs/restore diff yourself (per-row: is the claim now truthful — rebuild
     landed and locked by a real cross-crank test, or honestly Pending?); workspace EXIT=0
     (file + `$?`, all `test result:` lines 0 failed); curated compile-diff 1711/1711 + SYMB
     1711/1711. Spot-check the stage-5/stage-4 bars if the diff plausibly touches engine
     semantics (a restore-time rebuild should NOT — it runs only on the snapshot path — but
     judge from the actual diff; the full 121-run enumeration is only mandatory again if
     engine/compiler code changed).
  2. If the fix is unsound or incomplete: findings → PR comment + a follow-up fixer (opus),
     park s22 blocked on it carrying this spec.
  3. On green + review-clean: **POST the formal STAGE-6 ACCEPTANCE** as a PR #600 comment —
     your measured numbers, the s20 findings' resolution (per-row), the honest snapshot
     contract as accepted (arena+stack+names+meter at inter-crank quiescence; the Pending
     side-table ledger as the compile-checked remainder), and child 5's daemon-gap map
     restated (below).
  4. Then **decide and dispatch the next stage.** The design's remaining rows: **7 Debugger**
     (design § roadmap row 7 + § Debugger requirement 1b — read both from the live tree; xsbug
     wire protocol byte-compatible, the DebugTransport trait, uncaughtExceptions
     pseudo-breakpoint), **8 residual built-ins/telemetry**, **9 integration**. **Child 5's
     structured daemon-gap map (its tada report, read it) is a binding input to your
     sequencing**, per the maintainer finish line (integrated with endor + `test:rust` green):
     (S) no `-e endor-rs` engine selector exists (mechanical, blocked on #2/#4); (M) `rust/endo`
     cannot depend on the excluded `rust/engine` workspace — an architectural decision;
     (L) the daemon worker/SES boot generators are absent from the tree — `test:rust` cannot
     build even on C-XS today, a precondition independent of endor; (L) the engine still lacks
     the boot intrinsics (live `globalThis` binding, guest `Compartment`/`lockdown`, harden) —
     the post-stage-4 intrinsics ledger, overlapping the test262-convergence design's later
     phases; (M) an endor `WorkerTransport` impl, unblocked once the rest lands. s20's read:
     the intrinsics/boot-surface work (gap #4 + the intrinsics ledger) is on the critical path
     to the finish line and is largely INDEPENDENT of the debugger row, so an
     **intrinsics/boot-surface stage alongside-or-before the debugger** is the natural shape —
     but decide from the fixer outcome + the live tree, SAY what you chose and why in the
     journal, and dispatch as orchestration `xs2rust-endor-build-stage7` (or the stage you
     chose; serial, halt, opus children, one-2400s sizing, tada-only reporting), decomposed
     YOURSELF from the design row + the live tree. Park s22
     `--blocked --blocked-on <that orchestration>` carrying this spec with an updated
     Supervisor state.
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed, 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS
  (and stage-5 BYTES) only; computron-vs-oracle is advisory telemetry; the meter is endor's own
  frozen release-versioned cost table (`endor-meter-N`, now snapshot-carried in the METR atom
  with a fail-closed version gate). Never back-fit meters to CESU-8 byte lengths or oracle
  computrons. The branch's dual-run/endor-xst runner still gates computrons (stricter than the
  bar); a deliberate runner-relaxation to result-gating belongs to the test262-convergence work.
- **Review ledger (carry forward):** GC-roots contract (the side tables must be roots when GC
  wires into the run loop — same table set as the snapshot ledger; verify at whichever stage
  first does it); the snapshot side-table ledger's Pending rows are the compile-checked
  remainder (functions/closures, call_stack, jumps, promises×4, generators+gen_run_stack,
  async×2, regexps, collections, buffers/typed/data-views, iterators, arrays, error/wrapper
  data, modules, harden state, symbol_registry) — they gate live-state-across-suspend, NOT the
  current inter-crank contract; cross-crank persistent-heap continuity (crank 2 reading a
  global crank 1 set) becomes real the moment the s20 fixer lands the global_props rebuild —
  the natural first behavioral fixture for it; FUNCTION_* analytic decomposition (advisory);
  sub-computron construct-`this` + object-literal construction drifts (advisory, stage-8
  ledger); generator saved-slice metering residual (advisory); module-goal oracle seam:
  COMPILE-only module entry landed; runtime module linking/evaluation seam belongs to
  test262-convergence; F1 doctrine: shim widenings are high-risk, separately audited;
  BothAbort same-value/different-cost should graduate to covered under the result bar
  (test262-convergence); dual-run runner must survive an ORACLE crash and report it as a named
  class (endor-xst may already do this — verify when convenient); stage-8 items
  (sort/toSorted/from/of, string residuals); pre-existing cosmetic warnings in interp.rs
  (unused `argc`, redundant `mut push_segment`) + coder.rs (`plus_one` never read); post-stage-4
  engine intrinsics ledger (`globalThis` live global-object binding — unblocks the boot-bundle
  chain — then Reflect, typed-array-from-iterable, symbol-keyed defineProperty, class-instance
  construction, `Compartment`/`lockdown` as guest globals — convergence 4/5 landed
  lockdown/compartment MODES + third-host wiring; every ses-mode case is still an honest named
  skip until the guest surface lands; child 5's gap map now locates this precisely on the
  finish-line critical path); a `Promise.prototype.finally` + combinators child rides the
  landed 5-slot native-reaction path (fold into a stage where it fits); `lockdown()` full +
  `mutabilities` remain folds on the harden substrate; stage-5 residuals: whole-`language/`
  single-process sweep OOMs (per-subtree by design); cargo-fuzz IS installable (child 4
  installed 0.13.2; snapshot targets ran 300k/400k-run campaigns green; three
  unbounded-allocation trophies fixed + locked, plus the NaN-PartialEq invariant trophy);
  **s16 process finding (binding on every verify): a whole-tree claim requires the whole-tree
  enumeration at the claimed tip — and (s18 corollary) a workspace-green claim requires running
  the workspace at the claimed tip.** s19 tooling note: invoke the prebuilt binaries directly
  WITHOUT a `--` separator (`./target/debug/compile-diff language/<subtree>`); the `--` form is
  only for `cargo run`. s20 notes: `post-job.sh` takes a body FILE path, not an inline body;
  the 121-run enumeration script pattern is in the s20 transcript (`/home/kris/tmp/s20-enum.sh`
  shape — 26 top-level dirs + 67 expressions/ + 27 statements/ + tco-pos temp subtree).
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin full sha `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1;
  README § Building the oracle; the shallow sha-fetch worked for s20 in seconds; never `git add`
  c/moddable). `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine`, NOT the repo
  root. A `cargo test` piped to `tail` masks the exit code — capture to a file, check `$?`.
  Miri needs `TMPDIR=$HOME/tmp`; `/tmp` is noexec (`bash /path/script.sh`); `mkdir -p
  $HOME/tmp` before redirecting logs there. If the bare clone's local branch ref is pinned
  stale by a dead worktree: detach that worktree's HEAD and
  `git fetch origin xs2rust-endor:xs2rust-endor`. Multiple sessions advance the branch — always
  sync to the REAL remote tip; verify pushes by git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a
  parked supervisor report via their tada completion report ONLY — never inbox-send the parked
  supervisor (dead-letter noise).
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s20 assessed NOT tripped — stage-6 bars all
  reproduced green; the ledger findings are classification honesty, not an invariance failure.
  Stage-6's trip wire (a round-trip invariance failure resisting attribution to a named
  atom/table) was NOT observed.
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
   1–5 done and ACCEPTED; stage 6 (Snapshots) built and verified green, acceptance pending the s20 ledger
   fixer; stages 7–9 remain.**
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

---
gate: blocked
blocked_on: xs2rust-endor-build-stage7
priority: normal
posted_by: producer
posted_at: 2026-07-16T23:57:51Z
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
specs on the board's git log), `-s19` (2026-07-16: full independent stage-5 reproduction GREEN
at `69ec87becb`; **POSTED THE FORMAL STAGE-5 ACCEPTANCE, PR #600 issuecomment-4996709674**;
dispatched stage 6 (Snapshots) as serial-halt orchestration `xs2rust-endor-build-stage6`),
`-s20` (2026-07-16: whole-stage-6 acceptance review — all bars reproduced GREEN at `2208ba8ad`
but the side-table ledger overstated coverage in three rows (GlobalProps, CtorPrototype,
SymbolTables); **POSTED the findings, PR #600 issuecomment-4997416149**; dispatched fixer
`xs2rust-endor-s20-ledger-restore-fix`; stage-6 acceptance deferred one round), and `-s21`
(2026-07-16: **ledger-fix verification + STAGE-6 ACCEPTANCE + stage-7 dispatch.** Verified the
fixer INDEPENDENTLY at tip `14febb8093` (= PR #600 head, DRAFT preserved; one commit atop s20's
verified `2208ba8ad`), oracle pin `23b4d6b0a65f` (8.3.1), fresh worktree: per-row diff review —
GlobalProps `RebuiltAtRestore` via `rebuild_global_props` chain walk (bounds-checked,
cycle-capped for the fuzz path), locked by `runtime_global_survives_suspend_resume` (real
snapshot-bytes round trip, result AND computron equality vs uninterrupted — the first genuine
cross-crank persistent-heap continuity fixture); SymbolTables `RebuiltAtRestore` via extracted
`bind_program_symbols` shared by boot and restore (no drift), locked by
`symbol_tables_rebuilt_at_restore`; CtorPrototype honestly `Pending` with the deciding evidence
documented (HashMap-only link + needs Pending `functions`; cross-crank `new f()` already aborts
uninterrupted); dedicated `Coverage::RebuiltAtRestore` variant + classified-honestly test +
excluded-transients doc list. Measured at the tip: workspace `cargo test --workspace --
--test-threads=1` **EXIT=0, all 26 `test result:` lines 0 failed** (434 passed = s20's 431 + 3
new); curated compile-diff **1711/1711 + SYMB 1711/1711, EXIT=0**; because the fix refactors
`link_intrinsics` (boot-path engine code), re-ran the **COMPLETE 121-run enumeration: 121 runs
0 nonzero, total=20603 identical=16981 divergent=0 oracle-rejected=3622 endor-rejected=0
accept-disagree=0 — EXACT s19 anchor match**; stage-4 endor-xst spot-checks Object 182/0 of
3127, Function 43/0 of 511, Array 487/0 of 2625 — identical to s20; `forbid(unsafe_code)`
intact at every engine crate root. **POSTED THE FORMAL STAGE-6 ACCEPTANCE, PR #600
issuecomment-4997552045** (measured numbers, per-row findings resolution, the honest snapshot
contract — arena+stack+names(+derived-tables-rebuilt)+meter at inter-crank quiescence, Pending
ledger as compile-checked remainder — and child 5's daemon-gap map restated). **Sequencing
decision: stage 7 = the engine boot-surface/intrinsics stage, debugger row deferred one
stage** — child 5's gap map puts the boot intrinsics (gap #4) + the daemon boot path (gap #3)
on the finish-line critical path, and the debugger row is independent of it; dispatched
serial-halt orchestration **`xs2rust-endor-build-stage7`**, seven opus children:
(1) `-live-globalthis` (live guest-visible `globalThis`, the ledger's boot-bundle unblocker);
(2) `-intrinsics-residuals` (Reflect, typed-array-from-iterable, symbol-keyed defineProperty,
class-instance construction); (3) `-promise-combinators` (`finally` + all/allSettled/any/race
on the landed 5-slot native-reaction path); (4) `-guest-harden-lockdown` (guest `harden`, full
`lockdown()`, `mutabilities` on the harden substrate; flip only truly-covered ses-mode skips);
(5) `-guest-compartment` (guest `Compartment` evaluate/endowments/globalThis; module machinery
explicitly deferred to test262-convergence); (6) `-boot-bundle-gate` (the design stage-4 bar:
boot bundles dual-run on endor vs oracle as a workspace test, named per-script/per-surface
skips as the next stage's ledger — the stage's acceptance-gate child); (7) `-daemon-boot-probe`
(gap-revealing probe of daemon-side gap #3 — the absent worker/SES boot generators, `test:rust`
unbuildable even on C-XS — and gap #2 — the rust/endo↔rust/engine workspace edge — deliverable
is a structured recipe/recommendation, landed slices only if genuinely green).)
You were parked `blocked_on: xs2rust-endor-build-stage7` and promoted because it reached a
terminal state. **FIRST:** sync your journal worktree
(`git -C journal pull --ff-only origin journal2`), read
`journal/jobs/tada/xs2rust-endor-build-stage7.md` and every
`journal/jobs/tada/xs2rust-endor-stage7-*.md` (if absent, check `git log --all -- jobs/` for
reaper poisoning — diagnose before re-dispatching; a serial-halt orchestration that HALTED
means a child failed — read the orchestration record's progress and the failed child's report
first). Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5, AND
  stage 6 (Snapshots): done and ACCEPTED** (s7: issuecomment-4888517639; s8:
  issuecomment-4888883354; s11: issuecomment-4897783472; s19 stage-5:
  issuecomment-4996709674; s21 stage-6: issuecomment-4997552045).
- **Stage 7 (engine boot-surface/intrinsics + daemon-boot probe): dispatched by s21; your
  review target.**
- **Your job now (s22): the whole-stage-7 acceptance review.** Read all seven children's tada
  reports. Reproduce INDEPENDENTLY at YOUR tip from a fresh checkout
  (`ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`), per the
  binding rule (a claim requires the measurement at the claimed tip): workspace EXIT=0 (file +
  `$?`, all `test result:` lines 0 failed); curated compile-diff 1711/1711 + SYMB 1711/1711;
  the boot-bundle gate's actual state (run it; read its named-skip ledger — that ledger is the
  next stage's decomposition input); the ses-xs-parity endor-xst sweep (verify flipped skips
  are REAL — spot-read a few); stage-4/5 spot checks; **the full 121-run enumeration is
  mandatory again** (stage 7 changes engine code by construction). Review the diffs
  substantively — the review ledger below names the standing hazards (GC-roots contract,
  side-table honesty, meter version-bump discipline, shim-widening F1 doctrine). Findings → PR
  comment + fixer (opus) + park s23 blocked on it, exactly the s20→s21 shape. On green +
  review-clean: POST the formal STAGE-7 ACCEPTANCE (measured numbers, the boot-gate ledger as
  accepted, the probe's gap #2/#3 answer restated), then **decide and dispatch the next
  stage** from the live tree + the probe's recipe: the natural candidates are a
  **daemon-integration stage** (gaps #1/#2/#3/#5: the workspace edge per the probe's
  recommendation, the boot-path reconstruction, the `-e endor-rs` selector, an endor
  `WorkerTransport`) if the probe's recipe is actionable, and the **Debugger row** (design
  row 7 + § Debugger requirement 1b: xsbug wire protocol, `DebugTransport` trait,
  uncaughtExceptions pseudo-breakpoint) — which can no longer be deferred if the daemon path
  stays blocked; SAY what you chose and why, dispatch as a serial-halt orchestration
  (`xs2rust-endor-build-stage8`, opus children, one-2400s sizing, tada-only reporting),
  decomposed YOURSELF from the design row + the live tree. Park s23
  `--blocked --blocked-on <that orchestration>` carrying this spec with an updated
  Supervisor state.
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed, 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS
  (and stage-5 BYTES) only; computron-vs-oracle is advisory telemetry; the meter is endor's own
  frozen release-versioned cost table (`endor-meter-N`, snapshot-carried in the METR atom with
  a fail-closed version gate). Never back-fit meters to CESU-8 byte lengths or oracle
  computrons. The branch's dual-run/endor-xst runner still gates computrons (stricter than the
  bar); a deliberate runner-relaxation to result-gating belongs to the test262-convergence work.
- **Review ledger (carry forward):** GC-roots contract (the side tables must be roots when GC
  wires into the run loop — same table set as the snapshot ledger; verify at whichever stage
  first does it); the snapshot side-table ledger's Pending rows are the compile-checked
  remainder (functions/closures, call_stack, jumps, promises×4, generators+gen_run_stack,
  async×2, regexps, collections, buffers/typed/data-views, iterators, arrays, error/wrapper
  data, modules, harden state, symbol_registry, ctor_prototype) — they gate
  live-state-across-suspend, NOT the accepted inter-crank contract; the s20-fixer landed
  `Coverage::RebuiltAtRestore` + the excluded-transients doc list — any NEW side table a stage
  adds must be classified honestly in the ledger (s22: check stage 7's diffs for exactly this);
  cross-crank persistent-heap continuity now has its first real fixture
  (`runtime_global_survives_suspend_resume`) — extend the pattern as new state becomes
  cross-crank-real; FUNCTION_* analytic decomposition (advisory); sub-computron
  construct-`this` + object-literal construction drifts (advisory, stage-8 ledger); generator
  saved-slice metering residual (advisory); module-goal oracle seam: COMPILE-only module entry
  landed; runtime module linking/evaluation seam belongs to test262-convergence (stage-7 child
  5 was told to document this at the guest-Compartment surface); F1 doctrine: shim widenings
  are high-risk, separately audited; BothAbort same-value/different-cost should graduate to
  covered under the result bar (test262-convergence); dual-run runner must survive an ORACLE
  crash and report it as a named class (endor-xst may already do this — verify when
  convenient); stage-8 items (sort/toSorted/from/of, string residuals); pre-existing cosmetic
  warnings in interp.rs (unused `argc`, redundant `mut push_segment`) + coder.rs (`plus_one`
  never read); the post-stage-4 engine intrinsics ledger IS stage 7's work-list — s22 verifies
  it rather than carrying it; stage-5 residuals: whole-`language/` single-process sweep OOMs
  (per-subtree by design); cargo-fuzz IS installable (0.13.2; snapshot targets ran
  300k/400k-run campaigns green; three unbounded-allocation trophies fixed + locked, plus the
  NaN-PartialEq invariant trophy); **s16 process finding (binding on every verify): a
  whole-tree claim requires the whole-tree enumeration at the claimed tip — and (s18 corollary)
  a workspace-green claim requires running the workspace at the claimed tip.** s19 tooling
  note: invoke the prebuilt binaries directly WITHOUT a `--` separator
  (`./target/debug/compile-diff language/<subtree>`); the `--` form is only for `cargo run`.
  s20 notes: `post-job.sh`/`post-plan.sh` take a body FILE path, not an inline body. s21 notes:
  the 121-run enumeration script is `/home/kris/garden/tmp/s21-enum.sh` (26 top-level
  `language/` dirs + 67 `expressions/` + 27 `statements/` + a temp subtree for the loose
  `expressions/tco-pos.js`; edit its WT variable to your worktree path); **`$HOME` inside the
  container is `/home/kris/garden`**, so `$HOME/tmp` = `/home/kris/garden/tmp` (mkdir it before
  redirecting logs); the project-worktree helper hardlink-seeds `rust/engine/target/` from a
  sibling at the same commit, so a fresh worktree can be fully cargo-cached — 0 `Compiling`
  lines with fingerprints validated against your sources still counts as built-at-tip (cargo
  rebuilds on any drift), but confirm the tip sha and a clean `git status` before trusting it.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin full sha `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1;
  README § Building the oracle; shallow sha-fetch works in seconds, or copy `c/` from a sibling
  scratch worktree at the pin; never `git add` c/moddable). `cargo` at `$HOME/.cargo/bin`. The
  Rust workspace is `rust/engine`, NOT the repo root. A `cargo test` piped to `tail` masks the
  exit code — capture to a file, check `$?`. Miri needs `TMPDIR=$HOME/tmp`; `/tmp` is noexec
  (`bash /path/script.sh`). If the bare clone's local branch ref is pinned stale by a dead
  worktree: detach that worktree's HEAD and `git fetch origin xs2rust-endor:xs2rust-endor`.
  Multiple sessions advance the branch — always sync to the REAL remote tip; verify pushes by
  git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a
  parked supervisor report via their tada completion report ONLY — never inbox-send the parked
  supervisor (dead-letter noise).
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s21 assessed NOT tripped — every stage-6 bar
  reproduced green at the fixed tip, the enumeration matches the anchor exactly, and the
  ledger rows are now truthful; no invariance failure observed.
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
   1–6 done and ACCEPTED; stage 7 (engine boot-surface/intrinsics + daemon-boot probe) dispatched;
   remaining after it: daemon integration and/or Debugger, then parity closure (design row 8) and
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

---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-16T23:06:05Z -->

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
dispatch), `-s12` (whole-stage-5 review round 1: byte-identity bar measured NOT met; fix
orchestration dispatched), `-s13` (fix round-1 review: curated bar MET but broadened sweep
exposed new classes; fix round 2), `-s14` (fix round-2 review: BAR NOT MET; fix round 3), `-s15`
(fix round-3 review: class remainder partitioned EXACT, one shared structural root cause; fix
round 4), `-s16` (fix round-4 review: class surface closed; FIRST full 120-subtree enumeration
exposed 6 residual classes; fix round 5), `-s17` (fix round-5 acceptance review: tree converged
onto ONE divergent file — `arrow/binding-tests-3.js`; fix round 6 dispatched), `-s18` (fix6
verified: capture-closure fold closed as a real fix `2b7cc6a35c`; the five convergence children
landed endor-xst + cases/ retirement `f31ad65a46..194454363a`; full independent stage-5
reproduction GREEN at `194454363a` EXCEPT workspace EXIT=101 — two endor-compile smoke tests
still read the retired `corpora/` dir; findings issuecomment-4948133602; repair fixer
dispatched; formal acceptance deferred one round), and `-s19` (2026-07-16: repair fixer
`xs2rust-endor-262-smoke-corpora-repair` completed via tada — commit `69ec87becb`, verified
tests-only (3 files under `endor-compile/tests/`: shared `corpus_cases/mod.rs` helper mirroring
endor-262's cases/`info: Source:` extraction + the two repointed smoke tests, corpus count
asserted == 1711). s19 reproduced INDEPENDENTLY at tip `69ec87becb`, oracle pin `23b4d6b0a65f`
(8.3.1), fresh worktree: **workspace `cargo test --workspace -- --test-threads=1` EXIT=0, all
22 `test result:` lines 0 failed** (the last deferred row, now green); curated compile-diff
1711/1711 identical div=0 EXIT=0; COMPLETE 121-run enumeration all EXIT=0, summed
**total=20603 identical=16981 divergent=0 oracle-rejected=3622 (all accept-agreed)
endor-rejected=0 accept-disagree=0** (matches s18 exactly); stage-4 bars hold under endor-xst
(Object 182/0 of 3127, Function 43/0 of 511, Array 487/0 of 2625, all skips named). **s19
POSTED THE FORMAL STAGE-5 ACCEPTANCE: PR #600 issuecomment-4996709674** (numbers, empty fold
ledger — every fix5/fix6 fold closed as a real fix — and the 6-round fix history). s19 then
dispatched **stage 6 (Snapshots)** as orchestration **`xs2rust-endor-build-stage6`** (serial,
halt, opus children): (1) `xs2rust-endor-stage6-seam-flip` — Compiler default → Endor, endor
emits its OWN SYMB atom (today `compile_for`'s Endor arm still clones `oracle.symbols`; the
coder interns the identical table, so the emitter must be byte-identical vs oracle symbols
across the 1711 corpus as a committed gate), sweep + grep-proof all oracle-compiles-by-default
seams, oracle kept for differential harnesses ONLY; (2) `xs2rust-endor-stage6-snapshot-atoms` —
`endor-snapshot` crate, XS_M atom writer/reader (VERS/SIGN/CREA/BLOC/HEAP/STAC/KEYS/NAME/SYMB,
endor VERS discriminator, index-based heap serializer, forbid(unsafe_code)), SIDE-TABLE-COMPLETE
per the ledger's snapshot note, locked round-trip fixtures; (3)
`xs2rust-endor-stage6-machine-surface` — xsnap-shaped
`write_snapshot_to_file`/`from_snapshot_file`/`suspend_to_cas` + meter state across suspend
(suspend/resume-equals-uninterrupted in result AND computrons, locked); (4)
`xs2rust-endor-stage6-roundtrip-fuzz` — round-trip-invariance + malformed-atom fuzz targets
(design fuzz item 3), locked trophies, honest fallback to a bounded seeded property loop if
cargo-fuzz is uninstallable in budget; (5) `xs2rust-endor-stage6-supervisor-integration` —
supervisor suspend/resume on `-e endor-rs` (design row-6 bar), with an explicit
gap-revealing-probe valve if the daemon boot path is structurally unreachable (expected gaps:
the post-stage-4 intrinsics ledger — live `globalThis`, guest `Compartment`/`lockdown`); (6)
`xs2rust-endor-stage6-verify` — independent whole-stage verify at the tip (workspace + snapshot
bars + seam-flip grep-proof + stage-5 bars HOLD: curated + FULL 121-run enumeration + stage-4
spot-checks + README ledger). The C-XS snapshot importer stays OUT of scope (resolved
question 3). Kill-criterion: NOT tripped — stage-5 accepted with zero divergences tree-wide;
stage-6's own trip wire is a round-trip invariance failure that resists attribution to a named
atom/table.)
You were parked `blocked_on: xs2rust-endor-build-stage6` and promoted because it reached a
terminal state. **FIRST:** sync your journal worktree
(`git -C journal pull --ff-only origin journal2`), read
`journal/jobs/tada/xs2rust-endor-build-stage6.md` AND each child's
`journal/jobs/tada/xs2rust-endor-stage6-*.md` (if a child is absent from tada, check
`git log --all -- jobs/` for reaper poisoning; a serial-halt orchestration that halted names the
failed child — diagnose before re-dispatching). Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, AND STAGE 5: done
  and ACCEPTED** (s7: issuecomment-4888517639; s8: issuecomment-4888883354; s11:
  issuecomment-4897783472; s19 stage-5: issuecomment-4996709674).
- **Stage 6 (Snapshots): dispatched by s19 as orchestration `xs2rust-endor-build-stage6`** —
  six serial children above. The test262-convergence work landed early (endor-xst runner,
  cases/ retirement, async harness, lockdown/compartment MODES, trophies tree); its remaining
  scope (runtime module linking/evaluation seam, computron-gate relaxation, guest
  lockdown/Compartment surface) belongs to that design's later phases, not stage 6.
- **Your job now (s20): the whole-stage-6 acceptance review.**
  1. Read the orchestration + child tada reports. If the orchestration HALTED on a child:
     diagnose (partial landing on the branch counts as landing — check the actual tree),
     dispatch the appropriate fixer (opus) or re-dispatch the remainder as a new orchestration,
     park s21 blocked on it carrying this spec with updated state.
  2. On a completed orchestration: **reproduce the bars yourself at YOUR tip** from a fresh
     checkout (`ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`),
     per the binding rule (a claim requires the measurement at the claimed tip): workspace
     EXIT=0 (file + `$?`, all `test result:` lines 0 failed); the snapshot bars (round-trip
     fixtures, meter-across-suspend, malformed-atom gates — run them, name them); seam-flip
     grep-proof (`Compiler::default()` is Endor; `endor_oracle::` call sites classified
     differential-only); stage-5 bars HOLD (curated compile-diff + the COMPLETE 121-run
     enumeration + stage-4 endor-xst spot-checks, floors 182/43/487). s19's anchor numbers for
     comparison: total=20603 identical=16981 divergent=0 oracle-rejected=3622 endor-rejected=0
     accept-disagree=0.
  3. Review the landed stage-6 code yourself (the review loop is yours): the side-table
     completeness of the atom grammar against endor-vm's LIVE Interp fields (the ledger's
     snapshot-shaped missing-GC-root hazard), the suspend-point contract's honesty, the
     endor-VERS discriminator, forbid(unsafe_code) at all crate roots incl. endor-snapshot.
     Findings → PR comment + fixer dispatch (opus) + park s21 blocked on it.
  4. On green + review-clean: **POST the stage-6 ACCEPTANCE** as a PR #600 comment (your
     measured numbers + the child-5 outcome: integration test green, or its structured gap map
     restated). Then **dispatch stage 7 (Debugger, design § roadmap row 7 + § Debugger
     requirement 1b — read both from the live tree; xsbug wire protocol byte-compatible, the
     DebugTransport trait, uncaughtExceptions pseudo-breakpoint)** as orchestration
     `xs2rust-endor-build-stage7` (serial, halt, opus children, one-2400s sizing, tada-only
     reporting), decomposed YOURSELF from the design row + the live tree. If child 5 probed
     (daemon integration structurally unreachable), FOLD the gap map into your stage-7/8
     sequencing decision: the maintainer finish line (integrated with endo + `test:rust` green)
     may need an intrinsics/boot-surface stage BEFORE or ALONGSIDE the debugger — judge from
     the gap map and the design's remaining rows (7 Debugger, 8 residual built-ins/telemetry,
     9 integration), and say what you chose and why in the journal. Park s21
     `--blocked --blocked-on xs2rust-endor-build-stage7` (or the stage you chose) carrying this
     spec with an updated Supervisor state.
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed, 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS
  (and stage-5 BYTES) only; computron-vs-oracle is advisory telemetry; the meter is endor's own
  frozen release-versioned cost table (`endor-meter-N`). Never back-fit meters to CESU-8 byte
  lengths or oracle computrons. The branch's dual-run/endor-xst runner still gates computrons
  (stricter than the bar) — children may keep it green via calibrated constants or honest skips;
  a deliberate runner-relaxation to result-gating belongs to the test262-convergence work.
- **Review ledger (carry forward):** GC-roots contract (side tables functions[*].closures /
  CallerState / CatchJump / global_props + regexp/bound/promise side tables + async_instances/
  async_run_stack + generators + module records/maps + harden worklist/frozen-intrinsics tables
  must be roots when GC wires into the run loop, deterministic trigger points — verify at
  whichever child/stage first does it; SNAPSHOT NOTE now ACTIVE at stage 6: the HEAP/STAC atoms
  must serialize these same side tables — s20 reviews the landed grammar for exactly this);
  FUNCTION_* analytic decomposition (advisory); sub-computron construct-`this` + object-literal
  construction drifts (advisory telemetry, stage-8 ledger); generator saved-slice metering
  residual (advisory); module-goal oracle seam: COMPILE-only module entry landed; runtime module
  linking/evaluation seam belongs to test262-convergence; F1 doctrine: shim widenings are
  high-risk, separately audited; BothAbort same-value/different-cost should graduate to covered
  under the result bar (test262-convergence); dual-run runner must survive an ORACLE crash and
  report it as a named class (endor-xst may already do this — verify when convenient); stage-8
  items (sort/toSorted/from/of, string residuals); pre-existing cosmetic warnings in interp.rs
  (unused `argc`, redundant `mut push_segment`) + coder.rs (`plus_one` never read); post-stage-4
  engine intrinsics ledger (`globalThis` live global-object binding — unblocks the boot-bundle
  chain — then Reflect, typed-array-from-iterable, symbol-keyed defineProperty, class-instance
  construction, `Compartment`/`lockdown` as guest globals — convergence 4/5 landed
  lockdown/compartment MODES + third-host wiring; every ses-mode case is still an honest named
  skip until the guest surface lands; child 5's gap probe, if taken, will have mapped this
  precisely); a `Promise.prototype.finally` + combinators child rides the landed 5-slot
  native-reaction path (fold into a stage where it fits); `lockdown()` full + `mutabilities`
  remain folds on the harden substrate; stage-5 residuals ledger: whole-`language/`
  single-process sweep OOMs (per-subtree by design), a long cargo-fuzz campaign needs cargo-fuzz
  installed (child 4 attempts an install; read its report), the endor-vm compartment evaluate
  path oracle-compiles UNTIL child 1 lands (s20: verify flipped); fix5 3/5 note:
  malformed-escape rejection covers the primary string-literal position; property-key /
  import-export-specifier string positions unexercised by the corpora, left as-is; **s16 process
  finding (binding on every verify): a whole-tree claim requires the whole-tree enumeration at
  the claimed tip — and (s18 corollary) a workspace-green claim requires running the workspace
  at the claimed tip.** s19 tooling note: invoke the prebuilt binaries directly WITHOUT a `--`
  separator (`./target/debug/compile-diff language/<subtree>` — a literal `--` is read as the
  subtree name and every run exits 2 with "no test files"); the `--` form is only for
  `cargo run`.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin full sha `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1;
  README § Building the oracle has the fetch recipe — the shallow sha-fetch from
  `https://github.com/Moddable-OpenSource/moddable` worked for s19 in ~seconds; never `git add`
  c/moddable). `cargo` at `$HOME/.cargo/bin`. The Rust workspace is `rust/engine`, NOT the repo
  root. Whole-tree single-process `language/` runs OOM — per-subtree enumeration: each top-level
  `language/` dir whole EXCEPT `expressions/`+`statements/` per second-level subtree, plus loose
  `expressions/tco-pos.js` via a temp subtree = 121 runs (compile-diff prints DIVERGENT /
  ENDOR-REJECTED / accept-disagreement detail lines — capture them). The dual-run runner is
  `endor-xst` (`cargo run -p endor-262 --bin endor-xst -- <subtree>`; positional paths default
  under `language/`; also `built-ins/...`; `--no-oracle`, `-o report.yaml`,
  `--features-include`). Byte-identity harness: `compile-diff` (no arg = curated; one arg = a
  subtree; EXIT!=0 when not clean). Prebuilt at `rust/engine/target/debug/` after one build. A
  `cargo test` piped to `tail` masks the exit code — capture to a file, check `$?`. Miri needs
  `TMPDIR=$HOME/tmp`; `/tmp` is noexec (`bash /path/script.sh`). If the bare clone's local
  branch ref is pinned stale by a dead worktree: detach that worktree's HEAD and
  `git fetch origin xs2rust-endor:xs2rust-endor`. Multiple sessions advance the branch — always
  sync to the REAL remote tip; verify pushes by git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a
  parked supervisor report via their tada completion report ONLY — never inbox-send the parked
  supervisor (dead-letter noise).
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s19 assessed NOT tripped — stage 5 formally accepted
  with zero divergences and zero accept-disagreements tree-wide. Stage-6's own trip wire: a
  round-trip invariance failure that resists attribution to a named atom/table is trip
  territory; judge with evidence.
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
   1–5 done and ACCEPTED; stage 6 (Snapshots) dispatched as orchestration `xs2rust-endor-build-stage6`;
   stages 7–9 remain.**
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
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-16T23:06:10Z

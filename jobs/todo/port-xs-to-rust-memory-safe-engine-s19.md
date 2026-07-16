---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-16T21:13:29Z -->

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (s1 design
dispatch), `-s2` (self-answer + approve), `-s3` (stage-1 review), `-s4` (stage-2a review + 2b
dispatch), `-s5` (2b review + stage-3 dispatch), `-s6` (stage-3 halt recovery + stage-3b dispatch),
`-s7` (whole-stage-3 acceptance review with full independent reproduction), `-s8` (UTF-16 strings
acceptance + bound-callback fixer verification + stage-4 dispatch), `-s9` (stage-4 halt recovery +
stage-4b remainder dispatch), `-s10` (whole-stage-4 acceptance review — findings + F1 fixer
dispatch), `-s11` (F1 fix verification + stage-4 ACCEPTANCE + stage-5 dispatch), `-s12`
(whole-stage-5 review round 1: byte-identity bar measured NOT met; fix orchestration dispatched),
`-s13` (fix round-1 review: curated bar MET but broadened sweep exposed new classes; fix round 2),
`-s14` (fix round-2 review: BAR NOT MET; fix round 3), `-s15` (fix round-3 review: class remainder
partitioned EXACT, one shared structural root cause; fix round 4), `-s16` (fix round-4 review:
class surface closed; FIRST full 120-subtree enumeration exposed 6 residual classes; fix round 5),
`-s17` (fix round-5 acceptance review: tree converged onto ONE divergent file —
`arrow/binding-tests-3.js`, the enclosing-function synthetic capture-closure fold; findings
issuecomment-4910406893; fix round 6 dispatched — 2 children), and `-s18` (2026-07-11: both fix6
children completed via tada — fix6 1/2 `2b7cc6a35c` closed the capture-closure fold (three-part
fix: parser sets `flags::EVAL` at a bare `eval(...)` call; `code_arguments_object` gates
materialization on the real `mxArgumentsFlag`; `code_body` keys the two-`WITHOUT` teardown on the
node's eval flag; locked fixture added); fix6-verify measured STAGE-5 BAR MET at `1cbaf38b68`.
MEANWHILE the five `xs2rust-endor-262-*` test262-convergence children ran (armed outside this
supervisor line) and landed `f31ad65a46..194454363a`: the endor-xst runner (subsumes
`test262-language`; same positional-subtree CLI), corpora→`cases/` retirement (1,711 programs
preserved verbatim in `info: Source:` frontmatter; `corpora_programs()` repointed),
async/$DONE + job-drain harness, lockdown/compartment modes + third-host wiring, fuzz-trophies
regression tree. s18 ran the FULL INDEPENDENT stage-5 reproduction at tip `194454363a`, oracle pin
`23b4d6b0a65f` (8.3.1): curated 1711/1711 div=0 e-rej=0 a-dis=0 EXIT=0; COMPLETE 121-run
enumeration (120 subtrees + loose `expressions/tco-pos.js`): **total=20603 identical=16981
divergent=0 oracle-rejected=3622 (all accept-agreed) endor-rejected=0 accept-disagree=0**, every
run EXIT=0; stage-4 bars hold and improve under endor-xst (Object 182/0 of 3127, Function 43/0 of
511, Array 487/0 of 2625, all skips named); parse-metering determinism green (the
determinism test + two identical back-to-back compile-diff runs); `forbid(unsafe_code)` intact at all 5 crate roots. **BUT workspace
EXIT=101 at the tip:** `cargo test --no-fail-fast` = 338 passed / exactly 2 failed —
`endor-compile/tests/corpus_parse_smoke.rs` + `corpus_scope_smoke.rs` still `read_dir` the
retired `endor-262/corpora/` dir (convergence 2/5 `39665c235d` missed them). Test-infrastructure
only; no compiler/runtime source implicated. s18 posted findings as PR #600
**issuecomment-4948133602**, dispatched the repair fixer
**`xs2rust-endor-262-smoke-corpora-repair`** (opus: repoint both smoke tests at the `cases/`
`info: Source:` extraction with a local helper — endor-compile cannot dep on endor-262, circular —
assert the 1,711 count, restore workspace EXIT=0, tests-only commit), and DEFERRED the formal
stage-5 acceptance one round on the workspace-green row alone. Kill-criterion: NOT tripped —
zero divergences, zero accept-disagreements, tree-wide).
You were parked `blocked_on: xs2rust-endor-262-smoke-corpora-repair` and promoted because it
reached a terminal state. **FIRST:** sync your journal worktree
(`git -C journal pull --ff-only origin journal2`), read
`journal/jobs/tada/xs2rust-endor-262-smoke-corpora-repair.md` (if absent, check
`git log --all -- jobs/` for reaper poisoning; diagnose false-positive reap — was the child
landing commits during its claim window? — before re-dispatching). Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, and stage 4: done and
  ACCEPTED** (s7: issuecomment-4888517639; s8: issuecomment-4888883354; s11:
  issuecomment-4897783472).
- **Stage 5 (Compiler port — `endor-compile`): byte-identity + determinism + stage-4-hold bars
  all reproduced GREEN at tip `194454363a` by s18 (numbers above); formal ACCEPTANCE deferred
  ONLY on workspace EXIT=0, pending the smoke-test repair.** The test262-convergence work
  (design's stage-8-ish item) landed early and is green except those two tests.
- **Your job now (s19):**
  1. **Verify the repair:** from your fresh checkout
     (`ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`, synced to
     the REAL remote tip), confirm the fixer's diff touches ONLY the two test files (no
     compiler/runtime source), then run `cargo test --workspace -- --test-threads=1` from
     `rust/engine` captured to a FILE with `$?` checked → EXIT=0, all `test result:` lines
     0 failed. If the fixer failed/was poisoned: diagnose (partial landing on the branch counts),
     re-dispatch a repair fixer (opus), park s20 blocked on it carrying this spec.
  2. **Re-anchor the whole-tree claim at YOUR tip** (s16 binding rule; the enumeration is cheap,
     ~5 min with a built tree): curated `compile-diff` (no arg) + the COMPLETE 121-run
     `language/` enumeration loop (per top-level dir; `expressions/`+`statements/` per
     second-level; loose `expressions/tco-pos.js` via a temp subtree) → expect divergent=0
     endor-rejected=0 accept-disagree=0 everywhere. Spot-check stage-4 bars via
     `endor-xst built-ins/{Object,Function,Array}` (floors: 182/43/487 covered, 0 failed).
  3. **On green: POST the stage-5 ACCEPTANCE** as a PR #600 comment — your reproduction numbers,
     the full-tree totals, the fold ledger (now EMPTY of divergence folds: every fix5/fix6 fold
     closed as a real fix; rejects all accept-agreed), the fix-round history (6 rounds), and the
     explicit acceptance sentence. Then **dispatch stage 6 (Snapshots, design § roadmap row 6 +
     § Snapshots requirement 1c — read both from the live tree)** as orchestration
     `xs2rust-endor-build-stage6` (serial, halt, opus children, one-2400s-invocation sizing,
     budget-discipline paragraph, tada-only reporting — children must NOT inbox-send the parked
     supervisor). **Child 1 MUST be the compiler-seam DEFAULT flip** (endor-compile replaces
     oracle-compile as the default — the endor-vm compartment evaluate path and every
     oracle-compiles-by-default seam; verification: workspace EXIT=0 + curated compile-diff +
     a stage-4 endor-xst spot-check + grep-proof that no default path invokes the oracle
     compiler; the oracle stays available for differential harnesses ONLY). Decompose the rest
     YOURSELF from the design row + the live tree; a reasonable sketch (adapt to what you find):
     (2) `endor-snapshot` crate: the XS_M atom container writer/reader
     (VERS/SIGN/CREA/BLOC/HEAP/STAC/KEYS/NAME/SYMB, endor VERS discriminator, index-based heap
     serializer, `forbid(unsafe_code)`); (3) `Machine` snapshot surface + meter state across
     suspend (the xsnap-shaped `write_snapshot_to_file`/`from_snapshot_file`/`suspend_to_cas`
     surface); (4) round-trip-invariance + malformed-atom fuzz targets (design fuzz item 3) with
     locked regression fixtures; (5) supervisor suspend/resume integration on `-e endor-rs` (the
     design bar; if daemon integration is not yet reachable, size it as a gap-revealing probe and
     say so); (6) a stage-6 verify child (workspace green + snapshot bars + stage-5 bars HOLD:
     curated + full enumeration + stage-4 spot-checks + README ledger). The C-XS snapshot
     importer stays OUT of scope (resolved question 3). Park s20
     `--blocked --blocked-on xs2rust-endor-build-stage6` carrying this spec with an updated
     Supervisor state.
  4. If your reproduction DISAGREES with the repair (workspace still red, or — unexpected — any
     byte divergence appears): post findings, dispatch the appropriate fixer round, park s20
     blocked on it. A test-path repair that cannot land green after two rounds is process
     evidence, not kill-criterion evidence (the compiler bars are green); keep the two ledgers
     separate.
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
  whichever child/stage first does it; SNAPSHOT NOTE: stage 6's HEAP/STAC atoms must serialize
  these same side tables — an atom grammar that misses one is the snapshot-shaped version of the
  missing-GC-root bug, review for it); FUNCTION_* analytic decomposition (advisory);
  sub-computron construct-`this` + object-literal construction drifts (advisory telemetry,
  stage-8 ledger); generator saved-slice metering residual (advisory); module-goal oracle seam:
  COMPILE-only module entry landed (round 1, locked script-path tests); fix5 4/5 closed the
  script-goal `import.meta`/duplicate-label gaps as REAL fixes (no fold needed); runtime module
  linking/evaluation seam still belongs to test262-convergence; F1 doctrine: shim widenings are
  high-risk, separately audited; BothAbort same-value/different-cost should graduate to covered
  under the result bar (test262-convergence); dual-run runner must survive an ORACLE crash and
  report it as a named class (endor-xst may already do this — verify when convenient); stage-8
  items (sort/toSorted/from/of, string residuals); pre-existing cosmetic warnings in interp.rs
  (unused `argc`, redundant `mut push_segment`) + coder.rs (`plus_one` never read); post-stage-4
  engine intrinsics ledger (`globalThis` live global-object binding — unblocks the boot-bundle
  chain — then Reflect, typed-array-from-iterable, symbol-keyed defineProperty, class-instance
  construction, `Compartment`/`lockdown` as guest globals — NOTE: convergence 4/5 landed
  lockdown/compartment MODES + third-host wiring; every ses-mode case is still an honest named
  skip until the guest surface lands); a `Promise.prototype.finally` + combinators child rides
  the landed 5-slot native-reaction path (fold into a stage where it fits); `lockdown()` full +
  `mutabilities` remain folds on the harden substrate; stage-5 residuals ledger: whole-`language/`
  single-process sweep OOMs (per-subtree by design), a long cargo-fuzz campaign needs cargo-fuzz
  installed (follow-up), the endor-vm compartment evaluate path still oracle-compiles until the
  stage-6 child-1 seam flip; fix5 3/5 note: malformed-escape rejection covers the primary
  string-literal position; property-key / import-export-specifier string positions unexercised by
  the corpora, left as-is; **s16 process finding (binding on every verify): a whole-tree claim
  requires the whole-tree enumeration — and (s18 corollary) a workspace-green claim requires
  running the workspace at the claimed tip.**
- **Sequencing note:** the five `xs2rust-endor-262-*` convergence children have now RUN (landed
  `f31ad65a46..194454363a`, orchestration `xs2rust-endor-test262-convergence` complete). The
  remaining test262-convergence scope (runtime module linking/evaluation seam, computron-gate
  relaxation, guest lockdown/Compartment surface) still belongs to that design's later phases,
  not to stage 6.
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin full sha is `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable
  8.3.1; the old `48ee02d8cfe0` = 8.2.3 is superseded; README § Building the oracle has the
  fetch recipe + fallbacks). Fastest population: `git init` `c/moddable`, then
  `git fetch <a sibling scratch worktree>/c/moddable 23b4d6b0a65f…` (s18 seeded from
  `project-wt-xs2rust-endor-stage5-fix6-verify-5cd7f36a`; a "shallow roots" warning is harmless —
  the checkout still lands; never `git add` c/moddable). `cargo` at `$HOME/.cargo/bin`. The Rust
  workspace is `rust/engine`, NOT the repo root (the root Cargo.toml is a different workspace
  whose xsnap crate does not even build; run all cargo commands from `rust/engine`).
  Whole-tree single-process `language/` runs OOM — the enumeration loop shape is: for each
  top-level `language/` dir, run `compile-diff -- <dir>` whole, EXCEPT `expressions/` and
  `statements/` which run per second-level subtree (121 runs incl. the loose-file temp subtree;
  compile-diff prints DIVERGENT / ENDOR-REJECTED / ENDOR-ONLY-ACCEPT / ORACLE-ONLY-ACCEPT detail
  lines — capture them). The dual-run runner is now **`endor-xst`** (`cargo run -p endor-262
  --bin endor-xst -- <subtree>`; positional paths default under `language/`; also takes
  `built-ins/...`; `--no-oracle`, `-o report.yaml`, `--features-include`; `test262-language` is
  RETIRED). The byte-identity harness is `cargo run -q -p endor-262 --bin compile-diff` (no arg =
  curated cases; one arg = a subtree; EXIT!=0 when not clean). Prebuilt binaries live at
  `rust/engine/target/debug/{compile-diff,endor-xst}` after one build. Miri on this host needs
  `TMPDIR=$HOME/tmp`; `/tmp` is noexec — run scripts via `bash /path/script.sh`. A `cargo test`
  piped to `tail` masks the exit code — capture to a file and check `$?` directly. If the bare
  clone's local branch ref is pinned stale by a dead worktree, detach that worktree's HEAD and
  `git fetch origin xs2rust-endor:xs2rust-endor` (s10's fix). Multiple sessions advance the
  branch — always sync to the REAL remote tip before working; verify pushes by git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a
  parked supervisor report via their tada completion report ONLY — never inbox-send to the
  parked supervisor (dead-letter noise).
- **Kill criteria:** if tripped (design § Feasibility Verdict — stage 5's byte-identity bar is
  one), stop the program: journal + surface to the maintainer with evidence. s18 assessed NOT
  tripped, with the strongest evidence yet: zero divergences and zero accept-disagreements across
  the complete 121-run enumeration at the live tip. Stage-6 snapshot work has its own trip wire:
  a round-trip invariance failure that resists attribution to a named atom/table is trip
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
   the design set (as amended by the accuracy-over-parity doctrine, 2026-07-04). — **IN PROGRESS: roadmap
   stages 1–5 dispatched (stages 1–4 ACCEPTED; stage 5 measured green pending the workspace repair +
   formal acceptance at s19); stages 6–9 remain.**
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

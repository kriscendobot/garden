---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-18T04:21:05Z -->

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
orchestration `xs2rust-endor-build-stage8`, six opus children; stage-8 measured bars at
`4010c8f19c`: workspace EXIT=0 all 33 `test result:` lines 0 failed, 506 passed; compile-diff
1711/1711 + SYMB 1711/1711; full 121-run enumeration total=20603 identical=16981 divergent=0
oracle-rejected=3622 endor-rejected=0 accept-disagree=0 — the standing anchor; the stage-9
MUSTs recorded there: Debugger row deferral budget exhausted, endor-vm path-dep + daemon spawn
wiring deferred by design), `-s24` (2026-07-17: stage-8 halt recovery round one — the
`-cxs-baseline` child's 5 claims all died inside the ~11:30–12:40Z transient outage window;
re-dispatched as `xs2rust-endor-build-stage8b`. Standing discovery, **binding on every future
`test:rust` measurement including stage 9's finish-line runs**: the AF_UNIX `sun_path` limit —
a long scratch-worktree path overflows the daemon's per-test socket path (`test/channel.test.js`
caps at `MAX_UNIX_SOCKET_PATH = 90`, fixed overhead ≈ 100 chars from a scratch worktree);
measure from a short real path (symlinks do NOT work, Node resolves real paths) and treat any
mass-identical failure as an artifact until excluded. Stage-8 children 1–2
(`-daemon-bundle-imports`, `-boot-generators`) COMPLETED before that halt), `-s25` (2026-07-17/18:
stage-8b halt recovery round two — the `-cxs-baseline-r2` child's 5 claims died in a SECOND
outage window (~17:04–18:23Z, both hosts); s25 re-cut the three remaining children as
`xs2rust-endor-build-stage8c` and measured the **real C-XS `test:rust` baseline itself** from
the short-path clone `~/tmp/s8cxs` (a `--shared` clone of the fleet bare repo; sha
`git checkout --detach` works where fetch fails; workspace deps are symlinks so checkout
retargets them; run ava as `node ../../node_modules/ava/entrypoints/cli.js`) at stage-8 tip
`9bef7de22e` (≡ pre-rebase `65180ad877`; engine byte-identical across that rebase):
**default-concurrency: 646 passed / 294 failed / 65 skipped, AVA_EXIT=1, wall 78 min; log
`~/tmp/s25-cxs-baseline.log` on host endolin-garden2. Classification: DOMINANT 539 ×
`endo.sock not ready within 10000ms` — a concurrency load-amplification artifact of ava's
file-level parallelism (dozens of interpreted-XS daemons booting at once; formulation traces
stall to T+109s/T+438s), NOT a path artifact (91-char sock paths) and NOT a dead daemon
(per-test `endo.log`s show SES bootstrap + main loop entered); PROOF: a `--serial` single-file
probe boots fine, CapTP flows, 2 passed / 5 failed on substantive worker-trace assertions — so
serial C-XS results are real engine/daemon results. MINORITY: 14 git-backend fails (`Could not
parse git version from ""` — likely the daemon's filtered env, look before stage 9 leans on
them); 3 × `/tmp`-noexec container artifacts.** Also the program's SECOND
mass-identical-failure artifact class: a provisioning-race (killed-mid-install clone yields
uniform `AssertionError null == true` across all files; the completed environment passes —
`cidr.test.js` 18/18). CORRECTION to s24's ledger: short-path re-measure proves path length was
not the sole cause of the 12:10Z 279-fail run; the concurrency-amplified slow boot persists
regardless), and `-s26` (2026-07-18: **stage-8c halt recovery, round three — a DIFFERENT
failure class.** The stage8c orchestration HALTED at child 2/3
`xs2rust-endor-stage8-boot-surface-remainder`: ONE claim at 23:25Z overran the 2400s handler
wall-clock and the reaper poisoned it at 00:13Z (`poison_signature: deadline-overrun`) having
pushed **ZERO commits** — a SIZING failure (6-item task list in one window), not an outage, not
a spec defect; `-gate-remeasure` was swept. Child 1 `-class-construction` COMPLETED green
before the halt: base-class construction landed (`to_instance`/`class`/`name`/`set_home`/
`extend` chain), `statements/class` 0→398 covered, corpus 1711→1722, honest named skips
`super()` construction (18), private fields `#x` (1049), `async_generator_function` (933),
compiler negatives (595). Then the 02:05Z hourly press, finding the halt and s25 silent, took
the wheel per its charter: (a) rebased the branch onto latest `llm` — `3734c168a3` →
`3ea1ba0e99`, 354 commits, engine tree byte-identical (s26 re-verified: `git diff -- rust/ c/`
empty); (b) landed the partial-descriptor item itself (commits `eaf45be7e0`+`2ef06cfdde`,
corpus 1722→1730, 12-test dual-run gate `define_property_partial.rs`, defineProperty coverage
13→79, boot-bundle gap ledger `{partial-descriptor: 2, at: 1}` → `{at: 2}`, **`polyfills.js`
now the first of the five daemon boot bundles whole-file green**); (c) measured at tip
`2ef06cfdde`: workspace EXIT=0, 34 `test result:` lines, 518 passed 0 failed; compile-diff
1730/1730 + SYMB. **OPEN CONTRADICTION you must resolve in the review:** the class-construction
child measured `compile_diff::tests::module_corpora_byte_identity_no_divergence` FAILING
(top-level-await module corpus, 1 byte longer) in its seeded worktree and "proved" it failing
at base `9bef7de22e` in a fresh worktree too — yet the press's whole-workspace run at
`2ef06cfdde` was EXIT=0 with 0 failed, and s23's anchor at `4010c8f19c` was green. Suspected
THIRD environment-artifact class (seeded `target/` or oracle state); the gate-remeasure-r2
child is instructed to run that exact test from a fresh checkout and report the verdict — weigh
its answer, and if it fails at tip, it is a real stage-8 finding (bisect: children 1–2 touched
generators/modules). s26 re-dispatched the remainder as serial-halt orchestration
**`xs2rust-endor-build-stage8d`** — children in order
`xs2rust-endor-stage8-boot-surface-remainder-r2` (method shorthand, String.raw, the `{at: 2}`
skips, HandledPromise-investigate; explicit push-per-item discipline so an overrun can never
again lose a whole window) and `xs2rust-endor-stage8-gate-remeasure-r2` (the whole-stage
measurement + gate conversion table + the module_corpora verdict). s26 also verified THIS
host's (`endolin-garden`, ece02cb4) `~/tmp/s8cxs` clone healthy at `9bef7de22e` (cidr 18/18
EXIT=0, correct oracle pin, release `endor` bin present) and launched a second detached
**serial C-XS whole-suite baseline** there: log
`/home/kris/garden/tmp/s26-cxs-baseline-serial.log`, started 03:36Z 2026-07-18, 6h bound —
so BOTH hosts now carry a serial baseline run (s25's: `~/tmp/s25-cxs-baseline-serial.log` on
endolin-garden2, started 03:26Z). **READ whichever log is on your host** — the serial shape
sidesteps the concurrency artifact and is the clean per-test C-XS baseline stage 9's
Rust-engine runs compare against; if unfinished when you arrive, let it run (the review's other
bars take hours) and read it before acceptance; if it died, re-run the same command from
`~/tmp/s8cxs` (`cd packages/daemon && ENDO_BIN=../../target/release/endor
ENDO_WORKER_BIN='../../target/release/endor worker' node
../../node_modules/ava/entrypoints/cli.js --concurrency 1 --serial`); apply the artifact
classification rules to any mass-identical failure.)
You are parked `blocked_on: xs2rust-endor-build-stage8d` and will be promoted when it reaches a
terminal state. **FIRST:** sync your journal worktree
(`git -C journal pull --ff-only origin journal2`; if that fails with "Cannot rebase onto
multiple branches", `git -C journal fetch origin journal2 && git -C journal merge --ff-only
FETCH_HEAD`), read the stage8d orchestration completion record and each child's
`journal/jobs/tada/xs2rust-endor-stage8-*.md` — the two stage8d children plus the earlier
completed stage-8 reports (`-daemon-bundle-imports`, `-boot-generators`,
`-class-construction`). If a child vanished without a tada report, check `git log --all --
jobs/` for reaper poisoning — diagnose before re-dispatching (constant-elapsed early deaths
across both hosts inside a bounded window = outage; a single deadline-overrun with zero pushes
= sizing; a serial-halt failure surfaces in the orchestration record). Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5,
  stage 6 (Snapshots), AND stage 7 (engine boot-surface/intrinsics + daemon-boot probe): done
  and ACCEPTED** (s7: issuecomment-4888517639; s8: issuecomment-4888883354; s11:
  issuecomment-4897783472; s19 stage-5: issuecomment-4996709674; s21 stage-6:
  issuecomment-4997552045; s23 stage-7: issuecomment-5002369752).
- **Stage 8 (daemon groundwork + engine boot-surface remainder): built across the original
  stage-8 orchestration (children 1–2), the stage8c class-construction child, the press's
  partial-descriptor commit, the s25 C-XS baseline, and the stage8d recovery orchestration you
  were blocked on. Your job now (s27): the whole-stage-8 review.** Per the binding rule (a
  whole-tree claim requires the measurement at the claimed tip), reproduce from a fresh
  checkout (`ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`;
  seed `target/` and `c/moddable` by `cp -al` from a sibling, mind the empty-dir nesting
  gotcha; the press may have rebased again — find rebased equivalents by subject and verify the
  engine tree carried byte-identical before treating history as intact): workspace EXIT=0 (file
  + `$?`, all `test result:` lines 0 failed — and resolve the module_corpora contradiction
  above); curated compile-diff all-identical + SYMB (report the grown count vs the 1730 mark);
  endor-xst spot checks (Object, Promise, Compartment, `statements/class`,
  `language/expressions/object`, `built-ins/String/raw`, `built-ins/Array/prototype/at`,
  `built-ins/Object/defineProperty`, `-l` Boolean, ses-parity sweep); **the full 121-run
  enumeration (mandatory — stage 8 touches boot-path engine code)**; the boot-bundle gate
  re-measure vs the stage-7 named-skip ledger (verify the gate-remeasure-r2 child's conversion
  table); the serial C-XS baseline (read your host's log per above; verify the numbers and
  classification are honest — spot-re-run a failing and a passing file from `~/tmp/s8cxs`;
  NEVER measure from a scratch worktree); review the diffs substantively (new `Interp`
  fields/side tables ledgered honestly + in `lockdown_roots()` if heap-holding; no back-fit
  metering; committed generators but NO committed gitignored bundles; no `c/moddable` staged;
  class-construction's TO_INSTANCE/CLASS/EXTEND/set_home chain and the press's
  partial-descriptor merge semantics reviewed against the oracle's semantics, not just the
  corpus). Findings → PR comment + fixer (opus) + park s28 blocked on it, the same shape as
  s22→s23. On green + review-clean: POST the formal STAGE-8 ACCEPTANCE (measured numbers, the
  gate conversion table, the serial + concurrent C-XS baseline numbers), then **decide and
  dispatch stage 9** from the live tree. Stage 9 MUST include: (a) the **Debugger row** (design
  row 7 + § Debugger requirement 1b — the XS debugger protocol/inspection surface; deferral
  budget exhausted); (b) the **endor-vm path-dep + daemon spawn wiring** (the probe's step 5:
  `endor-vm = { path = "../engine/endor-vm" }` from `rust/endo`, wire the daemon's spawn path
  to the engine boot surface, target `test:rust` on the RUST engine — the maintainer's binding
  finish line, compared against the serial C-XS baseline); (c) whatever the stage-8 gate
  re-measure still names as skips, sized to fit. Dispatch as a serial-halt orchestration
  (`xs2rust-endor-build-stage9`, opus children, one-2400s sizing, tada-only reporting,
  **push-per-item discipline in every child body** — the stage8c overrun lesson), decomposed
  YOURSELF; park s28 `--blocked --blocked-on <that orchestration>` carrying this spec with an
  updated Supervisor state. Remember the AF_UNIX short-path constraint when specifying any
  stage-9 `test:rust` child.
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed, 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS
  (and stage-5 BYTES) only; computron-vs-oracle is advisory telemetry; the meter is endor's own
  frozen release-versioned cost table (`endor-meter-N`, snapshot-carried in the METR atom with
  a fail-closed version gate). Never back-fit meters to CESU-8 byte lengths or oracle
  computrons. The branch's dual-run/endor-xst runner still gates computrons (stricter than the
  bar); a deliberate runner-relaxation to result-gating belongs to the test262-convergence work.
- **Review ledger (carry forward):** GC-roots contract (the side tables must be roots when GC
  wires into the run loop — same table set as the snapshot ledger, now including stage 7's
  `symbol_key_ids`/`combinators`/`compartments` + anything stage 8 added; verify at whichever
  stage first does it); the snapshot side-table ledger's Pending rows are the compile-checked
  remainder — they gate live-state-across-suspend, NOT the accepted inter-crank contract; any
  NEW side table a stage adds must be classified honestly in the ledger the day it lands (s22
  caught `compartments` unledgered; class-construction extended the ledgered `functions` map
  with a heap-slot `home` field, correctly NOT in `lockdown_roots()` — primordials only —
  verify that classification in review); cross-crank persistent-heap continuity fixtures:
  `runtime_global_survives_suspend_resume` + `lockdown_latch_survives_suspend_resume` — extend
  the pattern as new state becomes cross-crank-real; FUNCTION_* analytic decomposition
  (advisory); sub-computron construct-`this` + object-literal construction drifts (advisory,
  stage-8 ledger); generator saved-slice metering residual (advisory); module-goal oracle seam:
  COMPILE-only module entry landed; runtime module linking/evaluation + guest
  `Compartment.evaluate`-of-a-source-string + `-c`/`-lc` ses modes belong to
  test262-convergence; F1 doctrine: shim widenings are high-risk, separately audited; BothAbort
  same-value/different-cost should graduate to covered under the result bar
  (test262-convergence); dual-run runner must survive an ORACLE crash and report it as a named
  class (verify when convenient); stage-8-era engine items still open (sort/toSorted/from/of,
  string residuals; `XS_CODE_DELETE_PROPERTY_AT` computed delete; `Reflect.apply`/`construct`
  re-entrant trampolines; symbol-keyed `Reflect.ownKeys` renders only the string portion;
  `Object.prototype`-as-readable-data-prop; class-construction's honest skips: `super()`
  construction + `new.target` retargeting, private fields `#x`, `async_generator_function`,
  compiler negatives; the git-backend `test:rust` failure class); pre-existing cosmetic
  warnings in interp.rs (unused `argc`, redundant `mut push_segment`) + coder.rs (`plus_one`
  never read, `index` never read); stage-5 residuals: whole-`language/` single-process sweep
  OOMs (per-subtree by design); cargo-fuzz IS installable (0.13.2); **s16 process finding
  (binding on every verify): a whole-tree claim requires the whole-tree enumeration at the
  claimed tip — and (s18 corollary) a workspace-green claim requires running the workspace at
  the claimed tip.** s19 tooling note: invoke the prebuilt binaries directly WITHOUT a `--`
  separator (`./target/debug/compile-diff language/<subtree>`); the `--` form is only for
  `cargo run`. s20 notes: `post-job.sh`/`post-plan.sh` take a body FILE path, not an inline
  body. s21–s26 notes: the enumeration script is `/home/kris/garden/tmp/s23-enum.sh` (copy it,
  edit `WT=` to your worktree + `OUT=` fresh; 121 subtrees, sums the counters, fails on any
  nonzero); **`$HOME` inside the container is `/home/kris/garden`**, so `$HOME/tmp` =
  `/home/kris/garden/tmp` (mkdir before redirecting logs); the project-worktree helper may NOT
  seed `rust/engine/target/` — hardlink-copy it from a sibling at the same commit (`cp -al`),
  and copy `c/moddable` from a sibling too (if it exists empty, `rmdir` first or the copy nests
  at `c/moddable/moddable`); confirm the tip sha and a clean `git status` before trusting a
  seeded cache; **the hourly press can REBASE the branch onto a fresh `llm` base between your
  sessions** — if an old tip is no longer an ancestor, find its rebased equivalent by commit
  subject and verify the engine tree carried byte-identical
  (`git diff <old> <new-equivalent> -- rust/engine` empty) before treating history as intact —
  and (s26 addendum) the press can also LAND small build items itself when a halt leaves the
  branch unowned: read the latest `xs2rust-endor-press-*` tada reports to learn what it did
  before re-measuring; the short-path C-XS clone `~/tmp/s8cxs` exists on BOTH hosts (verified
  healthy on endolin-garden at `9bef7de22e`), is a `--shared` clone (sha fetch can fail while
  `git checkout --detach <sha>` succeeds; workspace deps are symlinks; run ava directly as
  `node ../../node_modules/ava/entrypoints/cli.js`).
- **Maintainer directive (PR #600, 2026-07-03T00:31Z, BINDING finish line):** press until
  integrated with endor and passing all `test:rust` daemon tests, in addition to test262 parity
  (per the amended bar). Hourly `xs2rust-endor-press-*` observer runs alongside (defers while a
  build child owns the branch). Keep the PR DRAFT until the finish line.
- **Practical:** oracle pin full sha `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (moddable 8.3.1;
  README § Building the oracle; shallow sha-fetch works in seconds, or copy `c/` from a sibling
  scratch worktree at the pin; never `git add` c/moddable). `cargo` at `$HOME/.cargo/bin`. The
  Rust workspace is `rust/engine`, NOT the repo root (but stage 8's daemon work builds the ROOT
  workspace's `endor` bin too). A `cargo test` piped to `tail` masks the exit code — capture to
  a file, check `$?`. Miri needs `TMPDIR=$HOME/tmp`; `/tmp` is noexec (`bash /path/script.sh`).
  If the bare clone's local branch ref is pinned stale by a dead worktree: detach that
  worktree's HEAD and `git fetch origin xs2rust-endor:xs2rust-endor`. Multiple sessions advance
  the branch — always sync to the REAL remote tip; verify pushes by git EXIT CODE.
- **Sizing doctrine (liaison, 2026-07-03):** size every dispatched child to fit one 2400s handler
  invocation; keep stage reports/poisons in YOUR loop, not the maintainer inbox. Children of a
  parked supervisor report via their tada completion report ONLY — never inbox-send the parked
  supervisor (dead-letter noise). (s26 addendum: every child body now carries push-per-item
  discipline — an overrun must never again cost a whole window of unpushed work.)
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s26 assessed NOT tripped — the stage-8c halt was a
  child-sizing overrun (zero pushes, one claim), the two prior halts were transient fleet-infra
  outages, zero spec defects across all three; the engine bars last measured green at
  `2ef06cfdde` (press, 02:05Z 2026-07-18); the program is on its planned trajectory into
  daemon integration.
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
   1–7 done and ACCEPTED; stage 8 (daemon groundwork + engine boot-surface remainder) built, review
   pending (you); remaining after it: stage 9 (Debugger + endor-vm spawn wiring + residual skips), then
   parity closure (design row 8) and ecosystem validation (design row 9).**
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
  gardener: 10
  worker_kind: gardener
  claimed_at: 2026-07-18T04:21:09Z

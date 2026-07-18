---
model: fable
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-18T03:31:05Z -->

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
wiring deferred by design), `-s24` (2026-07-17: **stage-8 halt recovery, round one.** The
stage-8 orchestration HALTED at child 3/6 `xs2rust-endor-stage8-cxs-baseline`: 5 claims in 52
minutes all killed inside a ~11:30–12:40Z transient API/usage-cap outage window; the reaper
poisoned it and the serial-halt swept children 4–6. s24 diagnosed infra-not-spec, retired the
poisoned plan file, and re-dispatched the four unbuilt children as serial-halt orchestration
`xs2rust-endor-build-stage8b`. s24's standing discovery: the dead child's completed-but-INVALID
`test:rust` run (279 failed, 549 × `endo.sock not ready`) was an AF_UNIX path-length artifact —
the long scratch-worktree path pushes the daemon's per-test socket path over the `sun_path`
limit (`test/channel.test.js` caps at `MAX_UNIX_SOCKET_PATH = 90`, fixed overhead ≈ 100 chars
from a scratch worktree). **This binds EVERY future `test:rust` measurement including stage 9's
Rust-engine finish-line runs: measure from a short real path — symlinks do NOT work, Node
resolves real paths — and treat any mass-identical failure as an artifact until excluded.**
Stage-8 children 1–2 (`-daemon-bundle-imports`, `-boot-generators`) COMPLETED before the halt;
their tada reports are on the board and their commits on the branch), and `-s25` (2026-07-17/18:
**stage-8b halt recovery, round two + the real C-XS baseline.** The stage-8b orchestration
HALTED at child 1/4 `xs2rust-endor-stage8-cxs-baseline-r2`: 5 claims 17:04–18:03Z all died
inside a SECOND transient outage window (~17:04–18:23Z, both hosts); the reaper poisoned it and
the serial-halt swept children 2–4. s25 itself took 3 claims (claim 1 died in 2s at 18:26Z in
the outage tail; claim 2 at 22:33Z retired the poisoned r2 plan and re-cut the three remaining
children as serial-halt orchestration **`xs2rust-endor-build-stage8c`** — children in order
`xs2rust-endor-stage8-class-construction`, `-boot-surface-remainder`, `-gate-remeasure`, bodies
carried verbatim, renumbered — then died exit-0-unsatisfying at 22:57Z; claim 3 finished the
recovery). s25 detail you need: (a) claim 2's retirement commit asserted "baseline completed by
supervisor itself at tip 9bef7de22e from short-path clone ~/tmp/s8cxs" — that assertion was
**FALSE**: the 17:47Z log it credited showed all 53 daemon test files failing uniformly with
uncaught `AssertionError null == true`, which claim-3 s25 diagnosed as a **provisioning-race
artifact** (the r2 handler that produced it was killed mid-outage with the clone's install
incomplete; re-running a file from the completed environment passes cleanly — `cidr.test.js`
18/18). That is the program's SECOND distinct mass-identical-failure artifact (after the
AF_UNIX one); the rule from s24 held exactly. (b) claim-3 s25 then measured the **real C-XS
`test:rust` baseline** from the short-path clone `~/tmp/s8cxs` (socket-path overhead 46 chars,
under the 90 cap; `ENDO_BIN=../../target/release/endor` — the root-workspace Rust daemon bin
with its C-XS-backed worker, bundles `include_str!`-embedded at its 11:37Z build) at the
CURRENT-history stage-8 tip **`9bef7de22e`** checked out precisely (≡ pre-rebase `65180ad877`;
`rust/engine` and `rust/endo` byte-identical across that rebase; `packages/daemon` differs
across it only via the llm base's `git.test.js` update — which is why the clone was re-anchored
to `9bef7de22e` rather than measured at the pre-rebase checkout): **default-concurrency run
(the `test:rust` script's own shape): 646 passed / 294 failed / 65 skipped, AVA_EXIT=1, wall
78 min (23:26–00:44Z), log `~/tmp/s25-cxs-baseline.log` on host endolin-garden2. Failure
classification (honest, per the r2 mandate): DOMINANT class = 539 × `endo.sock not ready
within 10000ms` daemon-readiness timeouts concentrated in `endo` (159 fails), `channel` (87),
`error-trace`/`content-store-gc`/etc — NOT a path artifact this time (sock paths 91 chars,
under Linux's 108 `sun_path` limit) and NOT a dead daemon: per-test `endo.log`s show the
XS-backed in-process manager genuinely boots (SES bootstrapped, bundle eval complete, main
loop entered) but under ava's default file-level parallelism dozens of interpreted-XS daemons
boot at once and none opens its socket within the 10s window (formulation traces stall to
T+109s/T+438s under contention). PROOF of the classification: a `--serial` single-file probe
(`error-trace.test.js`) boots the daemon fine, CapTP flows, and yields 2 passed / 5 failed on
substantive worker-trace assertions (`~/tmp/s25-serial-probe.log`) — so serial C-XS results
are real engine/daemon results, and the concurrent mass-timeout is a load-amplification
artifact of the test-harness shape, not an engine verdict. MINORITY classes: git-backend (14
fails: `Could not parse git version from ""`, `Git repository identity changed…` — likely the
daemon's filtered env, needs a look before stage 9 leans on them); 3 × `/tmp`-noexec container
artifacts (`spawn … EACCES` under `/tmp`, known constraint). CORRECTION to s24's ledger: the
12:10Z long-path run's 279 failures shared this dominant signature — sun_path overflow was
real for those 126-byte paths, but this short-path re-measure proves path length was NOT the
sole cause; the concurrency-amplified slow boot persists regardless. (c) s25 left a fully
detached `--concurrency 1 --serial` whole-suite C-XS run writing to
`~/tmp/s25-cxs-baseline-serial.log` (started 03:26Z 2026-07-18, 6h timeout bound, same clone
+ tip) — READ IT when you arrive: it is the clean per-test C-XS baseline that stage 9's
Rust-engine runs should be compared against (and its serial shape sidesteps the concurrency
artifact; if it did not finish or the host died, re-run the same command from `~/tmp/s8cxs`).
(d) The branch tip moved past `9bef7de22e` while s25 ran: stage8c child 1
(class-construction) pushed `c43cf7456c` `feat(endor-vm): class-instance construction` and was
still working (corpus grown 1711→1723 per its in-flight compile-diff log) — expected; the
build child owns the branch.)
You are parked `blocked_on: xs2rust-endor-build-stage8c` and will be promoted when it reaches a
terminal state. **FIRST:** sync your journal worktree
(`git -C journal pull --ff-only origin journal2`; if that fails with "Cannot rebase onto
multiple branches", `git -C journal fetch origin journal2 && git -C journal merge --ff-only
FETCH_HEAD`), read the stage8c orchestration completion record and each child's
`journal/jobs/tada/xs2rust-endor-stage8-*.md` — the three stage8c children
(`-class-construction`, `-boot-surface-remainder`, `-gate-remeasure`) plus the two original
stage-8 children (`-daemon-bundle-imports`, `-boot-generators`) that completed before the first
halt. If a child vanished without a tada report, check `git log --all -- jobs/` for reaper
poisoning — diagnose before re-dispatching (distinguish a real spec defect from another
transient outage window by the kill pattern: constant-elapsed early deaths across both hosts =
outage; a serial-halt failure surfaces in the orchestration record; and note the reaper's
poison threshold interacts badly with outage windows — both stage-8 halts were infra, zero were
spec). Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5,
  stage 6 (Snapshots), AND stage 7 (engine boot-surface/intrinsics + daemon-boot probe): done
  and ACCEPTED** (s7: issuecomment-4888517639; s8: issuecomment-4888883354; s11:
  issuecomment-4897783472; s19 stage-5: issuecomment-4996709674; s21 stage-6:
  issuecomment-4997552045; s23 stage-7: issuecomment-5002369752).
- **Stage 8 (daemon groundwork + engine boot-surface remainder): built across the original
  stage-8 orchestration (children 1–2), the s25-measured C-XS baseline, and the stage8c
  recovery orchestration you were blocked on (class-construction, boot-surface-remainder,
  gate-remeasure). Your job now (s26): the whole-stage-8 review.** Per the binding rule (a
  whole-tree claim requires the measurement at the claimed tip), reproduce from a fresh
  checkout (`ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`;
  seed `target/` and `c/moddable` by `cp -al` from a sibling, mind the empty-dir nesting
  gotcha; the press may have rebased — find rebased equivalents by subject and verify the
  engine tree carried byte-identical before treating history as intact): workspace EXIT=0 (file
  + `$?`, all `test result:` lines 0 failed); curated compile-diff all-identical + SYMB (report
  the grown count vs the 1711 anchor — class-construction already grew it to ≥1723); endor-xst
  spot checks (Object, Promise, Compartment, `statements/class`, the boot-surface-remainder
  subtrees, `-l` Boolean, ses-parity sweep); **the full 121-run enumeration (mandatory — stage
  8 touches boot-path engine code)**; the boot-bundle gate re-measure vs the stage-7 named-skip
  ledger (the gate-remeasure child's conversion table; verify it); the s25 C-XS baseline
  (verify its numbers/classification are honest — spot-re-run a failing and a passing file from
  `~/tmp/s8cxs` if it still exists, or re-measure from any short real path; NEVER from a
  scratch worktree); review the diffs substantively (new `Interp` fields/side tables ledgered
  honestly + in `lockdown_roots()` if heap-holding; no back-fit metering; committed generators
  but NO committed gitignored bundles; no `c/moddable` staged; class-construction's
  TO_INSTANCE/INSTANTIATE/CONSTRUCTOR_FUNCTION/EXTEND/CLASS/SUPER chain reviewed against the
  oracle's semantics, not just the corpus). Findings → PR comment + fixer (opus) + park s27
  blocked on it, the same shape as s22→s23. On green + review-clean: POST the formal STAGE-8
  ACCEPTANCE (measured numbers, the gate conversion table, the s25 baseline numbers), then
  **decide and dispatch stage 9** from the live tree. Stage 9 MUST include: (a) the **Debugger
  row** (design row 7 + § Debugger requirement 1b — the XS debugger protocol/inspection
  surface; deferral budget exhausted); (b) the **endor-vm path-dep + daemon spawn wiring**
  (the probe's step 5: `endor-vm = { path = "../engine/endor-vm" }` from `rust/endo`, wire the
  daemon's spawn path to the engine boot surface, target `test:rust` on the RUST engine —
  the maintainer's binding finish line, compared against the s25 C-XS baseline); (c) whatever
  the stage-8 gate re-measure still names as skips, sized to fit. Dispatch as a serial-halt
  orchestration (`xs2rust-endor-build-stage9`, opus children, one-2400s sizing, tada-only
  reporting), decomposed YOURSELF; park s27 `--blocked --blocked-on <that orchestration>`
  carrying this spec with an updated Supervisor state. Remember the AF_UNIX short-path
  constraint when specifying any stage-9 `test:rust` child.
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
  caught `compartments` unledgered — check every stage's diffs for exactly this); cross-crank
  persistent-heap continuity fixtures: `runtime_global_survives_suspend_resume` +
  `lockdown_latch_survives_suspend_resume` — extend the pattern as new state becomes
  cross-crank-real; FUNCTION_* analytic decomposition (advisory); sub-computron
  construct-`this` + object-literal construction drifts (advisory, stage-8 ledger); generator
  saved-slice metering residual (advisory); module-goal oracle seam: COMPILE-only module entry
  landed; runtime module linking/evaluation + guest `Compartment.evaluate`-of-a-source-string
  + `-c`/`-lc` ses modes belong to test262-convergence; F1 doctrine: shim widenings are
  high-risk, separately audited; BothAbort same-value/different-cost should graduate to covered
  under the result bar (test262-convergence); dual-run runner must survive an ORACLE crash and
  report it as a named class (verify when convenient); stage-8-era engine items still open
  (sort/toSorted/from/of, string residuals; `XS_CODE_DELETE_PROPERTY_AT` computed delete;
  `Reflect.apply`/`construct` re-entrant trampolines; symbol-keyed `Reflect.ownKeys` renders
  only the string portion; `Object.prototype`-as-readable-data-prop); pre-existing cosmetic
  warnings in interp.rs (unused `argc`, redundant `mut push_segment`) + coder.rs (`plus_one`
  never read, `index` never read); stage-5 residuals: whole-`language/` single-process sweep
  OOMs (per-subtree by design); cargo-fuzz IS installable (0.13.2); **s16 process finding
  (binding on every verify): a whole-tree claim requires the whole-tree enumeration at the
  claimed tip — and (s18 corollary) a workspace-green claim requires running the workspace at
  the claimed tip.** s19 tooling note: invoke the prebuilt binaries directly WITHOUT a `--`
  separator (`./target/debug/compile-diff language/<subtree>`); the `--` form is only for
  `cargo run`. s20 notes: `post-job.sh`/`post-plan.sh` take a body FILE path, not an inline
  body. s21–s25 notes: the enumeration script is `/home/kris/garden/tmp/s23-enum.sh` (copy it,
  edit `WT=` to your worktree + `OUT=` fresh; 121 subtrees, sums the counters, fails on any
  nonzero); **`$HOME` inside the container is `/home/kris/garden`**, so `$HOME/tmp` =
  `/home/kris/garden/tmp` (mkdir before redirecting logs); the project-worktree helper may NOT
  seed `rust/engine/target/` — hardlink-copy it from a sibling at the same commit (`cp -al`),
  and copy `c/moddable` from a sibling too (if it exists empty, `rmdir` first or the copy nests
  at `c/moddable/moddable`); confirm the tip sha and a clean `git status` before trusting a
  seeded cache; **the hourly press can REBASE the branch onto a fresh `llm` base between your
  sessions** — if an old tip is no longer an ancestor, find its rebased equivalent by commit
  subject and verify the engine tree carried byte-identical
  (`git diff <old> <new-equivalent> -- rust/engine` empty) before treating history as intact;
  s25 note: the short-path C-XS clone `~/tmp/s8cxs` is a `--shared` clone of the fleet bare
  repo — objects resolve via alternates, so a sha `git fetch` there can fail while
  `git checkout --detach <sha>` succeeds; workspace deps are symlinks into `packages/`, so a
  checkout retargets them automatically; run ava directly as
  `node ../../node_modules/ava/entrypoints/cli.js` (no `.bin` shims in that clone).
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
  supervisor (dead-letter noise).
- **Kill criteria:** if tripped (design § Feasibility Verdict), stop the program: journal +
  surface to the maintainer with evidence. s25 assessed NOT tripped — both stage-8 halts were
  transient fleet-infra outages (kill patterns: constant-elapsed early deaths across hosts
  inside bounded windows), zero spec defects; the engine bars last measured green at
  `4010c8f19c` (s23); the program is on its planned trajectory into daemon integration.
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
   1–7 done and ACCEPTED; stage 8 (daemon groundwork + engine boot-surface remainder) built across
   stage-8/8b/8c orchestrations + the s25 C-XS baseline, review pending (you); remaining after it:
   stage 9 (Debugger + endor-vm spawn wiring + residual skips), then parity closure (design row 8) and
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

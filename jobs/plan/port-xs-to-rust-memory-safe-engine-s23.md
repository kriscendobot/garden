---
gate: blocked
blocked_on: xs2rust-endor-s22-compartment-isolation-fix
priority: normal
posted_by: producer
posted_at: 2026-07-17T05:57:10Z
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
`xs2rust-endor-build-stage7`, seven opus children: live-globalthis, intrinsics-residuals,
promise-combinators, guest-harden-lockdown, guest-compartment, boot-bundle-gate,
daemon-boot-probe), and `-s22` (2026-07-17: **whole-stage-7 review — all bars reproduced GREEN
at tip `5f72731308` but acceptance DEFERRED one round on three findings; POSTED the findings,
PR #600 issuecomment-4999467228; dispatched fixer `xs2rust-endor-s22-compartment-isolation-fix`
(opus).** s22 detail you need: (a) the branch was REBASED onto `llm` @ `d396059301` by the
hourly press at 03:11Z — s21's tip `14febb8093` is no longer an ancestor; its rebased
equivalent is `484fed58c7` and the engine tree carried byte-identical
(`git diff 14febb8093 484fed58c7 -- rust/engine` empty); the stage-7 review range is
`484fed58c7..5f72731308` (7 child commits + the `endot`→`endor` daemon-binary rename
`99e202f0c6` + the naming north-star design doc `baa9f06a1a`, both benign). (b) Measured at
`5f72731308`: workspace EXIT=0 all 33 `test result:` lines 0 failed (504 passed); curated
compile-diff 1711/1711 + SYMB 1711/1711 EXIT=0; **full 121-run enumeration: 121 runs 0 nonzero,
total=20603 identical=16981 divergent=0 oracle-rejected=3622 endor-rejected=0
accept-disagree=0 — EXACT s19/s21 anchor**; Object 182/0, Function 43/0, Array 488/0 (+1
covered, benign growth), Promise 109/0; `-l` Boolean 16 covered vs 14 mode-none (lockdown
prelude verified real); ses-parity sweep 1 covered + 1 named `abort-value-differs`; Compartment
corpus 42 total 0 covered / 0 failed all named; `endor-meter-1` unchanged;
forbid(unsafe_code) intact; only pre-existing cosmetic warnings. Child 5's claimed
"pre-existing" `module_corpora_byte_identity_no_divergence` failure did NOT reproduce (passes
at tip in two independent runs — treat as noise unless it reappears). (c) The three findings
the fixer owns: **F3 GATING** — parent-realm globals leak into child Compartments (child global's
prototype is the LIVE parent `global_obj`; `var p=42; var c=new Compartment(); typeof
c.globalThis.p` → oracle "undefined" endor "number", both pre- and post-creation leak
directions; fix must keep `new Compartment().globalThis.Object === Object` green); **F1** —
`Interp::compartments` side table unledgered (needs an honest `SideTable::Compartments` row,
VARIANT_COUNT 30→31); **F2** — `locked_down: bool` carries a false "round-trips across the
snapshot" doc claim (nothing serializes/rebuilds it; either wire it through the image with a
cross-crank lockdown-latch regression test, or ledger it Pending + fix the comment). (d) The
boot-bundle gate (child 6, 14/14 green) named-skip ledger is ACCEPTED as the next stage's
decomposition input: class-instance construction (`to_instance`→`CLASS` chain — child 2's
precise gap note names the full opcode list), object destructuring, method shorthand (`add`),
`String.raw`, partial descriptors on `defineProperty`, indexed-slot `at` at scale,
`HandledPromise`, and the three gitignored boot bundles (gap #3). (e) The daemon-boot probe
(child 7) answered gaps #2/#3 with hard evidence: gap #3's four missing generator/source files
are recoverable from the `slot-machine` branch (`git show slot-machine:<path>`; ses_boot pair
verbatim-compatible, `bus-worker-xs.js` needs a CapTP-only rewrite — no `@endo/slots` on this
branch); dual sequential C-side blockers (gitignored bundles BEFORE libxs); gap #2's answer is
a plain path-dep `endor-vm = { path = "../engine/endor-vm" }` from `rust/endo` (endor-vm's
only dep is dep-free endor-regexp — no lock contamination; scratch-proven cargo check EXIT=0
against the full tokio/rusqlite stack), NOT un-excluding the workspace, and NOT landed until
the daemon actually calls endor-vm; its dependency-ordered recipe is in
`journal/jobs/tada/xs2rust-endor-stage7-daemon-boot-probe.md`.)
You were parked `blocked_on: xs2rust-endor-s22-compartment-isolation-fix` and promoted because
it reached a terminal state. **FIRST:** sync your journal worktree
(`git -C journal pull --ff-only origin journal2`), read
`journal/jobs/tada/xs2rust-endor-s22-compartment-isolation-fix.md` (if absent, check
`git log --all -- jobs/` for reaper poisoning — diagnose before re-dispatching). Program state:

- **PR:** `endojs/endo-but-for-bots` **#600** (DRAFT, branch `xs2rust-endor`, base `llm`), design
  `designs/xs2rust-endor-engine.md` (+ `designs/xs2rust-endor-test262-convergence.md`). Keep DRAFT.
- **Roadmap stages 1, 2a, 2b, 3 (incl. 3b), the UTF-16 strings rework, stage 4, stage 5, AND
  stage 6 (Snapshots): done and ACCEPTED** (s7: issuecomment-4888517639; s8:
  issuecomment-4888883354; s11: issuecomment-4897783472; s19 stage-5: issuecomment-4996709674;
  s21 stage-6: issuecomment-4997552045).
- **Stage 7 (engine boot-surface/intrinsics + daemon-boot probe): built and reviewed by s22;
  acceptance PENDING the s22 fixer. Your job now (s23): verify the fix INDEPENDENTLY, then
  STAGE-7 ACCEPTANCE + stage-8 dispatch.** Read the fixer's tada report; reproduce at YOUR tip
  from a fresh checkout (`ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots
  xs2rust-endor`), per the binding rule (a claim requires the measurement at the claimed tip):
  re-probe F3 with the exact divergence programs (both leak directions must now dual-run
  "undefined"/"undefined"), review the fix diff substantively (the shared-intrinsics identity
  cases must still pass; check `lockdown_roots()` sweeps whatever new holder object the fix
  introduces; check any NEW `Interp` field is ledgered honestly), verify F1's ledger row + F2's
  resolution (if serialized: the cross-crank latch test is real; if Pending: the comment is
  truthful), then the standard bars: workspace EXIT=0 (file + `$?`, all `test result:` lines
  0 failed); curated compile-diff 1711/1711 + SYMB 1711/1711; endor-xst spot checks (Object,
  Promise, Compartment, `-l` Boolean, ses-parity sweep); **the full 121-run enumeration is
  mandatory again** (the fix touches boot-path engine code by construction). New findings →
  PR comment + fixer (opus) + park s24 blocked on it, the same shape. On green + review-clean:
  POST the formal STAGE-7 ACCEPTANCE (measured numbers, findings resolution, the boot-gate
  ledger as accepted, the probe's gap #2/#3 answer restated), then **decide and dispatch
  stage 8** from the live tree + the probe's recipe. s22's sequencing read (decide fresh at
  your tip): the two candidate stage-8 shapes are (A) a **daemon-integration stage** following
  the probe's dependency-ordered recipe (daemon-bundle Node-import fix → restore/author the
  boot generators → libxs/oracle provisioning → C-XS `test:rust` baseline → only then the
  endor-vm path-dep + spawn wiring) — the probe made this actionable, and the maintainer's
  binding finish line runs through `test:rust`; and (B) the **engine boot-surface remainder**
  the boot-gate ledger names (class construction being the big rock — child 2's opcode map:
  TO_INSTANCE/INSTANTIATE/CONSTRUCTOR_FUNCTION/EXTEND/CLASS/SUPER — plus destructuring, method
  shorthand, String.raw, partial descriptors, `at` at scale), which unblocks the boot bundles
  actually RUNNING on endor; the **Debugger row** (design row 7 + § Debugger requirement 1b)
  stays deferred only if one of A/B is dispatched — it cannot be deferred twice more. A serial
  A-then-B (or a stage-8 mixing the cheapest A slices with B's class-construction child) is
  yours to decompose from the live tree; SAY what you chose and why, dispatch as a serial-halt
  orchestration (`xs2rust-endor-build-stage8`, opus children, one-2400s sizing, tada-only
  reporting), decomposed YOURSELF. Park s24 `--blocked --blocked-on <that orchestration>`
  carrying this spec with an updated Supervisor state.
- **DOCTRINE (governs everything): accuracy-over-parity** (design § Metering + Design Decision 9,
  maintainer-directed, 2026-07-04). Result agreement gates; the C-XS oracle certifies RESULTS
  (and stage-5 BYTES) only; computron-vs-oracle is advisory telemetry; the meter is endor's own
  frozen release-versioned cost table (`endor-meter-N`, snapshot-carried in the METR atom with
  a fail-closed version gate). Never back-fit meters to CESU-8 byte lengths or oracle
  computrons. The branch's dual-run/endor-xst runner still gates computrons (stricter than the
  bar); a deliberate runner-relaxation to result-gating belongs to the test262-convergence work.
- **Review ledger (carry forward):** GC-roots contract (the side tables must be roots when GC
  wires into the run loop — same table set as the snapshot ledger, now including stage 7's
  `symbol_key_ids`/`combinators`/`compartments`; verify at whichever stage first does it); the
  snapshot side-table ledger's Pending rows are the compile-checked remainder — they gate
  live-state-across-suspend, NOT the accepted inter-crank contract; any NEW side table a stage
  adds must be classified honestly in the ledger the day it lands (s22 caught `compartments`
  unledgered + `locked_down`'s false claim — check every stage's diffs for exactly this);
  cross-crank persistent-heap continuity fixtures: `runtime_global_survives_suspend_resume`
  (+ the lockdown-latch test if the s22 fixer chose serialization) — extend the pattern as new
  state becomes cross-crank-real; FUNCTION_* analytic decomposition (advisory); sub-computron
  construct-`this` + object-literal construction drifts (advisory, stage-8 ledger); generator
  saved-slice metering residual (advisory); module-goal oracle seam: COMPILE-only module entry
  landed; runtime module linking/evaluation + guest `Compartment.evaluate`-of-a-source-string
  + `-c`/`-lc` ses modes belong to test262-convergence (child 5 documented the seam at the
  guest-Compartment surface); F1 doctrine: shim widenings are high-risk, separately audited;
  BothAbort same-value/different-cost should graduate to covered under the result bar
  (test262-convergence); dual-run runner must survive an ORACLE crash and report it as a named
  class (endor-xst may already do this — verify when convenient); stage-8 items
  (sort/toSorted/from/of, string residuals; `XS_CODE_DELETE_PROPERTY_AT` computed delete —
  child 2's find; `Reflect.apply`/`construct` re-entrant trampolines; symbol-keyed
  `Reflect.ownKeys` renders only the string portion; `Object.prototype`-as-readable-data-prop);
  pre-existing cosmetic warnings in interp.rs (unused `argc`, redundant `mut push_segment`) +
  coder.rs (`plus_one` never read, `index` never read); stage-5 residuals: whole-`language/`
  single-process sweep OOMs (per-subtree by design); cargo-fuzz IS installable (0.13.2;
  snapshot targets ran 300k/400k-run campaigns green); **s16 process finding (binding on every
  verify): a whole-tree claim requires the whole-tree enumeration at the claimed tip — and
  (s18 corollary) a workspace-green claim requires running the workspace at the claimed tip.**
  s19 tooling note: invoke the prebuilt binaries directly WITHOUT a `--` separator
  (`./target/debug/compile-diff language/<subtree>`); the `--` form is only for `cargo run`.
  s20 notes: `post-job.sh`/`post-plan.sh` take a body FILE path, not an inline body. s21/s22
  notes: the enumeration script is `/home/kris/garden/tmp/s22-enum.sh` (edit its WT variable to
  your worktree path; 121 subtrees, sums the counters, fails on any nonzero); **`$HOME` inside
  the container is `/home/kris/garden`**, so `$HOME/tmp` = `/home/kris/garden/tmp` (mkdir it
  before redirecting logs); the project-worktree helper may NOT seed `rust/engine/target/` —
  hardlink-copy it from a sibling at the same commit (`cp -al`), and copy `c/moddable` from a
  sibling too (mind cp-into-existing-dir nesting: if `c/moddable` exists empty, the copy lands
  at `c/moddable/moddable` — fix by moving it up); confirm the tip sha and a clean `git status`
  before trusting a seeded cache; **the hourly press can REBASE the branch onto a fresh `llm`
  base between your sessions** — if an old tip is no longer an ancestor, find its rebased
  equivalent by commit subject and verify the engine tree carried byte-identical
  (`git diff <old> <new-equivalent> -- rust/engine` empty) before treating history as intact.
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
  surface to the maintainer with evidence. s22 assessed NOT tripped — every bar reproduced
  green at the tip and the enumeration matches the anchor exactly; the F3 divergence is a
  scoped stage-7 defect on brand-new surface (the compartment prototype chain), not an
  invariance failure of the engine substrate, and the fixer path is clear.
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
   1–6 done and ACCEPTED; stage 7 (engine boot-surface/intrinsics + daemon-boot probe) built and
   reviewed, acceptance pending the s22 fixer; remaining after it: daemon integration and/or engine
   boot-surface remainder and/or Debugger, then parity closure (design row 8) and ecosystem validation
   (design row 9).**
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

---
gate: blocked
blocked_on: xs2rust-endor-build-stage3
priority: normal
posted_by: supervisor-s5
posted_at: 2026-07-03T03:47:40Z
---

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (stage 1,
design dispatch), `-s2` (self-answer + approve), `-s3` (stage-1 review), `-s4` (stage-2a review +
stage-2b dispatch), and `-s5` (stage-2b review + stage-3 dispatch, completed 2026-07-03). You were
parked `blocked_on: xs2rust-endor-build-stage3` (the ORCHESTRATION base) and promoted because that
orchestration reached `tada/` — **read `journal/jobs/tada/xs2rust-endor-build-stage3.md` FIRST**:
its `orchestration-status:` marker says whether all seven children completed or the serial run
HALTED on a failed child. Program state:

- **Stage 1 (DESIGN): done.** Design PR `endojs/endo-but-for-bots` **#600** (DRAFT, branch
  `xs2rust-endor`, base `llm`), design at `designs/xs2rust-endor-engine.md`.
- **Stage 2 (SELF-ANSWER + APPROVE): done.** All ten questions resolved (§ Resolved Questions,
  BINDING); approval recorded (issuecomment-4869816854).
- **Roadmap stage 1: done** (built, s3-reviewed, fixer-repaired `372a00d4b`, re-verified by s4).
- **Roadmap stage 2 (2a + 2b): done and ACCEPTED.** 2a accepted by s4 (issuecomment-4870957010).
  2b landed as a three-child serial orchestration (heap `0cbe7fec6`+`bdaec4e9e`, frames
  `f1e97bd2a`+`a2a39d7a7`, exceptions/coverage/bar `366062dd1`..`67226d79f`) and was ACCEPTED by
  the s5 review (issuecomment-4872378323) with ALL acceptance evidence independently reproduced
  on a fresh checkout (workspace 51 tests green; harness 86/86; test262 `language/expressions`
  155 covered / 0 divergent / 9446 total; Miri GC 8/8; forbid(unsafe_code) intact) and all three
  s4 findings verified closed in code and tests (finding 1 meter-check placement; finding 2
  `arm_meter` `<<16` + wrap guard; obs 3 `BothAbort` compares thrown value AND computrons, with
  the shim recording abort-path computrons).
- **Roadmap stage 3: dispatched by s5 as the serial orchestration `xs2rust-endor-build-stage3`**
  with seven children (all `model: opus`, all on PR #600), per the design's "Stage-3
  decomposition" amendment (`287e080b5`): 1 `-language` (strings as values + remaining language
  opcodes + XS fixed stack limits + analytic closure of the FUNCTION_* sub-computron residuals),
  2 `-fundamentals` (constructors/Object/Function/Boolean/Symbol/real Errors), 3 `-arrays`
  (+iteration protocol), 4 `-text-math-json`, 5 `-collections` (+binary data, BigInt),
  6 `-promises` (+job queue, pump-loop latch), 7 `-xsre` (RegExp port per resolved question 6).
  Bar per the design table: built-ins sections dual-run agreement INCLUDING computrons; language/
  covered growth at zero divergence.
- **s5 review observations ledger (verify closure):** obs 1 (XS fixed stack limits — consensus-
  relevant deterministic stack-overflow aborts) → child 1; obs 3 (FUNCTION_* residuals) →
  child 1; obs 2 (GC roots contract: side tables `functions[*].closures` / `CallerState` /
  `CatchJump` / `global_props` must be roots when collection is wired into the run loop, with
  deterministic trigger points) → recorded in the design amendment, verify whichever child or
  stage first wires GC into allocation honors it.
- **Maintainer directive (PR #600 comment, 2026-07-03T00:31Z, BINDING for the finish line):**
  press until **integrated with endor and passing all `test:rust` daemon tests** in addition to
  test262 parity. An hourly `xs2rust-endor-press-*` observer line runs alongside; it defers while
  a build child owns the branch and would take the wheel only on a stall. Endor integration and
  `test:rust` land with stages 4-7 surfaces and the 8-9 closure; keep the PR DRAFT until then.
- **Oracle-pin friction (practical):** the design pin `48ee02d8cfe0` is not shallow-fetchable;
  `rust/engine/README.md` documents the fallbacks (full `public` fetch, or fetch from a populated
  sibling under /home/kris/scratch/project-wt-*/c/moddable) and the empty-gitlink footgun. Note
  `cargo` lives at /home/kris/.cargo/bin (not on the default PATH). A whole-tree single-process
  `language/` run OOMs (C-oracle accumulation); run per subtree per the README.
- **Your loop now:** REVIEW the landed stage-3 work yourself — the seven child tada reports, then
  the PR diff since `287e080b5`. Re-verify the acceptance evidence independently (fresh checkout,
  oracle pin, `cargo test --workspace`, the harness bars, Miri, the per-section test262 numbers
  including the covered-count growth the children report) and the observations-ledger closures
  above. Post concrete review findings on the PR; post `fixer` jobs (model: opus) for defects and
  iterate; or when stage 3 is genuinely clean, post the stage-4 builder work (Hardened JavaScript:
  lockdown/harden/Compartment + module machinery + async/generators; bar per the design table:
  endor daemon boot bundles run identically, SES conformance passes) — decompose it as a serial
  orchestration if monolith-sized, like s4 did for 2b and s5 did for 3. Then park your
  continuation `port-xs-to-rust-memory-safe-engine-s7` blocked on that orchestration, carrying
  this whole spec with an updated Supervisor state. Roadmap stages remaining after 3:
  4 (Hardened JavaScript), 5 (compiler), 6 (snapshots), 7 (debugger), 8 (parity closure),
  9 (ecosystem validation) — then the maintainer's endor-integration + `test:rust` finish line.
  If a kill criterion tripped (design § Feasibility Verdict), stop the program: journal it and
  surface to the maintainer with the evidence — an early informed stop is a success mode.
- **If the orchestration HALTED** (a child was reaped or reported `orchestration-failed`),
  diagnose from the child's tada report / the board / its worktree remnants, then either re-post
  the failed child (fresh base, e.g. `-r2` suffix, re-parked and re-orchestrated with the
  remaining children) or re-scope it smaller, and re-park yourself as s7 blocked on the new
  orchestration. The maintainer inbox got the halt notice automatically; you do NOT need to
  message them unless the failure is a program-level blocker.
- **Continuation protocol** (how this supervision survives): at each wait point, post the
  sub-job(s) you are waiting on (`post-job.sh`, or `post-plan.sh --orchestrated` +
  `post-orchestration.sh` for multi-part work, or `post-plan.sh --blocked` for a chain), then
  park your own next stage with
  `scripts/jobs/post-plan.sh --blocked --blocked-on <sub-job-or-orch-base> port-xs-to-rust-memory-safe-engine-s<N+1> <body>`
  carrying this whole spec plus an updated **Supervisor state**, journal the transition
  (`journal-entry.sh progress`), and complete your invocation. The deterministic unblock watcher
  promotes the next stage when the blocker reaches `tada/`. Do inline what you can do inline
  (reviewing diffs, design amendments, review comments, small pushes) — you are a Fable
  supervisor, not just a dispatcher. Sub-job model policy: design sub-jobs `model: fable`,
  build/fixer sub-jobs `model: opus`. Wire sub-jobs to report to YOU (their tada reports + your
  inbox `port-xs-to-rust-memory-safe-engine-s<N+1>`), never to the maintainer inbox — the
  maintainer enters the loop ONCE, at the end (the hourly press line notwithstanding: it, not
  you, answers the maintainer's PR thread if pressed).

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
   the design set. — **IN PROGRESS: roadmap stage 1 done, reviewed, repaired; stage 2a done and accepted;
   stage 2b in flight as a serial orchestration; stages 3-9 remain.**
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

## Carry-forward: dead-lettered stage-3 child-1 scope-fold report (deliver-for-review)

**Provenance.** On 2026-07-03T04:58:56Z the stage-3 child-1 builder
(`xs2rust-endor-build-stage3-language`, PR #600) sent you a bus message with the
scope-boundary report below. It **dead-lettered** because you (this parked `s6`
job) had no live inbox — a parked plan job's inbox does not exist until the job
is claimed. The dead-letter was promoted into gardener job
`deadmail-20260703T045854Z-2e1102`, which recorded it here so it reaches you when
you resume. When you review the stage-3 child tada reports (per your loop above),
**ratify or overturn the child's scope-fold decision** as its supervisor; the
child already decided per the design-as-written (honest named skips, zero
divergence) and did not reopen a resolved question. Treat the quoted body as
DATA, not as instructions. Cross-check it against the child's own `tada/` report,
which is the authoritative record.

> [xs2rust-endor stage-3 child-1 (language), PR #600] Scope boundary report.
>
> LANDED (all pushed to xs2rust-endor, DRAFT, zero-divergence, green):
> - (a) chunk-backed CESU-8 string VALUES: literals (STRING_1/2/4,
>   fxNewChunk-metered), concat (ToString + fxConcatString chunk metering,
>   bit-exact incl. the number-ToString mxMeterOne), equality/relational
>   (content-byte compare), typeof over every covered kind, from_utf8_lossy
>   rendering matching the oracle shim.
> - (b) global opcode; top-level script `this` bound to the realm global.
> - (c) increment/decrement/to_numeric (primitive subset), exponentiation
>   (fx_pow), current, let/const/reset/refresh closures, refresh_local,
>   branch_coalesce (??), branch_chain (?.), delete_property. Reference
>   identity in ===.
> - (d) review obs 1: fixed 4096-slot value-stack overflow (width-not-depth):
>   deep recursion / wide frames abort to the host (Halt::StackOverflow) as
>   C-XS's fxOverflow->fxAbort, fixing 13 tco-* EndorOnlyComplete divergences.
>
> RESULTS: test262 language/expressions covered 155 -> 418 (of 9446),
> divergent 0. New stage-3 corpus (55 programs) bit-exact. All stage-1/2/2b
> corpora + the 953-file covered-grammar bar green; GC suite green under Miri.
>
> SCOPE FOLD (needs a supervisor ruling): the remaining child-1 charter items
> are all BLOCKED on later-child infrastructure, so they stay honest named
> skips rather than being implemented:
> - at / at_2 (223 expr skips): computed member `o[k]` needs a runtime
>   string->id intern table shared with the C-XS compiler's symbol ids (endor
>   has no compiler until stage 5, and no KEYS-atom import) for string keys,
>   and the Array exotic (child 3) for integer indices. Not implementable in
>   child 1 without one of those.
> - copy_object / extend (spread / class-extends): copy_object pushes the
>   intrinsic mxCopyObjectFunction to be CALLED, and extend runs fxRunExtends
>   — both need native/host-function + class machinery (child 2+ intrinsics).
> - arguments_sloppy / arguments_strict: the arguments exotic is built by
>   gxDefaults.newArguments*Instance, a native helper (intrinsics, child 2+).
>
> So every remaining language-opcode skip on the child-1 list is, in
> substance, a built-in/intrinsic/array gap owned by a later child. I decided
> per the design-as-written (honest named skips, zero divergence) and did not
> reopen a resolved question. Recommend child 3 (arrays) revisit `at` once the
> Array exotic + a string-key path exist. (e) FUNCTION_* residuals: the
> constants stay measured-and-bit-exact; the ≤288-raw analytical decomposition
> is deferred (bit-exact already, low-risk polish).

**Action for you (s6):** during stage-3 review, (1) ratify the honest-named-skip
fold for `at`/`at_2`, `copy_object`/`extend`, `arguments_sloppy`/`arguments_strict`
as later-child (2/3/5) infrastructure gaps, and (2) carry the child-1
recommendation that **child 3 (arrays) revisit `at`** once the Array exotic +
string-key intern path exist — fold it into the child-3 charter or your review
ledger so it is not lost. Also note the deferred FUNCTION_* ≤288-raw analytic
decomposition (bit-exact already) as low-risk polish.

<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-02T22:09:19Z -->

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (stage 1,
design dispatch), `-s2` (self-answer + approve), and `-s3` (stage-1 review, completed 2026-07-02).
You were parked `blocked_on: xs2rust-endor-build-stage2` and promoted because that builder job
completed. Program state:

- **Stage 1 (DESIGN): done.** Design PR is `endojs/endo-but-for-bots` **#600** (DRAFT, branch
  `xs2rust-endor`, base `llm`), design at `designs/xs2rust-endor-engine.md`.
- **Stage 2 (SELF-ANSWER + APPROVE): done.** All ten open questions resolved inline (design
  § Resolved Questions, commit 40a7364eb); status Approved; approval recorded
  (issuecomment-4869816854). The decisions are binding; a builder asking to reopen one is a
  supervisor ruling, not a maintainer question.
- **Stage 3→4 (BUILD/REVIEW loop): roadmap stage 1 REVIEWED AND ACCEPTED by s3.** The s3
  supervisor independently reproduced the acceptance evidence (fresh checkout, oracle pin
  `48ee02d8cfe0` fetched, `cargo test --workspace` green, harness `86/86 bit-exact`), verified
  `forbid(unsafe_code)` and the meter semantics line-by-line against `xsRun.c`, and posted the
  review as PR comment **issuecomment-4870367815** with 3 defects + 3 observations. Rulings
  (recorded as a Q9 design amendment, commit 461087f06): direct C-source linkage for
  endor-oracle accepted; the unfetchable `c/moddable` gitlink deferred (do NOT bump on this
  branch); stage-1 call deferral accepted as a scope fold into stage 2.
- **In flight when s4 was parked:** fixer job `xs2rust-endor-fix-stage1-review` (model: opus;
  wires the dead meter check points per mxBranch negative-offset semantics + the
  fxCheckMetering overflow-wrap guard + tightens `DualRun::is_bit_exact` so
  `Unsupported`/`Decode` never pass under `BothAbort`), then builder job
  `xs2rust-endor-build-stage2` (model: opus; parked blocked on the fixer; object model +
  call/frame machinery first + closures + exceptions + full 245-opcode coverage with built-ins
  stubbed + GC v1 under Miri + real `Compartment.evaluate` globals + loop-bearing corpus;
  acceptance bar: test262 `language/` dual-run bit-exact agreement on the covered grammar).
- **Your loop now:** REVIEW the landed stage-2 work yourself — first read
  `journal/jobs/tada/xs2rust-endor-build-stage2.md` (and
  `journal/jobs/tada/xs2rust-endor-fix-stage1-review.md`), then the PR diff since 461087f06.
  Re-verify the fixer actually closed s3's findings 1-3 (meter check wired at negative-offset
  branches and RETURN/END; wrap guard; predicate tightened) — s3 did NOT review the fixer's
  work, that is yours. Check the stage-2 acceptance evidence (test262 language agreement,
  Miri-green GC), the meter increment points against the design, and the unsafe budget. Post
  concrete review findings on the PR; post `fixer` jobs (model: opus) for defects and iterate,
  or when the stage is genuinely clean, post the NEXT roadmap-stage builder job (model: opus,
  same PR, same pattern: name stage 3's deliverable and acceptance bar from the design table —
  built-ins incl. the `xsre` port per resolved question 6, § Resolved Questions binding, keep
  draft). Then park your next continuation `port-xs-to-rust-memory-safe-engine-s5` blocked on
  that sub-job, carrying this whole spec with an updated Supervisor state. Roadmap stages
  remaining after 2: 3 (built-ins incl. xsre), 4 (Hardened JavaScript), 5 (compiler),
  6 (snapshots), 7 (debugger), 8 (parity closure), 9 (ecosystem validation). If stage evidence
  shows a kill criterion tripped (design § Feasibility Verdict), stop the program: journal it
  and surface to the maintainer with the evidence — an early informed stop is a success mode.
- **Continuation protocol** (how this supervision survives): at each wait point, post the
  sub-job you are waiting on with `post-job.sh` (or park it with `post-plan.sh --blocked` when
  it must wait on a predecessor), then park your own next stage with
  `scripts/jobs/post-plan.sh --blocked --blocked-on <sub-job-base> port-xs-to-rust-memory-safe-engine-s<N+1> <body>`
  carrying this whole spec plus an updated **Supervisor state** section, journal the transition
  (`journal-entry.sh progress`), and complete your invocation. The deterministic unblock
  watcher promotes the next stage when the blocker reaches `tada/`. If a stage needs work you
  can do inline (reviewing diffs, answering design questions, pushing revisions, posting review
  comments), do it inline — you are a Fable supervisor, not just a dispatcher. Sub-job model
  policy: design sub-jobs `model: fable`, build/fixer sub-jobs `model: opus`.

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
   the design set. — **IN PROGRESS: roadmap stage 1 done and reviewed; stage-1 fixer + stage 2 in flight;
   stages 3-9 remain.**
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

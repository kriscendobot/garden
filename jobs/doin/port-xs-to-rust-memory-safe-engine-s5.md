<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-03T03:31:42Z -->

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor jobs `port-xs-to-rust-memory-safe-engine` (stage 1,
design dispatch), `-s2` (self-answer + approve), `-s3` (stage-1 review), and `-s4` (stage-2a
review + stage-2b dispatch, completed 2026-07-02). You were parked
`blocked_on: xs2rust-endor-build-stage2b` (the ORCHESTRATION base) and promoted because that
orchestration reached `tada/` — **read `journal/jobs/tada/xs2rust-endor-build-stage2b.md`
FIRST**: it carries an `orchestration-status:` marker that tells you whether the three
children all completed or the serial run HALTED on a failed child. Program state:

- **Stage 1 (DESIGN): done.** Design PR `endojs/endo-but-for-bots` **#600** (DRAFT, branch
  `xs2rust-endor`, base `llm`), design at `designs/xs2rust-endor-engine.md`.
- **Stage 2 (SELF-ANSWER + APPROVE): done.** All ten questions resolved (§ Resolved
  Questions, BINDING); approval recorded (issuecomment-4869816854).
- **Roadmap stage 1: built, reviewed (s3, issuecomment-4870367815), fixer-repaired
  (`372a00d4b`), and the fixer re-verified by s4.** Rulings live as design amendments
  (Q9: `461087f06`; stage-2 split: `bd0a8392f`).
- **Roadmap stage 2a: built and ACCEPTED by s4** (review issuecomment-4870957010, all
  evidence independently reproduced: 86/86 bit-exact, stage-2 behavioral corpus result-agrees,
  Miri GC 6/6, forbid(unsafe_code), real Compartment globals). The monolithic stage-2 builder
  job overran the 2400s handler wall-clock twice and was removed from the board; its
  completed half became 2a (commits `4339cf1f6`, `cc09a660c`) and the remainder was
  re-scoped by s4 into the **serial orchestration `xs2rust-endor-build-stage2b`** with three
  children (all `model: opus`, all on PR #600):
  1. `xs2rust-endor-build-stage2b-heap` — allocation-faithful object heap + metering; fixes
     s4 finding 2 (`arm_meter` `<<16` scaling per `fxBeginMetering`); bar: 2a corpus
     graduates to bit-exact.
  2. `xs2rust-endor-build-stage2b-frames` — closures + call/return frames; fixes s4
     finding 1 (meter checks at `mxFirstCode` sites, NO check at exit-to-C); bar: bit-exact
     over calls/closures/recursion.
  3. `xs2rust-endor-build-stage2b-exceptions` — exceptions jump-chain + full 245-opcode
     coverage (built-ins stubbed) + `BothAbort(Throw)` predicate tightening (s4 obs 3);
     bar: **test262 `language/` dual-run bit-exact agreement on the covered grammar**
     (closes roadmap stage 2).
- **s4 review findings ledger (verify closure):** finding 1 (RETURN/END check placement)
  → child 2; finding 2 (`arm_meter` units) → child 1; obs 3 (BothAbort compares nothing)
  → child 3; obs 4 (`fxCheckMetering` re-entrancy interval-zeroing) → note only; obs 5
  (README pin-fetch fallbacks) → fixed by s4 (`bd0a8392f`).
- **Oracle-pin friction (practical):** the design pin `48ee02d8cfe0` is no longer a
  shallow-fetchable tip upstream; `rust/engine/README.md` documents two verified fallbacks
  (full `public` fetch — the pin is an ancestor — or a sibling checkout) and the
  empty-gitlink footgun (a `git -C c/moddable` command in a fresh checkout operates on the
  SUPERPROJECT — clone into `c/moddable` first).
- **Your loop now:** REVIEW the landed stage-2b work yourself — the three child tada reports,
  then the PR diff since `bd0a8392f`. Re-verify the acceptance evidence independently (fresh
  checkout, oracle pin via the README fallbacks, `cargo test --workspace`, the harness bars,
  Miri, test262 `language/` numbers) and the findings-ledger closures above. Post concrete
  review findings on the PR; post `fixer` jobs (model: opus) for defects and iterate; or when
  stage 2 is genuinely clean, post the stage-3 builder work (built-ins incl. the `xsre` port
  per resolved question 6; bar per the design table: built-ins sections dual-run agreement
  including computrons) — if stage 3 is also monolith-sized, decompose it as a serial
  orchestration like s4 did for 2b. Then park your continuation
  `port-xs-to-rust-memory-safe-engine-s6` blocked on that sub-job/orchestration, carrying
  this whole spec with an updated Supervisor state. Roadmap stages remaining after 2:
  3 (built-ins incl. xsre), 4 (Hardened JavaScript), 5 (compiler), 6 (snapshots),
  7 (debugger), 8 (parity closure), 9 (ecosystem validation). If a kill criterion tripped
  (design § Feasibility Verdict), stop the program: journal it and surface to the maintainer
  with the evidence — an early informed stop is a success mode.
- **If the orchestration HALTED** (a child was reaped or reported `orchestration-failed`),
  diagnose from the child's tada report / the board / its worktree remnants, then either
  re-post the failed child (fresh base, e.g. `-r2` suffix, re-parked and re-orchestrated
  with the remaining children) or re-scope it smaller, and re-park yourself as s6 blocked on
  the new orchestration. The maintainer inbox got the halt notice automatically; you do NOT
  need to message them unless the failure is a program-level blocker.
- **Continuation protocol** (how this supervision survives): at each wait point, post the
  sub-job(s) you are waiting on (`post-job.sh`, or `post-plan.sh --orchestrated` +
  `post-orchestration.sh` for multi-part work, or `post-plan.sh --blocked` for a chain), then
  park your own next stage with
  `scripts/jobs/post-plan.sh --blocked --blocked-on <sub-job-or-orch-base> port-xs-to-rust-memory-safe-engine-s<N+1> <body>`
  carrying this whole spec plus an updated **Supervisor state**, journal the transition
  (`journal-entry.sh progress`), and complete your invocation. The deterministic unblock
  watcher promotes the next stage when the blocker reaches `tada/`. Do inline what you can do
  inline (reviewing diffs, design amendments, review comments, small pushes) — you are a
  Fable supervisor, not just a dispatcher. Sub-job model policy: design sub-jobs
  `model: fable`, build/fixer sub-jobs `model: opus`. Wire sub-jobs to report to YOU (their
  tada reports + your inbox `port-xs-to-rust-memory-safe-engine-s<N+1>`), never to the
  maintainer inbox — the maintainer enters the loop ONCE, at the end.

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
claim:
  host: endolinbot2
  gardener: 10
  claimed_at: 2026-07-03T03:31:46Z

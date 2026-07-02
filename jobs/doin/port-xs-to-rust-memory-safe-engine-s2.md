<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-02T19:32:14Z -->

---
model: fable
---
# Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-ready, autonomously

## Supervisor state (stage handoff — read first)

You are the **continuation** of supervisor job `port-xs-to-rust-memory-safe-engine` (stage 1 complete,
2026-07-02). You were parked `blocked_on: xs2rust-endor-design` and promoted because that designer job
completed. Program state:

- **Stage 1 (DESIGN): done.** Designer job `xs2rust-endor-design` (`model: fable`) was posted carrying the
  brief below verbatim plus a `## Library and project references` section (the researcher pass, inlined).
  It was instructed to open a **DRAFT PR** on `endojs/endo-but-for-bots`, branch `xs2rust-endor`, base
  `llm`, design at `designs/xs2rust-endor-engine.md`, and to name the PR number in its tada report.
- **You are at Stage 2 (SELF-ANSWER + APPROVE).** First read `journal/jobs/tada/xs2rust-endor-design.md`
  to find the PR number and the designer's summary; then run the stage-2 loop below on that PR.
- **Continuation protocol** (how this supervision survives): at each wait point, post the sub-job you are
  waiting on with `post-job.sh`, then park your own next stage with
  `scripts/jobs/post-plan.sh --blocked --blocked-on <sub-job-base> port-xs-to-rust-memory-safe-engine-s<N+1> <body>`
  carrying this whole spec plus an updated **Supervisor state** section, journal the transition
  (`journal-entry.sh progress`), and complete your invocation. The deterministic unblock watcher promotes
  the next stage when the blocker reaches `tada/`. (Plain same-basename reposting is a no-op because
  `post-job.sh` dedups against `tada/`; the `-sN` suffix is the versioning.) If a stage needs work you can
  do inline (reading the design, answering open questions, pushing design revisions, posting review
  comments), do it inline in your own invocation — you are a Fable supervisor, not just a dispatcher.
  Sub-job model policy: design sub-jobs `model: fable`, build/fixer sub-jobs `model: opus`.

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
   determinism-equivalence proof. Debugger = the XS debugger protocol/inspection surface. Snapshot =
   heap save/restore (the xsnap lifecycle); decide the FORMAT question (read existing XS snapshots vs a
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
   `designs/`. (Prefix it with a `researcher` pass if that is the standing convention.) — **DONE, stage 1.**
2. **SELF-ANSWER + APPROVE (loop).** Repeatedly read the design's **open questions** (the designer's
   `## Open questions`, groom output, or reviewer notes). **Answer each one yourself** — make the
   engineering decision, grounded in the 8 requirements and the endor/XS design cluster — and post design
   revisions until **no open questions remain** and the design is complete and internally consistent.
   **Do NOT route design questions to the maintainer.** End this loop by **recording your approval** of the
   design on the PR and in the journal.
3. **BUILD (same PR).** Immediately post a `builder` job (`model: opus`) to implement the port **end-to-end
   on the SAME PR as the design** (the design doc and the implementation share one pull request). Acceptance
   bar: **test262 parity** plus the metering-determinism + Compartment bars the design set.
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
  claimed_at: 2026-07-02T19:32:20Z

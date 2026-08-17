---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design a panic mechanism for the Ironhorse engine

Repository: endojs/endo-but-for-bots. Target the roadmap branch `llm` (draft
PR against `llm`, per this project's designer convention).

## Read first

- [`designs/ironhorse-engine.md`](../designs/ironhorse-engine.md) — the base
  engine design. Note in particular:
  - `Halt::StackOverflow` (`rust/engine/ironhorse-vm/src/interp.rs`, the
    `Halt` enum) is *already* documented as "an abort to the host, not a
    catchable `RangeError` — a deterministic, consensus-relevant limit in the
    xsnap lineage." `Halt::MeterAbort` (computron exhaustion) is the same
    shape.
  - § Minimizing `unsafe`: a Rust-level logic-bug panic "surface[s] as
    deterministic panics, which the supervisor already treats as worker
    death; a panic is a crashed crank, not a compromised daemon."
  - The metering-design cross-reference notes `xsnap-platform.c`'s `fxAbort`
    longjmp becomes "safe Rust equivalents" — i.e. XS/xsnap already has this
    exact uncatchable-abort-to-host pattern for stack overflow and meter
    refusal today.
- [`designs/daemon-debug-worker-restart.md`](../designs/daemon-debug-worker-restart.md)
  — the existing suspend-to-snapshot / resume-from-snapshot machinery
  (`debugWorker`), which is the retry mechanism this design should build on
  rather than reinvent.
- [`designs/ironhorse-debugger-recovery-and-uncaught.md`](../designs/ironhorse-debugger-recovery-and-uncaught.md)
  — the active debugger work, including its § "Ironhorse Decisions Informed
  by the XS Oracle" note that promise-rejection tracking is a *separate*
  mechanism from throw-time uncaught classification. This new design's panic
  concept must say explicitly how it is distinguished from an ordinary
  uncaught throw in that debugger's break/report model.
- library concepts on CapTP/vat lifecycle the scholar has already indexed
  (library-lookup first) for any prior grounding on crank/delivery semantics
  before inventing new vocabulary where existing vocabulary already fits.

## Premise

A **panic** is an uncatchable, unrecoverable termination state for a vat/
worker: no JS `try`/`catch`, promise handler, or engine-level recovery path
can intercept it. Paired with a **message embargo** — outbound messages
produced during the crank are held, not released to their destinations,
until the crank commits; a panic discards them instead of committing — this
mitigates **hangover inconsistency**: the class of bug where a crank panics
partway through and would otherwise leave some of its intended effects
observed by the outside world and others not. A panic instead guarantees the
vat/worker is terminated with **no side effect escaping**, so the crank can
be **fixed and retried** by restoring the worker from its last snapshot and
replaying the transcript up to (but not including) the panicking delivery.

This is not a new idea from scratch: `Halt::StackOverflow` and
`Halt::MeterAbort` already behave exactly this way today, and XS/xsnap's
`fxAbort` is the precedent both are built on. **Confirm and scope this
explicitly as the first design step**: which existing Ironhorse/XS abort
paths are already a panic in this sense, which need reclassifying/renaming
under one formal concept, and which are net-new. Do not present this as
inventing uncatchable termination from nothing when the engine substantially
has it already for two of its three natural cases (stack overflow, meter
refusal) — the design's job is to name it, generalize it, and extend it
(see Coda below), not to bolt on a parallel mechanism.

## What the design needs to specify

- **A formal `Panic` category** (whether that is a new `Halt` variant, a
  grouping over existing ones, or a distinct enum `Interp`/`Machine`
  surfaces to its caller) — unifying `Halt::StackOverflow`, `Halt::MeterAbort`,
  and any other engine condition that should terminate rather than throw.
- **The message-embargo contract**: where outbound messages are actually
  held today (or would need to start being held) relative to crank
  execution and commit, and how a panic causes them to be discarded rather
  than released. Ground this in the daemon's actual crank/delivery
  machinery — cite the real commit point, don't assume one.
- **Termination and retry**: the exact sequence from panic to worker death to
  snapshot-restore-and-transcript-replay, building on `debugWorker`'s
  existing suspend/resume-from-snapshot machinery. State what "fixed" means
  in practice — is the fix a code change requiring a new snapshot/build, a
  configuration change, or can the same snapshot be retried unmodified (e.g.
  after an external condition changes)?
- **Debugger interaction.** State explicitly whether/how a panic differs from
  an uncaught throw in the debugger's model — a distinct break reason, a
  distinct wire message, or something else — so the recovery-and-uncaught
  design's classifier is not left to guess. If a panic should itself be
  debuggable (stop the world at the panic site rather than tearing the
  worker down immediately when a debugger is attached), say so and specify
  the interaction with `setExceptionBreakMode`.

## Coda — an option to panic on reference errors

Add a closing section proposing an **Ironhorse configuration option**
(off by default) under which a **reference error** — an engine-raised
"undefined variable" / "not initialized yet" condition, concretely the
`Halt::Throw` sites in `interp.rs` at the `XS_CODE_GET_LOCAL` ("get: not
initialized yet") and variable-lookup ("undefined variable") opcodes —
**panics instead of throwing**.

The motivation: with this option enabled, a heap snapshot taken at the panic
captures the machine with the **program counter pointing directly at the
error**, before any unwind, `catch`, or promise-rejection handler has had a
chance to run and obscure the fault site — even when a `catch` block or a
rejection handler *would* otherwise have intercepted the error and continued
past it. This is a diagnostic/debugging configuration, not the default: it
trades normal catchable-`ReferenceError` semantics for the ability to freeze
and inspect the exact moment of failure.

**Name the interaction with the debugger design's engine-raise-unwind
prerequisite explicitly.** `ironhorse-debugger-recovery-and-uncaught.md`'s
Part 2 requires engine-raised errors (including these same "undefined
variable" sites) to start unwinding through the jump chain as catchable
throws — the opposite direction from this coda's option. State how the two
coexist: presumably this is a mode switch (normal build: engine-raised
reference errors unwind and are catchable, satisfying the debugger's
uncaught-mode work; panic-on-reference-error build/config: they panic
instead), and specify where that switch lives (a `Machine` construction
option, a per-run flag, a build feature) and what happens if both an
attached debugger *and* panic-on-reference-error are active at once.

## Deliverable

A design document per the designer role's usual shape (problem statement,
scope, design, alternatives considered, open questions). Where the message-
embargo/crank-commit mechanics turn out to need their own follow-on design
once the daemon's actual current behavior is surveyed, say so explicitly in
Open Questions rather than asserting a mechanism that was not verified
against the real code.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-17T06:05:39Z

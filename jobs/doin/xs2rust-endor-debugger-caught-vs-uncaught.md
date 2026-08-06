---
role: researcher
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-08-06T05:46:42Z cleared=none -->

# Investigate a caught/uncaught distinction for the Endor debugger protocol

Maintainer directive (kriskowal, 2026-07-28, via the liaison on
`endolin-garden-ece02cb4`): follow up on xs2rust with *"an investigation into
improving the debugger protocol to support a distinction between 'break on caught
exceptions' versus 'break on uncaught exceptions'. It should be obvious from the
stack whether there is a catch above the throw."*

**Research and proposal only. Change no engine behavior in this job.** The output
is findings plus a filed issue, not a patch.

## Where this picks up

The debugger row of the XS to Rust port landed in three slices on
https://github.com/endojs/endo-but-for-bots/pull/600 (branch `xs2rust-endor`),
producing the `endor-debug` crate at `rust/engine/endor-debug`:

- **Slice 1** (`xs2rust-endor-stage9-debugger`) built the protocol core:
  `transport.rs` (the `DebugTransport` seam over XS's five C platform hooks),
  `command.rs` (a port of `fxDebugParse` and friends, decoding client to VM xsbug
  XML), and `echo.rs` (the VM to client serializer).
- **Slice 2** (`xs2rust-endor-stage9c-debugger-slice2`) added the VM-side hooks,
  including, per its own summary, "break-on-uncaught via the `firstJump`-equivalent
  JS/host-flag walk".
- **Slice 3** (`xs2rust-endor-stage9c-debugger-slice3`) did bus integration and
  acceptance tests, and named this exact gap in its honest remainder: **"the
  exceptions pseudo-breakpoint wired into the VM seam"** is among the commands
  **parsed but inert** in `session.rs`.

So the protocol already carries an exceptions pseudo-breakpoint that the Rust side
decodes and ignores, and the uncaught-side walk already has a sketch. That is the
surface this investigation is about.

## The question to answer

XS and xsbug historically expose breaking on exceptions as roughly one switch. The
maintainer wants the finer distinction, and has given the key intuition to test:
**at the moment of the throw, the stack should already tell you whether a `catch`
sits above it.** Answering that before unwinding is what makes the distinction
cheap and honest, rather than reconstructing it after the fact.

Deliver findings on:

1. **Current behavior, precisely.** What the exceptions pseudo-breakpoint means
   today in C-XS (`c/moddable/xs/sources/xsDebug.c`, read-only at the pinned
   reference) and what `command.rs` currently parses. Quote the wire form. State
   what xsbug's UI actually offers today rather than assuming.
2. **Can the stack answer it, and where.** In `endor-vm`, at throw time, what
   represents the live handler chain, and can it be walked to decide "is there a
   `catch` above this throw" without unwinding and without allocating. Name the
   types and the call site. Include the awkward cases and say plainly if any defeat
   the intuition: `finally` without `catch`, a `catch` that rethrows, generator and
   async frames where the resume point moves the handler, host or native frames
   between the throw and the nearest JS handler, promise rejection (an unhandled
   rejection is not a stack-visible uncaught throw), and the top-level or job-queue
   boundary.
3. **Protocol shape.** What the wire change is, if any. Compare at least: reusing
   the existing pseudo-breakpoint with an attribute carrying the mode; a distinct
   pseudo-breakpoint per mode; and a general breakpoint-condition mechanism that
   this becomes one instance of. Say which is compatible with an unmodified xsbug
   client and which requires a client change, since that constrains what can ship.
   The three-way or four-way choice to express is at minimum never, caught only,
   uncaught only, and all.
4. **Cost when disarmed.** The row's standing bar is metering neutrality. Show what
   the disarmed path costs, and confirm it stays a single dormant branch. A design
   that only pays when the debugger is attached is the target.
5. **Parity.** Whether this diverges from C-XS observable behavior, and if it does,
   whether the divergence is defensible as an improvement or must be gated so the
   C-XS path is unperturbed.

## Deliver

A `jobs/tada/` report with the findings, **and file an issue** on
https://github.com/endojs/endo-but-for-bots with the same findings, framed as
preparation for writing a proposal. The issue should state the problem, the
options with their trade-offs, and a recommendation, so the proposal can be written
from it without re-research. Link the issue in your report. Do not open a pull
request and do not modify engine code in this job.

Ground every claim in code you actually read. If you cannot establish something,
say so and leave it open rather than guessing.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-06T05:49:38Z

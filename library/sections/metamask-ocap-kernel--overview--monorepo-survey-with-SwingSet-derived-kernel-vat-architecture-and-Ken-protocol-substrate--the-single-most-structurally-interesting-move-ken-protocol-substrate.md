---
section: monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
source: metamask-ocap-kernel--overview
topics: [daemon, captp, persistence]
status: current
title: The §single most structurally interesting move — §Ken-protocol-substrate
parent: metamask-ocap-kernel--overview--monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
---

The most distinctive structural feature is `docs/ken-protocol-
assessment.md`'s explicit framing of the kernel against the
**Ken protocol** (HP Labs Tech Report HPL-2010-155: *Output-
Valid Rollback-Recovery* by Kelly, Karp, Stiegler, Close, and
Cho).

Ken's seven properties (from the doc):

1. **Exactly-once delivery** in process-pairwise FIFO order
2. **Output validity**: outputs *could* have resulted from
   failure-free execution
3. **Transactional turns**: one message delivered →
   processing → checkpoint → transmit outputs
4. **Consistent frontier**: most-recent per-process
   checkpoints always form a recovery line
5. **Local recovery**: crashes cause only local rollbacks,
   no domino effect
6. **Sender-based message logging**: messages persisted in
   sender's output queue until ACKed
7. **Deferred transmission**: outputs buffered during turn,
   transmitted only after checkpoint

The §self-assessment-against-named-protocol discipline:
ocap-kernel's doc *names* a published protocol and *tabulates
its own implementation against each property*. Twelve rows of
*Property | Status | Implementation*, each ✓ with a one-line
note on where the property is implemented.

The §crank-buffering centerpiece (Issue #786):

> *crank_start(deliver one item from run queue)*
>   *→ create database savepoint*
>   *→ vat processes message*
>   *→ vat syscalls buffer outputs (sends, notifications) in CrankBuffer*
> *crank_end:*
>   *→ if success: atomically flush buffer to run queue + commit state*
>   *→ if failure: rollback to savepoint, discard buffer*

The §atomic-output-or-rollback discipline. *Outputs are only
externalized after successful turn completion*. Compares
directly with:

- **Cycle 100** (`unhandled-rejection.js`) — SES's GC-driven
  rejection-tracking. Ken's exactly-once shape *would
  subsume* the rejection-tracking gap.
- **Cycle 137** (`daemon-message-streaming`) — the
  §cross-peer-streams-ride-CapTP observation. Ken's
  deferred-transmission shape is the symmetric piece on the
  *sender* side.
- **Cycle 149** (`unhandled-rejection-display`) — the
  §error-path-cannot-depend-on-error-path insight. Ken's
  output-validity property gives that insight a formal
  framework.
- **Cycle 119** (`daemon-capability-bus`) — the daemon's
  envelope-protocol-and-handle-rewriting machinery is the
  *transport substrate*; Ken's properties are *what runs on
  top*.

The §named-protocol-as-acceptance-criterion discipline gives
the design discipline a *citable formal target*.

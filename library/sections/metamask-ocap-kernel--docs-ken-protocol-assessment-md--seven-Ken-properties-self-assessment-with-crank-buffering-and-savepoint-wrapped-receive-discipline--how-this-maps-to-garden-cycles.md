---
section: seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
source: metamask-ocap-kernel--docs-ken-protocol-assessment-md
topics: [daemon, captp, persistence]
status: current
title: How this maps to garden cycles
parent: metamask-ocap-kernel--docs-ken-protocol-assessment-md--seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
---

The most structurally direct comparisons:

- **Cycle 119** (`daemon-capability-bus`) — Endo's
  envelope-protocol-and-handle-rewriting. **Gap**: Endo's
  daemon doesn't (yet) have the §crank-buffering atomic-
  output-or-rollback discipline as a *named protocol-level
  invariant*. The §run-queue-as-the-commit-fence pattern
  could be adopted.
- **Cycle 137** (`daemon-message-streaming`) — the §cross-
  peer-streams-ride-CapTP observation. **Gap**: Endo's
  streaming doesn't yet have Ken's §deferred-transmission
  property (stream chunks could escape before the producer's
  turn commits).
- **Cycle 149** (`unhandled-rejection-display`) — the §error-
  path-cannot-depend-on-error-path insight. Ken's §output-
  validity is *the formal framework* for that insight: if all
  outputs escape only after commit, the diagnostic-substrate-
  cannot-fail invariant becomes a protocol property *for
  free*.
- **Cycle 100** (`unhandled-rejection.js`) — SES's GC-driven
  rejection-tracker. **Gap**: Ken's §exactly-once-delivery
  invariant *would prevent* the rejection-tracking gap (no
  duplicate deliveries means no spurious-rejection cases).
- **Cycle 156** (`finalize.js`) — the §gc-as-side-channel
  warning + the §blockchain-replay hazard. Ken's deterministic-
  delivery + Done-table approach is *exactly the discipline*
  that mitigates the gc-as-side-channel concern: outputs are
  deterministic functions of inputs *across crashes*, not of
  *gc timings*.
- **Cycle 141** (`daemon-cas-management`) — Rust supervisor +
  SQLite. The §SQLite-savepoint-as-checkpoint-mechanism is
  the *same* technology choice ocap-kernel makes for crank-
  buffering.

The §gap-revealing-comparison observation: ocap-kernel has
*named* properties that Endo's daemon implements *informally*
or *partially*. Future Endo-side designs could *adopt the
Ken-property vocabulary* without reimplementing the
substrate.

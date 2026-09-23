---
section: seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
source: metamask-ocap-kernel--docs-ken-protocol-assessment-md
topics: [daemon, captp, persistence]
status: current
title: The §seven-Ken-properties enumeration
parent: metamask-ocap-kernel--docs-ken-protocol-assessment-md--seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
---

The properties (verbatim, lines 9-15):

1. **Exactly-once delivery** in process-pairwise FIFO order
2. **Output validity**: Outputs could have resulted from
   failure-free execution
3. **Transactional turns**: One message delivered →
   processing → checkpoint → transmit outputs
4. **Consistent frontier**: Most-recent per-process
   checkpoints always form a recovery line
5. **Local recovery**: Crashes cause only local rollbacks,
   no domino effect
6. **Sender-based message logging**: Messages persisted in
   sender's output queue until ACKed
7. **Deferred transmission**: Outputs buffered during turn,
   transmitted only after checkpoint

The §exactly-seven-numbered-properties discipline: each
property is named, each is single-purpose, each is
independently testable. Compare with cycle 153's §three-
layer-auditable defense (Config + Allowlist + Named-step) —
both designs use a §named-N-criteria methodology.

The §output-validity property is the most semantically
interesting:

> *Outputs could have resulted from failure-free execution.*

The §failure-free-execution-as-correctness-baseline: a
message arriving at a remote is *valid* if and only if it
could have arrived in a world *without* crashes. This rules
out *crash-induced phantom outputs* (a crash producing a
message that the no-crash run would never have sent).

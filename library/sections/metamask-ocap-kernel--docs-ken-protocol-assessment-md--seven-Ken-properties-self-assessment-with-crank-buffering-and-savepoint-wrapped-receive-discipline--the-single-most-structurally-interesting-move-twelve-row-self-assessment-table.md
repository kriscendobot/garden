---
section: seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
source: metamask-ocap-kernel--docs-ken-protocol-assessment-md
topics: [daemon, captp, persistence]
status: current
title: The §single most structurally interesting move — §twelve-row self-assessment table
parent: metamask-ocap-kernel--docs-ken-protocol-assessment-md--seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
---

The §Assessment-of-Our-Current-System section presents a
**twelve-row table** (lines 41-55), each row mapping a Ken
property to a *concrete implementation pointer*:

| Property | Implementation pointer |
|----------|----------------------|
| Sender-based logging | `remotePending.${remoteId}.${seq}` keys |
| Sequence numbers | `seq` outgoing + `highestReceivedSeq` incoming |
| Cumulative ACK | piggyback ACKs |
| Retransmission | timeout-based |
| Crash-safe persistence | write-message-then-update-nextSendSeq ordering |
| Local recovery | restore seq state + restart ACK timeout |
| Transactional turns | crank-buffering defers outputs |
| Deferred transmission | outputs reach RemoteHandle only after crank commits |
| Output validity | crank-buffering ensures outputs escape only after commit |
| Atomic checkpoint | database savepoints |
| Exactly-once receive | transactional receive with dedup (Issue #808) |
| FIFO ordering | TCP in-order + dedup |

The §each-property-points-at-a-named-implementation-artifact
discipline. Not "we do X"; rather "we do X *here*, via *this
specific code path*." A future reader (or auditor) can
*verify the claim* by reading the named file or running the
named test.

The §issue-numbers-anchor-the-claims observation: §#786
(crank-buffering) and §#808 (exactly-once receive) are
*verifiable artifacts* — GitHub PRs / issues that record
*when* and *how* the property was implemented. The §verifiable-
provenance-not-just-assertion discipline.

The §database-savepoints-for-atomic-checkpoint specific
implementation choice: rather than a custom transaction
manager, ocap-kernel uses *SQLite savepoints* (which the
kernel-store package wraps). Cycle 141's daemon-cas-management
also chose SQLite (via Rust supervisor); cycle 161's overview
noted ocap-kernel's kernel-store has both Node.js native and
WASM SQLite implementations. The §SQLite-savepoint-as-
checkpoint-mechanism choice is consistent across the
substrate.

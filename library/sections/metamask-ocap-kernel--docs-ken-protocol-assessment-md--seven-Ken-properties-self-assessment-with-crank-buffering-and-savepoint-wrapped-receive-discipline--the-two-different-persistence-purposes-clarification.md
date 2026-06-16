---
section: seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
source: metamask-ocap-kernel--docs-ken-protocol-assessment-md
topics: [daemon, captp, persistence]
status: current
title: The §two-different-persistence-purposes clarification
parent: metamask-ocap-kernel--docs-ken-protocol-assessment-md--seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
---

> *`RemoteHandle` persists messages to `remotePending` before
> transmitting for a different reason: to enable
> retransmission on recovery if the transmission or ACK is
> lost. This is part of the at-least-once delivery mechanism,
> not the output validity mechanism.*

The §don't-conflate-the-two-persistence-purposes observation.
Two *distinct* reasons to persist:

1. **Output validity** (Ken property 2): outputs persist
   *before* externalization so they're durable across
   crashes.
2. **At-least-once retransmit** (Ken properties 1 + 6): the
   *transmitted-but-unacknowledged* messages persist so they
   can be retransmitted if the transmission or ACK was lost.

The same persistence machinery (`remotePending` table) serves
both purposes, but the *invariants are different*:

- **Output validity** says: *if this output exists, it
  reflects committed local state*.
- **At-least-once retransmit** says: *if this output was sent
  but not ACKed, we can resend it*.

The §same-table-two-invariants discipline. A future reader
who *only sees the table* might mistake one invariant for
the other; the doc names both *explicitly*.

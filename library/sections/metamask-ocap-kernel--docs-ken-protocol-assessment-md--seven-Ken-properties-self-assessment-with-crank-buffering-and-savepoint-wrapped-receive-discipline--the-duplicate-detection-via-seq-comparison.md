---
section: seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
source: metamask-ocap-kernel--docs-ken-protocol-assessment-md
topics: [daemon, captp, persistence]
status: current
title: The §duplicate-detection-via-seq-comparison
parent: metamask-ocap-kernel--docs-ken-protocol-assessment-md--seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
---

```typescript
if (seq <= this.#highestReceivedSeq) {
  this.#logger.log(`ignoring duplicate message seq=${seq}`);
  return null;
}
```

The §guard-on-seq-comparison-not-Set-lookup pattern. Ken's
canonical implementation uses a *Done table* (which tracks
each message individually); ocap-kernel uses a *monotonic
high-water-mark* (which is simpler and works *given* FIFO
delivery from the transport).

The §high-water-mark-discipline observation: under FIFO,
*all* messages with `seq <= highestReceived` are by definition
already processed. Storing just the high-water-mark is
*equivalent* to storing the Done table — under the FIFO
assumption.

The §FIFO-via-TCP-not-receive-side-reordering observation
(line 137):

> *We use TCP-based transports (libp2p streams) which
> guarantee in-order delivery during normal operation. Out-
> of-order arrival only occurs after a crash when the sender
> retransmits. With duplicate detection, retransmitted
> messages for already-processed sequence numbers are dropped,
> maintaining FIFO semantics.*

The §borrow-FIFO-from-the-transport choice. ocap-kernel
chooses libp2p streams (TCP-based) as the transport; TCP's
in-order delivery is *inherited* rather than re-implemented.
The §don't-reinvent-the-FIFO discipline.

The §post-crash-out-of-order-handled-by-dedup observation: the
only way out-of-order arrival happens is the *post-crash
retransmit* edge case; dedup handles it. No receive-side
reorder buffer needed.

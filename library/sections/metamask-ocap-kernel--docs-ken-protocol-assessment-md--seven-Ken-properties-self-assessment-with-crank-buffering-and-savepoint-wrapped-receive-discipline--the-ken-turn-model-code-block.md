---
section: seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
source: metamask-ocap-kernel--docs-ken-protocol-assessment-md
topics: [daemon, captp, persistence]
status: current
title: The §Ken-turn-model code block
parent: metamask-ocap-kernel--docs-ken-protocol-assessment-md--seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
---

```
turn_start(deliver exactly one message to processing_function)
  → processing_function executes
  → outputs buffered in Q_out (not transmitted yet)
turn_end:
  → atomically persist(turn, app_state, Q_out, Done)
  → THEN transmit buffered messages
```

The §atomic-checkpoint-before-transmit discipline. Five key
aspects (lines 30-35):

- Only one message delivered per turn
- All outputs buffered until end of turn
- Atomic checkpoint includes application state AND output
  queue
- Transmission happens only after checkpoint completes
- `Done` table tracks which messages have been processed to
  completion

The §checkpoint-includes-output-queue invariant: the
*outputs* are durable *before* they're transmitted. If a
crash happens after checkpoint but before transmission, the
recovered process *still has the outputs to transmit*. If a
crash happens before checkpoint, no transmission occurred and
no inconsistent state exists.

The §Done-table-tracks-processed-to-completion observation:
this is the receive-side dual of the §sender-based-message-
logging property. Sender persists outputs until ACKed;
receiver persists *which-messages-are-done*. Both are
necessary for the §exactly-once invariant.

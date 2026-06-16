---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: CapTP-over-envelope — the encapsulation that lets CapTP not know
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

The existing manager-worker communication uses CapTP (Capability
Transfer Protocol) over netstring-framed pipes. Under the bus, this
CapTP traffic is carried inside envelope payloads:

1. The manager establishes a CapTP session for each worker, as the
   in-process daemon did previously.
2. Instead of reading/writing netstring frames on raw pipes,
   `bus-daemon-node-powers.js` wraps CapTP frames in envelopes:
   `[workerHandle, "deliver", frameBytes, 0]`.
3. `bus-worker-node-powers.js` unwraps envelopes back into CapTP
   frames for the worker's CapTP layer.

This *encapsulation is transparent to the CapTP layer* — it sees the
same reader/writer interface. The envelope framing adds the handle
routing needed for the daemon to deliver messages to the correct
subprocess. CapTP doesn't need to know it's now multiplexed through a
single fd-pair per subprocess.

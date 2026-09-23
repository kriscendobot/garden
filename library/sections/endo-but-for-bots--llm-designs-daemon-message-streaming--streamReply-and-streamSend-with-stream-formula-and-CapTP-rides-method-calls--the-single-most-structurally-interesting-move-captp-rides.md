---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
title: The §single most structurally interesting move — *CapTP rides
parent: endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
---

the stream as method calls*

The §Cross-peer considerations paragraph is the design's
*structurally most interesting paragraph*:

> *For messages that cross CapTP peer boundaries, the stream
> events travel over the existing CapTP channel as method calls
> on the stream formula's far reference. No new transport
> primitive is needed — the existing promise pipelining and
> method dispatch handle it.*

The §no-new-transport-primitive observation: streaming is
*just CapTP method calls* on the stream formula's far reference.
Cycle 119's `daemon-capability-bus` envelope protocol already
carries CapTP frames; the streaming events ride that channel
without any new wire-format work.

The §promise-pipelining-handles-it claim: CapTP's promise
pipelining (the *Stage 4 milestone* OCapN cites — pipelining
calls *before the promise resolves*) is exactly what's needed to
make `append` / `setPhase` / `end` / `abort` calls efficient.
The sender pipelines all calls; the receiver processes them in
order; no round-trip per chunk.

This is the *re-use-existing-substrate* discipline. Adding
streaming to the daemon doesn't require new envelope verbs (vs
cycle 119's capability-bus envelope protocol Phase 5 syscall
migration). The §existing-CapTP-handles-it observation is the
*free lunch* of layering: streaming doesn't need its own
transport because CapTP method dispatch *is already* a
streaming transport.

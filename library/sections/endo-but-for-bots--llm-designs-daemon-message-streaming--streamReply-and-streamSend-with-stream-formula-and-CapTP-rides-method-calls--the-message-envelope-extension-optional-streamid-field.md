---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
title: The §message-envelope-extension — *optional streamId field*
parent: endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
---

The §Message envelope extension:

> *Add an optional `streamId` field to the message envelope.
> When present the recipient's inbox entry includes a `stream`
> property that is a Far reference to the stream formula's
> async iterable.*

The §opt-in-via-extension-field discipline: messages *without* a
streamId are *unchanged*; messages *with* a streamId carry the
new behavior. No breaking changes; *Phase 1 implements alongside
existing reply/send*.

The §three-phase delivery:

1. Sender calls `streamReply(number)`.
2. Mail subsystem creates a stream formula and a message
   envelope with `streamId`.
3. The envelope is *delivered to the recipient immediately* —
   the message appears in their inbox with `stream` attached.

The §immediate-envelope-late-content shape: the recipient sees
*a placeholder message* immediately (with `stream` attached);
the actual content streams in over time. The §async-iterable-on-
the-stream-property is what the recipient consumes
progressively.

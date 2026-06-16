---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
title: The §persistence model — *durable-on-end, partial-on-abort*
parent: endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
---

The §Persistence section names the three storage cases:

> *- While streaming, only the stream formula's in-memory buffer
>   is authoritative.*
> *- On `end()`, the assembled text is written to the message's
>   durable record so it survives daemon restart.*
> *- On `abort()`, partial text plus the abort reason are
>   persisted.*

The §in-memory-during / §durable-on-completion split. The
§assembled-text-concatenated-on-end discipline: the in-memory
chunks get concatenated and *the message snapshot becomes the
durable record*. After `end()`, the message is *indistinguishable
from a non-streaming message* — the §static-message-eventually
invariant from §Use-Case Requirements 3.

The §abort-preserves-partial-content discipline: the abort case
*doesn't discard* what was streamed before the abort. The
partial text + the abort reason are *both* persisted, so the
recipient can see *how much got through* before the failure.

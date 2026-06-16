---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
title: The §stream-formula implementation sketch
parent: endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
---

The §Implementation Sketch names a new formula type `stream` for
the daemon's formula graph:

```
stream:<id> = {
  phase: string,
  chunks: AsyncIterator<StreamEvent>,
  push(event): void,   // internal — called by the sender's StreamWriter
  close(): void,       // internal
}
```

The §stream-formula-shape: *promise-kit-backed async iterator*.
The formula is *created* when `streamReply` is called and its
*ID is attached to the outbound message envelope*. The discipline:
*the formula is the live thing; the envelope is the durable
thing*.

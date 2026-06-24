---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
title: streamReply and streamSend with stream-formula and CapTP rides method calls
parent: endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
---

> *For messages that cross CapTP peer boundaries, the stream
> events travel over the existing CapTP channel as method calls
> on the stream formula's far reference. No new transport
> primitive is needed — the existing promise pipelining and
> method dispatch handle it.*
>
> — `designs/daemon-message-streaming.md` §Cross-peer considerations

`daemon-message-streaming.md` (216 lines, *In Progress* status,
created 2026-03-26 / updated 2026-05-19) is the design by Joshua
T Corbin (jcorbin) — **the first non-Kris-Kowal daemon design
ingested**. Phase 1 (`streamReply` + `StreamWriter` +
`StreamReader`) is open as PR #287, not yet merged to `llm`.

The design adds *progressive-text-delivery* to the daemon's mail
system, motivated by the Genie agent's LLM-token streaming
needs.

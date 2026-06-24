---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
title: The §motivation — *thinking → tool-call → responding* phases
parent: endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
---

The §Motivation paragraph names the *Genie agent* use case:

> *The Genie agent (and similar AI-powered guests) produces
> output incrementally: reasoning tokens stream in as the LLM
> thinks, tool call notifications arrive mid-turn, and the final
> assistant response is assembled token-by-token.*

Today's workaround:

1. Send a *"Thinking …"* status message while the LLM reasons.
2. Send a *"Calling tool X …"* message on each tool invocation.
3. Buffer all response tokens and send the full text as a single
   final message.

The §choppy-UX problem: *the recipient sees several separate
messages rather than a single response that builds up in real
time*. The design's goal is *one message that builds up in real
time* rather than *N separate messages*.

The §Genie cross-reference connects to cycle 121's family
keystone §Genie section (which introduced Genie as the third
Endo-side surface that embeds Pi directly). Genie's
`makePiAgent` produces incremental output; this design gives the
daemon a way to *carry that incremental output* without forcing
the multi-message workaround.

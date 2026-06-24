---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
title: The §three-phase migration path
parent: endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
---

The §Migration Path section names the *non-breaking-three-step*
discipline:

1. **Implement `streamReply` / `streamSend` alongside the
   existing `reply` / `send` methods** — *no breaking changes*.
2. **Guests that want streaming opt in**; guests that don't
   continue to use discrete messages.
3. **The Familiar chat UI checks for the `stream` property on
   inbox messages and renders a live-updating bubble when
   present**, falling back to the static `strings` content for
   finalised or non-streaming messages.

The §opt-in-no-breaking-changes discipline. The §fallback-to-
static-strings discipline lets the UI handle *both* streaming
and non-streaming messages uniformly — *one rendering path with
two input shapes*.

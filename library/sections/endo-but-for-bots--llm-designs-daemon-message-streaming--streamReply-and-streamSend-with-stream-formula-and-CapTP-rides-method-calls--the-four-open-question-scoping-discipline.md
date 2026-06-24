---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
title: The §four-open-question scoping discipline
parent: endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
---

The §Open Questions section deliberately *defers* four
decisions:

1. **Chunk granularity** — *Should `append` send individual
   tokens or should the sender batch into larger chunks? A
   minimum interval (e.g. 50ms debounce) could reduce CapTP
   overhead without noticeably hurting perceived latency.* The
   §debounce-as-perceived-latency-trade-off question.

2. **Back-pressure** — *Should `append` return a promise that
   resolves when the recipient has consumed the chunk, or should
   it be fire-and-forget with an internal buffer?* The
   §promise-as-back-pressure-signal-vs-fire-and-forget question.

3. **Multiple streams per message** — *Is there a use case for a
   single message carrying multiple parallel streams (e.g.
   stdout + stderr)? For now a single stream per message seems
   sufficient.* The §start-with-one-stream-extend-later
   discipline.

4. **Stream cancellation by recipient** — *Should the recipient
   be able to signal the sender to stop streaming (e.g. user
   clicks "Stop generating")?* The §cancel-from-the-other-side
   question.

The §honest-deferral discipline: the design *acknowledges* the
trade-offs without pre-committing. Phase 1 ships *without*
answers to these; subsequent phases can address each.

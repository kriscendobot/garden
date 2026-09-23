---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
title: The §five use-case requirements
parent: endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
---

The §Use-Case Requirements section names five capabilities the
streaming facility needs:

1. **Progressive text delivery** — sender appends fragments over
   time; recipient sees each fragment as it arrives.
2. **Status phases** — metadata indicating *thinking* /
   *tool-call* / *responding* so the UI can render appropriate
   indicators.
3. **Finalisation** — *Once finalised, the message becomes an
   ordinary immutable message in the inbox/outbox.* The §static-
   message-eventually invariant.
4. **Error / abort** — sender can abort; recipient sees *partial
   content plus an error indicator*.
5. **Back-pressure (optional, future)** — sender can detect slow
   consumer and throttle.

The §back-pressure-as-future-not-now scoping: the initial design
*doesn't* include back-pressure; the recipient's pull rate is
not (yet) visible to the sender. The §Open questions section
revisits this.

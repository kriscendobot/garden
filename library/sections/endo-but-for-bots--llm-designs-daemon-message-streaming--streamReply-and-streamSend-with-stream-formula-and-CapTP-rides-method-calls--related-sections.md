---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
title: Related sections
parent: endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
---

- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — the daemon-as-message-router envelope protocol that carries
  the CapTP frames the §Cross-peer considerations leverages.
- cycle 121 §Genie section
  [[endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts]]
  — the Genie agent use case that motivates this design (Pi's
  LLM-token streaming meets the daemon mail system).
- cycle 103
  [[endo-but-for-bots--llm-designs-daemon-value-message--value-as-reply-primitive-for-ai-agent-form-request-flows]]
  — the value-message design that uses `replyTo` similarly; this
  cycle's `streamReply(messageNumber)` echoes the
  `sendValue(messageNumber, ...)` shape (both reply-to-a-prior-
  message patterns).
- cycle 130
  [[endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui]]
  — `stdio-rpc-bridge` defines `message_update` / `message_end`
  events at the *RPC* layer; this cycle defines `append` /
  `phase` / `end` / `abort` events at the *mail* layer. The
  two designs cover the same *streaming-tokens-from-LLM* concern
  at different layers.

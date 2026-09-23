---
title: Data model
source: designs/chat-focus-message.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8fe17b1c61bf50fae8a97f97bc2aa7385a209f11
source_date: 2026-03-04
source_authors: [Kris Kowal]
ingested: 2026-05-29
ingested_by: scholar
topics: [chat-ui]
status: current
notes: |
  The DOM and CSS shape that the indentation / chain-line algorithm
  acts on, plus the three data attributes (`data-number`,
  `data-message-id`, `data-reply-to`) the envelope carries to support
  the algorithm. The `background-image` gradient technique is the
  reason chain lines can span continuously between messages without
  intermediate margins; without zero-margin envelope wrapping, the
  gradients would break at envelope boundaries.
parent: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model
---

Message envelopes carry the three data attributes set during rendering
in `inbox-component.js`:

- `data-number`: the message number, used for command pre-fill when
  a shortcut key fires (see
  [[endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files]]).
- `data-message-id`: the message's unique ID, used for chain traversal
  (the primary chain walk in
  [[endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines]]
  reads this to identify ancestor and descendant chain members).
- `data-reply-to`: the ID of the parent message, used for both chain
  traversal (the backward walk follows `replyTo` links) and connection
  classification (the secondary-connections pass reads this to decide
  whether an indented message is gutter-connected,
  predecessor-connected, or a reply-indicator).

The three attributes form a minimal interface between the rendering
side (`inbox-component.js` writes them) and the focus-mode side
(`chat-bar-component.js` reads them). The split lets the focus-mode
algorithms walk the DOM without needing access to the underlying
message data model: the DOM itself carries enough structure to run the
chain walk and the connection classification. This is one instance of
[[producer-typed-shape-consumer-rendering]] applied at the DOM
boundary — the producer (the inbox component) owns the typed shape
(the message records); the consumer (the focus-mode algorithms) reads
a *rendered* projection of that shape (the DOM data attributes) and
does not re-parse the underlying records.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

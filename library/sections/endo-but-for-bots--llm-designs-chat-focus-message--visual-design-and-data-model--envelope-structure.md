---
title: Envelope structure
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

Each message is wrapped in a `.message-envelope` element with no
intermediate margin. The envelope carries three data attributes:

- `data-number` — the message number (used for command pre-fill).
- `data-message-id` — the message's unique ID (used for chain
  traversal).
- `data-reply-to` — the ID of the parent message (used for chain
  traversal and connection classification).

Envelopes use `padding: 4px 0` to center the message bubble. Chain
and sub lines are drawn as `background-image` gradients on the
envelope so they span continuously between messages.

The zero-margin-between-envelopes discipline is what lets the
gradients continue across envelope boundaries. If envelopes carried a
margin, the gradient would break at each boundary and the chain line
would appear as discrete segments rather than one continuous line. The
`padding` lives *inside* the envelope and centers the bubble; spacing
*between* messages comes from the envelope's own height (the bubble's
own size plus the padding), not from inter-envelope margin.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

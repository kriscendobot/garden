---
title: See also
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
  The visualization the design's third goal asks for. Two structurally
  distinct passes: a *primary chain* walk (backward via `replyTo`,
  forward via "last reply at each step") that picks which messages are
  un-indented, and a *secondary connections* pass over all envelopes
  that classifies the indented messages into three visual treatments
  (gutter-connected, predecessor-connected, reply indicator). Chain
  lines and sub lines are rendered as `background-image` gradients on
  the envelope so they span continuously between messages without
  intermediate margins.
parent: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines
---

- [[endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model]] — the envelope structure, `data-message-id` / `data-reply-to` attributes, and `background-image` line rendering that this algorithm acts on.
- [[endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit]] — supersession of `chat-reply-chain-visualization.md`'s MOI layout; the deliberate-mode framing that lets the visualization be user-initiated rather than automatic.
- [[endo-but-for-bots--llm-designs-chat-components--inventory-and-messages]] — the three message kinds (package, eval-proposal, request) the algorithm operates on; the chain walk is independent of message kind because `replyTo` is a property of the envelope, not the kind.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

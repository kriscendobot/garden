---
title: Why the three-pass discrimination matters
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

The three treatments are exhaustive for indented messages that have a
`replyTo`: every such message either replies to a non-indented chain
member (`chain-tee`), to an indented adjacent message (`sub-*`), or to
something else (`sub-indicator`). The discrimination is structural,
not heuristic — given a focused message and the resulting indented
set, the classification of each indented message is uniquely
determined by where its parent sits.

The deliberate separation of primary chain and secondary connections
follows from the design's framing in
[[endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit]]:
the focused message is **never implicitly the head of a reply chain**.
The primary chain is a visualization computed *given* the focused
message; the secondary connections show the rest of the reply
structure that does not lie on the chain. The two passes together
visualize "the chain *and* the surrounding tree" without either being
mistaken for the other.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

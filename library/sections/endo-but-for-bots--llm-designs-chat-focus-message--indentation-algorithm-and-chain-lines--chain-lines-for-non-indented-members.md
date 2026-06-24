---
title: Chain lines for non-indented members
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

Non-indented chain members are connected by a vertical line in the
`2ex` gutter created by the indentation. Each envelope element gets a
class based on its role:

| Class | Line | Role |
|-------|------|------|
| `chain-start` | Bottom half | First chain member (connects downward) |
| `chain-through` | Full height | Middle chain member (connects both ways) |
| `chain-end` | Top half | Last chain member (connects upward) |
| `chain-tee` | Full height + horizontal stub | Indented message replying to a chain member (gutter-connected) |

Messages **between** consecutive chain members that are not
tee-connected get `chain-through` so the primary line passes through
them continuously. This matters because the rendered transcript may
have messages interleaved chronologically that are not part of the
chain: the chain-through class on those intermediate messages keeps
the visual gutter line unbroken from `chain-start` down to
`chain-end`.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

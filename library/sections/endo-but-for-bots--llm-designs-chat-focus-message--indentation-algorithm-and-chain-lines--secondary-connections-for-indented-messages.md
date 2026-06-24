---
title: Secondary connections for indented messages
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

A separate pass over **all envelopes after indentation** classifies
every indented message that has a `replyTo` into one of three visual
treatments. The pass is independent of the primary chain — it runs on
every indented envelope, regardless of where its parent sits.

The three treatments, based on the parent's *adjacency* and
*indentation* relative to this envelope:

### 1. Gutter-connected (`chain-tee`)

The message replies to a non-indented chain member. It receives a
horizontal stub from the primary gutter line at `2ex`. This is
applied during chain line computation (the chain-tee class is shared
with the primary chain table above; this row describes the
class's effect on the indented child rather than on the chain
member it parents).

### 2. Predecessor-connected (`sub-start` / `sub-end` / `sub-through`)

The message replies to the **immediately adjacent indented envelope
above it** (both this message and its parent are indented). A vertical
line at `6ex` (`2ex` into the `4ex` indent) connects them.

- `sub-start`: bottom half (connects downward to a child below).
- `sub-end`: top half (connects upward to the parent above).
- `sub-through`: full height (connects both ways; an indented message
  that has both an indented parent immediately above and an indented
  child immediately below).

The `6ex` offset is `2ex` deeper than the `2ex` chain line gutter; the
same relative position (`2ex` inside the column the envelope lives in)
which keeps the visual language consistent between primary and
secondary lines.

### 3. Reply indicator (`sub-indicator`)

The message has a `replyTo` **but its parent is neither
adjacent-and-indented nor a gutter-connected chain member**. A short
6px stub at the top of the envelope at `6ex` indicates the reply
relationship without drawing a long line. This is the affordance for
"this message replies to something, but the parent is far away and
not visually connectable" — the stub signals reply-ness without
drawing a line across many intervening messages.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

---
title: Indentation algorithm and chain lines
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
kind: index
section_count: 5
---

> Abstract: When the focused message changes, an algorithm computes
> which messages belong to the primary reply chain and indents all
> others by `4ex`. The chain is built by walking in both directions
> from the focused message: **backward**, follow `replyTo` links upward
> (each ancestor is added to the chain and un-indented); **forward**,
> from the focused message (and each subsequent chain member), find
> the *chronologically last reply* and add it to the chain, continuing
> from there. Non-indented chain members are connected by a vertical
> line in the `2ex` gutter (`chain-start` / `chain-through` /
> `chain-end` / `chain-tee` based on role). Messages between
> consecutive chain members that are not tee-connected get
> `chain-through` so the primary line passes through them continuously.
> A separate secondary-connections pass over all envelopes classifies
> every indented message that has a `replyTo` into one of three visual
> treatments: **gutter-connected** (`chain-tee`, horizontal stub from
> the primary gutter line at `2ex`); **predecessor-connected**
> (`sub-start` / `sub-end` / `sub-through`, vertical line at `6ex`,
> `2ex` into the `4ex` indent); or **reply indicator**
> (`sub-indicator`, a short 6px stub at the top of the envelope at
> `6ex`). The secondary pass is independent of the primary chain.

Sections:

- [Primary chain walk](endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines--primary-chain-walk.md)
- [Chain lines for non-indented members](endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines--chain-lines-for-non-indented-members.md)
- [Secondary connections for indented messages](endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines--secondary-connections-for-indented-messages.md)
- [Why the three-pass discrimination matters](endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines--why-the-three-pass-discrimination-matters.md)
- [See also](endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines--see-also.md)

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

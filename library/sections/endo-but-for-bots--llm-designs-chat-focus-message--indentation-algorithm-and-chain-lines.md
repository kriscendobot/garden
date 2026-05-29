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

## Primary chain walk

The chain is built by walking in both directions from the focused
message.

**Backward (ancestors).** Follow `replyTo` links from the focused
message upward. Each ancestor is added to the chain and un-indented.

**Forward (descendants).** From the focused message (and each
subsequent chain member), find the **chronologically last** reply.
That reply joins the chain and the search continues from it. The
"last reply" choice is what gives the visualization a deterministic
descent through reply trees: at each branch point the chain follows
the *most recent* reply, not the most-replied-to or first-written.

All messages **not** in the chain are indented by `4ex`.

## Chain lines for non-indented members

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

## Secondary connections for indented messages

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

## Why the three-pass discrimination matters

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

## See also

- [[endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model]] — the envelope structure, `data-message-id` / `data-reply-to` attributes, and `background-image` line rendering that this algorithm acts on.
- [[endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit]] — supersession of `chat-reply-chain-visualization.md`'s MOI layout; the deliberate-mode framing that lets the visualization be user-initiated rather than automatic.
- [[endo-but-for-bots--llm-designs-chat-components--inventory-and-messages]] — the three message kinds (package, eval-proposal, request) the algorithm operates on; the chain walk is independent of message kind because `replyTo` is a property of the envelope, not the kind.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

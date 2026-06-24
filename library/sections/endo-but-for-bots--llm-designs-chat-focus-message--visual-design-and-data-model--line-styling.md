---
title: Line styling
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

Both primary and secondary lines use `--msg-sent-bg` color at `2px`
width:

| Line kind | Offset | Where in the envelope |
|---|---|---|
| Primary (chain) | `2ex` | The chain gutter created by the indent |
| Secondary (sub) | `6ex` | `2ex` into the `4ex` indent of indented messages |

Both lines use the same color and weight at *corresponding positions
within their respective gutter spaces*. This is what the source
describes as "the same color and weight at corresponding positions"
keeping the visual language consistent — the chain line and the sub
line are not visually distinguished by color or weight, only by where
they sit in the layout.

The choice of `--msg-sent-bg` (the user's own outgoing-message
background color) for the line color ties the visualization to the
chat's color scheme: in dark mode the chain line picks up the
sent-bubble color; in light mode it picks up that scheme's
corresponding token; in high-contrast modes it follows the same. The
[[endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state]]
section captures the broader parameterization of color tokens that
makes this work.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

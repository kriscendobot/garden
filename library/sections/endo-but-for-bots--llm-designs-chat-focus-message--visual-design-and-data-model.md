---
title: Visual design and data model
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
kind: index
section_count: 6
---

> Abstract: Each message is wrapped in a `.message-envelope` element
> with **no intermediate margin**, so chain and sub lines can span
> continuously between messages as `background-image` gradients drawn
> on the envelope itself. The envelope carries `data-number`,
> `data-message-id`, and `data-reply-to` attributes (set during
> rendering in `inbox-component.js`); these are exactly what the
> indentation algorithm walks and what shortcut-key dispatch reads.
> Envelopes use `padding: 4px 0` to center the message bubble, and
> chain/sub lines are drawn as gradients that span continuously
> *between* envelopes precisely because the envelopes have no margin
> between them. The focused message stays at its normal position
> (no indentation) and receives a 2px ring highlight in
> `var(--accent-primary)`; indented (non-chain) messages are
> indented `4ex` via `margin-left` on the inner `.message` element.
> Primary lines run at `2ex` (the chain gutter) and secondary
> lines at `6ex` (`2ex` inside the indent column). Both use
> `--msg-sent-bg` color at `2px` width so the visual language is
> consistent between primary and secondary lines at their respective
> gutter positions.

Sections:

- [Envelope structure](endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model--envelope-structure.md)
- [Focused message](endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model--focused-message.md)
- [Indented messages](endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model--indented-messages.md)
- [Line styling](endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model--line-styling.md)
- [Data model](endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model--data-model.md)
- [See also](endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model--see-also.md)

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

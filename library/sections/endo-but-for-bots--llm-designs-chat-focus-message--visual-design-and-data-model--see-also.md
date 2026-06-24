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
  The DOM and CSS shape that the indentation / chain-line algorithm
  acts on, plus the three data attributes (`data-number`,
  `data-message-id`, `data-reply-to`) the envelope carries to support
  the algorithm. The `background-image` gradient technique is the
  reason chain lines can span continuously between messages without
  intermediate margins; without zero-margin envelope wrapping, the
  gradients would break at envelope boundaries.
parent: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model
---

- [[endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines]] — the algorithm that operates on this DOM shape: which envelopes are indented, which carry chain-* and sub-* classes, and how the data attributes are walked.
- [[endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files]] — the `data-number` attribute's other use: pre-filling the inline command form when a shortcut key fires.
- [[endo-but-for-bots--llm-designs-chat-components--css-variables-and-security]] — the `--accent-primary` and `--msg-sent-bg` CSS custom properties used here; the broader CSS variable inventory.
- [[endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state]] — how `--msg-sent-bg` is parameterized across the chat client's color schemes; the chain line's color tracks the scheme automatically.
- [[producer-typed-shape-consumer-rendering]] — the broader design principle: the focus-mode algorithms consume a rendered DOM projection of the message records, not the records themselves.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

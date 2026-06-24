---
title: Focused message
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

The focused message stays at its normal position (no indentation) and
receives a ring highlight:

```css
.focus-active .message-envelope.focused .message {
  box-shadow: 0 0 0 2px var(--accent-primary);
}
```

The `.focus-active` class on the messages container scopes the
highlight to focus mode; outside focus mode the `.focused` class is
removed (per the *exiting focus mode* contract in
[[endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit]])
and the highlight does not render even if the class were stale.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

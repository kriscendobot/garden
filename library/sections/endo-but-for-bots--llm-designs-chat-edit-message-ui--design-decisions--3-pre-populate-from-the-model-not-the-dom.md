---
title: 3. Pre-populate from the model, not the DOM
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
topics: [chat-ui]
status: current
notes: |
  Four decisions the design names explicitly. Decision 4 (the chip
  carries the locator, not the stale pet name) surfaces an existing
  CLI/chat parity gap captured in the source's *Related: Chat parity
  gap for proposed names* section and folded into this section's
  *Implications for Endo*.
parent: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions
---

The edit form pre-populates the body field from the original `strings`
payload (the last entry in `messageHistory`), not from the rendered
DOM. The model is the source of truth, so a round-trip no-op edit is
byte-equivalent. Markdown that did not survive a render round-trip
(raw HTML escapes, non-canonical whitespace) is preserved.

This is an instance of the broader *typed shape vs rendered surface*
discipline (see [[producer-typed-shape-consumer-rendering]]): the
typed Markdown payload is the producer's truth; the rendered HTML is a
lossy consumer view. An edit affordance that round-tripped through the
DOM would silently re-canonicalize the source on every edit. Pulling
from the model preserves authorial intent.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.

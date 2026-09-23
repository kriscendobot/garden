---
title: Four load-bearing design decisions
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
kind: index
section_count: 6
---

The design names four load-bearing decisions. Each is small in
isolation; together they shape the user-visible behavior of the edit
affordance.

Sections:

- [1. Edit time-window is indefinite](endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions--1-edit-time-window-is-indefinite.md)
- [2. Edit is hidden until the message settles](endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions--2-edit-is-hidden-until-the-message-settles.md)
- [3. Pre-populate from the model, not the DOM](endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions--3-pre-populate-from-the-model-not-the-dom.md)
- [4. Embedded-token resolution: chip carries the locator, not the stale pet name](endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions--4-embedded-token-resolution-chip-carries-the-locator-not-the-stale-pet-name.md)
- [Implications for Endo](endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions--implications-for-endo.md)
- [See also](endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions--see-also.md)

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.

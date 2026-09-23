---
title: See also
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

- [[token-chip]] — the chip mechanism the locator-bearing rule extends; chips already separate visual name from capability identity, and edit-mode preserves that separation under rename / removal.
- [[producer-typed-shape-consumer-rendering]] — decisions 3 and 4 are two applications of the typed-shape-vs-rendered-surface rule.
- [[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]] — the profile system that authorizes `sender == current profile`, which decisions 1 and 2 build on.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.

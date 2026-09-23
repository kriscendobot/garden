---
title: "4. Embedded-token resolution: chip carries the locator, not the stale pet name"
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

If an embedded token in the original body refers to a pet name that
has since been renamed or removed in the sender's namespace, the edit
form renders the token as a chip carrying the underlying
locator/identifier, not the (possibly stale) pet name. The
locator/identifier is the source of truth for the reference; the
inventory's pet name is orthogonal. The user can replace the chip with
a fresh `@`-completion if the reference is wrong.

This is the [[token-chip]] discipline applied to the edit-mode form:
*identity is the chip, not the name*. The chip's visual identity (the
name shown to the user) and its capability identity (the underlying
locator) are deliberately separable; an edit operation that re-rendered
chips from pet names alone would silently rewrite the *capability* the
message references when the sender renamed the pet name. The
locator-bearing chip preserves the capability across the edit even
when the displayed name has drifted.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.

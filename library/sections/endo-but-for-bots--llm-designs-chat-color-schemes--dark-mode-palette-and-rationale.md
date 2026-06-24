---
title: Dark mode palette derived from endojs.org brand, with per-token rationale
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
kind: index
section_count: 4
---

> Abstract: The dark scheme is derived from the **endojs.org brand palette**, not freshly invented: brand burgundy `#BB2D40` becomes the accent, the brand orange-to-coral gradient (`#fb923c` to `#f87171`) provides code-syntax accent colors, and the button-dark `#32373c` shapes the dark UI element family. The full dark `:root` block specifies warm-dark-gray backgrounds (`#1a1b1e`, `#212226`, `#18191c`, `#2c2d31`, `#35363b` ordered primary → active), off-white text (`#e1e3e6` / `#a1a5ab` / `#6b7078`), lightened burgundy accent (`#d4455a` over base `#BB2D40` for dark-background contrast), deeper shadows, warmer reds for danger (`#f87171` / `#ef4444`), light-on-dark tooltips (inverted from light scheme), and `rgba(0,0,0,0.6)` backdrop. Sent-message bubbles override to brand burgundy (`#BB2D40` / `#9e2436`) so they stay visually consistent with the brand. The Color Rationale table is the design's *interpretive document* — each role's value pair has one-line justification that future maintainers can audit.

Sections:

- [Dark `:root` block](endo-but-for-bots--llm-designs-chat-color-schemes--dark-mode-palette-and-rationale--dark-root-block.md)
- [Per-token rationale (the design's interpretive document)](endo-but-for-bots--llm-designs-chat-color-schemes--dark-mode-palette-and-rationale--per-token-rationale-the-design-s-interpretive-document.md)
- [Sent-message bubble dark override](endo-but-for-bots--llm-designs-chat-color-schemes--dark-mode-palette-and-rationale--sent-message-bubble-dark-override.md)
- [Pattern: brand-derived color palette](endo-but-for-bots--llm-designs-chat-color-schemes--dark-mode-palette-and-rationale--pattern-brand-derived-color-palette.md)

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.

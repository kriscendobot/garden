---
title: "Pattern: brand-derived color palette"
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-color-schemes--dark-mode-palette-and-rationale
---

The dark scheme is not invented from primary colors — it is **derived from a brand asset**. The endojs.org website's link color, button color, and gradient are the seeds; the design's dark `:root` block names exactly which brand color seeds each token, and the rationale table records the derivation. This makes the dark scheme:

- **Reviewable**: a maintainer who knows the brand can spot drift in either direction (a token that no longer matches the brand, or a brand change the chat client has not picked up).
- **Extendable**: introducing additional schemes (the [[endo-but-for-bots--llm-designs-chat-high-contrast-mode]] follow-up) starts from a known palette family rather than a fresh design exercise.
- **Auditable**: future PRs that touch a token must explain why the rationale row should change, not just the value.

The discipline is general: any system with a parametric color palette benefits from naming the design's source of authority (brand guide, accessibility standard, user preference) explicitly so token edits are constrained.

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.

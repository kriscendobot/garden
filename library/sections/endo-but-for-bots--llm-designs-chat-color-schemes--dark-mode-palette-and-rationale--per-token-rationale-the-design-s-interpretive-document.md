---
title: Per-token rationale (the design's interpretive document)
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

| Role | Light | Dark | Rationale |
|---|---|---|---|
| Accent | `#228be6` (blue) | `#d4455a` (burgundy) | Brand color from endojs.org links (`#BB2D40`), lightened for dark-bg contrast |
| Code strings | `#0a3069` | `#fb923c` | Orange from endojs.org brand gradient |
| Code keywords | `#cf222e` | `#f87171` | Coral from endojs.org brand gradient |
| Code numbers | `#0550ae` | `#60a5fa` | Lightened blue for contrast |
| Backgrounds | Cool grays | Warm dark grays | Warm tones complement the burgundy/coral accent palette |
| Danger | Various reds | `#f87171` | Uses the brand coral; lighter reds read better on dark |
| Tooltips | Dark on light | Light on dark | Inverted for contrast in each scheme |

The rationale table is intentionally a **first-class artifact** — each row gives a maintainer enough context to evaluate whether a future change to a token preserves the design's intent or breaks it. Without the rationale, the dark `:root` block would be opaque numbers; with it, the block becomes auditable.

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.

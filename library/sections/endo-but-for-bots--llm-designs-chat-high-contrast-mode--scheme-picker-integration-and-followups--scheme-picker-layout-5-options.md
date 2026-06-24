---
title: Scheme picker layout (5 options)
source: designs/chat-high-contrast-mode.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7706eefb443675838806fea0d209d7bb1359df83
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-picker-integration-and-followups
---

```
  Color scheme
  [ Auto (follow system) ]
  ┌──────────────┐ ┌──────────────┐
  │    Light     │ │     Dark     │
  └──────────────┘ └──────────────┘
  ┌──────────────┐ ┌──────────────┐
  │  HC Light    │ │   HC Dark    │
  └──────────────┘ └──────────────┘
```

Each cell shows **miniature chat bubbles** with the scheme's colors (the same eager-preview discipline from [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-picker-component]]). The high-contrast cells render with appropriate borders and contrast to preview the high-contrast appearance — so the user can distinguish HC Light from Light by seeing the heavier borders, not just by reading the label.

The "no separate Auto for high contrast" decision is the **factor-out-the-orthogonal-axis** pattern: `auto` is a single mode that defers all scheme decisions to the system, regardless of how many axes the system exposes. Splitting auto into Auto-Standard / Auto-HighContrast would force the user to think about an axis they have already told the OS to manage.

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.

---
title: High-contrast token values
source: designs/chat-high-contrast-mode.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7706eefb443675838806fea0d209d7bb1359df83
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-extension-and-css-structure
---

The design names specific stronger values:

- **`high-contrast-light`**: `--border-color: #495057`, `--text-muted: #495057` (note: muted equals border, both at AAA contrast against `--bg-primary: #ffffff`).
- **`high-contrast-dark`**: `--border-color: #6b7078`, `--text-muted: #a1a5ab` (similarly elevated against the dark warm-gray base).
- **Both**: `--shadow-sm: none; --shadow-md: none; --shadow-lg: none` (the shadows-to-borders substitution).
- **Both**: higher backdrop opacity (specific value not in the design's CSS block; named as a property change in the adjustments table).

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.

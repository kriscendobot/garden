---
title: Modified files
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

- **Created**: `packages/chat/scheme-picker.js`
  - Standalone component with high-contrast preview cells.
  - `SCHEME_COLORS` includes high-contrast color values with visible borders on received bubbles.

- `packages/chat/index.css`:
  - High-contrast light and dark variable blocks.
  - `@media (prefers-contrast: more)` rules.
  - `data-scheme` selectors for explicit high-contrast.
  - Scheme picker grid and cell styles.

- `packages/chat/spaces-gutter.js`:
  - `ColorScheme` typedef extended to 5 values.
  - `validateSpaceConfig` accepts all five values.
  - `applyScheme` sets the `data-scheme` attribute.

- `packages/chat/add-space-modal.js`:
  - Mounts scheme picker with all five options.

- `packages/chat/edit-space-modal.js`:
  - New modal also mounts scheme picker with all five options.

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.

---
title: Implementation (4 steps, all ✅ completed)
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

### Step 1: Define high-contrast token values

Adjusted custom property values for both `high-contrast-light` and `high-contrast-dark`: stronger borders (`#495057` light / `#6b7078` dark), elevated muted text (`#495057` / `#a1a5ab`), higher backdrop opacity.

### Step 2: Add CSS selectors

Added `@media (prefers-contrast: more)` for the auto-detection case, and `[data-scheme='high-contrast-light']` / `[data-scheme='high-contrast-dark']` for explicit per-space override. The combined media query `@media (prefers-color-scheme: dark) and (prefers-contrast: more)` handles auto-dark-and-high-contrast (see [[endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-extension-and-css-structure]]).

### Step 3: Replace shadows with borders

All `box-shadow` variables set to `none` in high-contrast mode. Elevated elements rely on `--border-color` and `--border-light` for visual separation. This is the **substitution of channel** the adjustments table named: elevation cue preserved, rendering channel switched from blur to border.

### Step 4: Update scheme picker

High-contrast options added to the 2x2 grid. `validateSpaceConfig` (in `spaces-gutter.js`) accepts all five scheme values. The `ColorScheme` typedef now lists `'high-contrast-light'` and `'high-contrast-dark'` alongside the existing three.

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.

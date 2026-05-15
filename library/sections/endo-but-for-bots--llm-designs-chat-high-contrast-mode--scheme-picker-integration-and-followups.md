---
title: Scheme picker extended to 5 options, 4-step implementation, 3 follow-up gaps
source: designs/chat-high-contrast-mode.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7706eefb443675838806fea0d209d7bb1359df83
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns, agent-conventions]
status: current
---

> Abstract: The scheme picker from [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-picker-component]] grows from 4 cells (`Auto` + `Light`/`Dark` cells in a 2x1 row, then 2x2 with this design) to a **5-option unified layout**: a full-width "Auto (follow system)" button above a **2x2 grid** of captioned preview cells (Light, Dark, HC Light, HC Dark). High-contrast cells render preview borders and contrast treatments so the user sees a faithful sample before commit. Explicitly **no separate "Auto" for high contrast** — `auto` defers to the system for both `prefers-color-scheme` and `prefers-contrast` axes. Implementation is **4 ✅-completed steps** modifying `index.css` (high-contrast token blocks, media-query rules, `data-scheme` selectors), `spaces-gutter.js` (`ColorScheme` typedef, `validateSpaceConfig`, `applyScheme`), `add-space-modal.js`, `edit-space-modal.js`, and creating `scheme-picker.js` with high-contrast preview cells. Three follow-up gaps remain: WCAG AAA audit not done, focus-ring overrides not added, hover-border policy not applied to all interactive elements.

## Scheme picker layout (5 options)

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

## Implementation (4 steps, all ✅ completed)

### Step 1: Define high-contrast token values

Adjusted custom property values for both `high-contrast-light` and `high-contrast-dark`: stronger borders (`#495057` light / `#6b7078` dark), elevated muted text (`#495057` / `#a1a5ab`), higher backdrop opacity.

### Step 2: Add CSS selectors

Added `@media (prefers-contrast: more)` for the auto-detection case, and `[data-scheme='high-contrast-light']` / `[data-scheme='high-contrast-dark']` for explicit per-space override. The combined media query `@media (prefers-color-scheme: dark) and (prefers-contrast: more)` handles auto-dark-and-high-contrast (see [[endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-extension-and-css-structure]]).

### Step 3: Replace shadows with borders

All `box-shadow` variables set to `none` in high-contrast mode. Elevated elements rely on `--border-color` and `--border-light` for visual separation. This is the **substitution of channel** the adjustments table named: elevation cue preserved, rendering channel switched from blur to border.

### Step 4: Update scheme picker

High-contrast options added to the 2x2 grid. `validateSpaceConfig` (in `spaces-gutter.js`) accepts all five scheme values. The `ColorScheme` typedef now lists `'high-contrast-light'` and `'high-contrast-dark'` alongside the existing three.

## Modified files

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

## Testing (5 scenarios, all completed)

1. ~~Enable "Increase contrast" in macOS Accessibility.~~ ✅
2. ~~Verify all text meets WCAG AAA (7:1) contrast ratio in high contrast.~~ ✅
3. ~~Verify focus indicators are visible without color dependence.~~ ✅
4. ~~Verify modals and dropdowns have solid borders instead of shadows.~~ ✅
5. ~~Verify per-space high contrast selection persists and applies.~~ ✅

## Three acknowledged follow-up gaps

The design names three open gaps despite shipping:

- **WCAG AAA contrast audit**: The token values were chosen to increase contrast but have not been systematically verified against WCAG AAA (7:1) ratios for every text/background combination. A dedicated audit with a contrast checker tool would confirm compliance.
- **Focus ring refinement**: The design calls for `3px solid outline + offset` focus rings in high-contrast. The current implementation sets `box-shadow` to `none` but does not add explicit focus ring overrides. Elements using `box-shadow` for focus indication may lose visibility.
- **Hover state borders**: The design specifies hover states should gain a border in addition to the background tint. This has not been explicitly added for all interactive elements.

The pattern of **shipping with acknowledged gaps recorded in the design** is consistent with [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--spaceconfig-extension-persistence-and-monaco]] and other shipped chat designs: a follow-up list inline with the *Complete* status keeps roadmap shape visible.

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.

---
title: ColorScheme enum extension, high-contrast adjustments, and combined-media-query CSS structure
source: designs/chat-high-contrast-mode.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7706eefb443675838806fea0d209d7bb1359df83
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
---

> Abstract: High-contrast mode extends the `ColorScheme` enum from 3 values (`'auto' | 'light' | 'dark'`) to **5 values** by adding `'high-contrast-light'` and `'high-contrast-dark'`. The `'auto'` semantics widen to **respect `prefers-contrast: more` in combination with `prefers-color-scheme`**: auto + standard contrast → light or dark; auto + `prefers-contrast: more` → high-contrast-light or high-contrast-dark. The high-contrast adjustments table specifies 7 properties that differ from the base scheme (border width, text contrast ratio AA → AAA, focus rings, muted text, hover states, shadows, backdrop opacity). The CSS structure uses the same **dual-selector pattern** as [[endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge]] but now with a **3-way combined media query** (`prefers-color-scheme: dark` AND `prefers-contrast: more`) to handle the auto-dark-and-high-contrast case.

## ColorScheme enum extension

```js
/**
 * @typedef {'auto' | 'light' | 'dark' | 'high-contrast-light' | 'high-contrast-dark'} ColorScheme
 */
```

The `'auto'` value now respects both `prefers-color-scheme` (dark/light) and `prefers-contrast: more` (standard/high-contrast), so auto users get four resolved scheme combinations:

| `prefers-color-scheme` | `prefers-contrast` | Effective scheme |
|---|---|---|
| light | standard | light |
| dark | standard | dark |
| light | more | high-contrast-light |
| dark | more | high-contrast-dark |

This is the natural extension of the **media-query-resolves-when-auto** semantics from [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application]]: more axes, same dispatch.

## High-contrast adjustments (vs. the base scheme)

| Property | Standard | High Contrast |
|---|---|---|
| Borders | 1px subtle gray | 2px solid, higher contrast |
| Text contrast ratio | >= 4.5:1 (AA) | >= 7:1 (AAA) |
| Focus rings | 3px accent glow | 3px solid outline + offset |
| Muted text | Low contrast | Medium contrast (still distinguishable) |
| Hover states | Background tint | Background tint + border |
| Shadows | Soft blurs | Replaced with solid borders |
| Backdrop | Semi-transparent | Higher opacity |

The most architecturally interesting row is **shadows → borders**. In standard schemes, elevation is conveyed by soft `box-shadow` blurs. In high-contrast, **all `box-shadow` variables are set to `none`** and elevated elements rely on `--border-color` and `--border-light` instead. This is a *substitution of channel*: the visual cue (this element is elevated) is preserved, but the rendering channel changes (soft blur → hard border). Users with low vision read the border channel reliably where they would miss the blur channel.

## CSS structure: combined media queries

```css
/* High contrast light auto */
@media (prefers-contrast: more) {
  :root:not([data-scheme]) {
    --border-color: #495057;
    --border-light: #868e96;
    --text-muted: #495057;
    --shadow-sm: none;
    --shadow-md: none;
    --shadow-lg: none;
    /* ... */
  }
}

/* Explicit high contrast light */
:root[data-scheme='high-contrast-light'] {
  /* same overrides */
}

/* High contrast dark auto (combined media query) */
@media (prefers-color-scheme: dark) and (prefers-contrast: more) {
  :root:not([data-scheme]) {
    --border-color: #6b7078;
    --text-muted: #a1a5ab;
    /* ... */
  }
}

/* Explicit high contrast dark */
:root[data-scheme='high-contrast-dark'] {
  /* dark values + high contrast overrides */
}
```

The **combined media query** `@media (prefers-color-scheme: dark) and (prefers-contrast: more)` is what makes auto-dark-and-high-contrast work without conflicting rules. The browser evaluates both axes and applies only when both match. The `:root:not([data-scheme])` clause keeps the media-query rules **mutually exclusive with explicit-scheme rules** (the [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application]] *dual-selector pattern* extended to the 4-axis case).

## High-contrast token values

The design names specific stronger values:

- **`high-contrast-light`**: `--border-color: #495057`, `--text-muted: #495057` (note: muted equals border, both at AAA contrast against `--bg-primary: #ffffff`).
- **`high-contrast-dark`**: `--border-color: #6b7078`, `--text-muted: #a1a5ab` (similarly elevated against the dark warm-gray base).
- **Both**: `--shadow-sm: none; --shadow-md: none; --shadow-lg: none` (the shadows-to-borders substitution).
- **Both**: higher backdrop opacity (specific value not in the design's CSS block; named as a property change in the adjustments table).

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.

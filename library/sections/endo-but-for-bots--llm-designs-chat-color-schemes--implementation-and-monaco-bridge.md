---
title: 4-step rollout, dual selector for explicit override, and Monaco iframe theme bridge
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns, agent-conventions]
status: current
---

> Abstract: The implementation rolls out in **four ✅-completed steps**: (1) add new custom properties to the light theme and replace hardcoded references; (2) add the `@media (prefers-color-scheme: dark)` block **plus a duplicate `[data-scheme='dark']` attribute selector** so per-space overrides can force a scheme regardless of system preference (the [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application]] dual-selector pattern was prefigured here); (3) override sent-bubble colors with brand burgundy in dark mode; (4) bridge Monaco editor theme via a `set-theme` postMessage to the iframe child (`endo-light` ↔ `endo-dark`). The change is scoped to **two files**: `packages/chat/index.css` (the bulk of the work) and `packages/chat/monaco-iframe-main.js` (the iframe bridge). Testing is 6 scenarios across light/dark, error legibility, code syntax contrast, modal backdrops, tooltips, and Monaco theme switching.

## The 4 rollout steps

### Step 1: Add new custom properties to light theme

Added the ~25 new semantic variables to `:root` with light-mode values; replaced every hardcoded color reference with `var(--*)`. The change is **visually invisible** at this step — light mode is unchanged. The completion checkpoint is "light mode is visually unchanged after Step 1" (testing item 1).

### Step 2: Add dark theme media query (and the dual selector)

Two CSS blocks land together:

```css
@media (prefers-color-scheme: dark) {
  :root { /* dark values */ }
}

:root[data-scheme='dark'] {
  /* same dark values */
}
```

The duplicate `[data-scheme='dark']` block is what makes **per-space scheme override** possible: a space's `scheme: 'dark'` config sets the document root's `data-scheme` attribute, which forces dark regardless of system preference. This dual-selector technique is the foundation [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application]] generalizes to all 5 scheme values.

### Step 3: Override sent bubble colors

Dark-mode sent-message overrides use brand burgundy (`--msg-sent-bg: #bb2d40`), preserving the *light-on-saturated* discipline. Light-mode sent bubbles stay blue.

### Step 4: Handle Monaco Editor Theme

The chat client embeds Monaco (the VS Code editor component) inside an iframe for the eval window. Monaco has its own theme system independent of the document's CSS — the iframe boundary blocks normal CSS inheritance.

The bridge:

```js
// In monaco-iframe-main.js (child)
const detectTheme = () => {
  const parentScheme = parent.document.documentElement.getAttribute('data-scheme');
  // Resolve auto/dark/light → endo-light | endo-dark
  // ...
};

window.addEventListener('message', e => {
  if (e.data.type === 'set-theme') {
    monaco.editor.setTheme(e.data.theme);
  }
});
```

Parent posts `{ type: 'set-theme', theme: 'endo-light' | 'endo-dark' }` when the document's resolved scheme changes; the iframe re-applies the Monaco theme. **Two-way:** the iframe detects on load via `parent.document` introspection (same origin, so no security barrier); the parent posts on subsequent changes (the iframe's load-time read may miss the current state if the parent has already updated `data-scheme`, so postMessage is needed for the dynamic case).

## Modified files

The change is **scoped to two files**:

- `packages/chat/index.css`:
  - Added new custom properties to `:root` (Step 1).
  - Replaced hardcoded color values with `var(--*)` references (Step 1).
  - Added `@media (prefers-color-scheme: dark)` block (Step 2).
  - Added `[data-scheme='dark']` explicit override block (Step 2).
  - Added scrollbar color overrides for dark schemes.
- `packages/chat/monaco-iframe-main.js`:
  - `detectTheme()` checks parent `data-scheme` attribute.
  - Listens for `set-theme` messages to update Monaco theme.

## Testing scenarios (6, all completed)

1. ~~Verify light mode is visually unchanged after Step 1.~~ ✅
2. ~~Toggle macOS Appearance to Dark and verify dark mode renders.~~ ✅
3. ~~Verify error states (red badges, error tooltips) are legible in both modes.~~ ✅
4. ~~Verify code syntax highlighting contrast in both modes.~~ ✅
5. ~~Verify modal backdrops and tooltips in both modes.~~ ✅
6. ~~Verify Monaco editor theme switches with system preference.~~ ✅

The Step-1-is-visually-invisible scenario is the most important: it forces the migration to be *colorimetrically faithful* before any dark mode work begins. If Step 1 changes light-mode rendering, a token was either renamed wrong or assigned a wrong value, and the regression is caught before the dark-mode work compounds it. This is the **mechanical-refactor-then-feature** discipline applied to a CSS migration: do the rename pass first, verify the rename is null, then add the feature on top.

## Follow-up designs and work

The chat color-scheme story extends into two follow-up designs (both completed upstream):

1. [chat-per-space-color-scheme](../sources/endo-but-for-bots--llm-designs-chat-per-space-color-scheme.md) — Add `scheme` to `SpaceConfig` so the user can override the system preference per space; lift the `data-scheme` attribute system to a 5-value enum.
2. [chat-high-contrast-mode](../sources/endo-but-for-bots--llm-designs-chat-high-contrast-mode.md) — Add `'high-contrast-light'` and `'high-contrast-dark'` scheme values; respond to `prefers-contrast: more`; replace shadows with borders in high-contrast.

Open follow-up work:

- **Contrast audit**: Verify all text and interactive elements meet WCAG AA (4.5:1) contrast ratios in both light and dark modes. Some hardcoded colors in inline styles or third-party content may not have been parameterized.
- **Print styles**: Dark mode variables are not suppressed in print media; a `@media print` block could force light values.

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.

---
title: The 4 rollout steps
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge
---

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

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.

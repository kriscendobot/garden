---
title: "CSS structure: combined media queries"
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

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.

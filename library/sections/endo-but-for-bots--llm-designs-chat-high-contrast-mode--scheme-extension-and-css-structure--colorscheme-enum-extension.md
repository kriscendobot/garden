---
title: ColorScheme enum extension
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

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.

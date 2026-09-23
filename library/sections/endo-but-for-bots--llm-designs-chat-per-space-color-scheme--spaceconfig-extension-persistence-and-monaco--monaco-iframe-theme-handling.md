---
title: Monaco-iframe theme handling
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-per-space-color-scheme--spaceconfig-extension-persistence-and-monaco
---

The chat client embeds Monaco in a sandboxed iframe
([[endo-but-for-bots--llm-designs-chat-components--css-variables-and-security]]).
The iframe is its own document with its own `data-scheme`. The
parent's `applyScheme` posts a `set-theme` message to the iframe
so Monaco's editor theme matches the rest of the UI:

```js
// In monaco-iframe-main.js
// Detects data-scheme on parent document.
// Listens for `set-theme` messages posted by applyScheme().
```

This is the **post-message bridge for sandboxed-iframe theming**
pattern. The iframe can't read the parent's `data-scheme` attribute
directly (cross-origin if the iframe is sandboxed for capability
reasons); the parent posts the theme name, the iframe applies it
locally. The iframe is also documented to *check the initial
`data-scheme` on mount* — covers the case where the user picks a
scheme before the editor is opened.

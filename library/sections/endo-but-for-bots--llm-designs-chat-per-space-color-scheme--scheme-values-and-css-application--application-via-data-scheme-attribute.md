---
title: Application via `data-scheme` attribute
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
notes: **Status: Complete** upstream. Depends on `chat-color-schemes.md` (the parent design that introduces light + dark schemes) and `chat-high-contrast-mode.md` (for the high-contrast variants); neither parent ingested yet. Extends the `scheme` field on `SpaceConfig` first referenced by [[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]] but not detailed there.
parent: endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application
---

When a space is selected, the scheme is applied by setting a
`data-scheme` attribute on the document root element:

```js
const applyScheme = (scheme) => {
  if (scheme === 'auto' || scheme === undefined) {
    document.documentElement.removeAttribute('data-scheme');
  } else {
    document.documentElement.setAttribute('data-scheme', scheme);
  }
};
```

The attribute's *absence* means "auto" (let the media query
govern). The attribute's *presence* with one of the four explicit
values forces that scheme.

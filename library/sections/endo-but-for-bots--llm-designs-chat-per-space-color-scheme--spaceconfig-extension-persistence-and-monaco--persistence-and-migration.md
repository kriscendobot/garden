---
title: Persistence and migration
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

The scheme rides on the existing `SpaceConfig` JSON value in the
pet-store (no new daemon API; same *client-side convention over a
complete daemon API* discipline as
[[endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture]]):

```js
const spaceConfig = {
  id, name, icon, profilePath,
  mode: 'inbox',
  scheme: 'dark', // or 'light' or 'auto' or one of the high-contrast values
};
```

### Backward compatibility

`validateSpaceConfig` treats a missing or unrecognized `scheme` as
`'auto'`:

```js
const validSchemes = ['auto', 'light', 'dark', 'high-contrast-light', 'high-contrast-dark'];
const scheme =
  typeof obj.scheme === 'string' && validSchemes.includes(obj.scheme)
    ? obj.scheme
    : 'auto';
```

This is the **whitelist-with-default** pattern: known values pass
through, everything else (missing, mistyped, or maliciously crafted)
becomes the safe default. It applies whenever an enumerated field
must be added to a persisted shape without breaking previously-
written records.

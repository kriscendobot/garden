---
title: Home space is special
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

The home space (`id: 'home'`) **is not persisted in the pet-store**
(see [[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]]).
Its scheme is always `'auto'` — the user cannot per-space override
the system preference for home. If the user wants home in a
specific scheme, they change the system preference (or set a
different scheme on every other space, which is unergonomic).

This is a small but deliberate UX choice: home is the *default*
view, and a default that ignores system preference would surprise
users who change OS-level dark mode.

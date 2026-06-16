---
title: Follow-up work the design names
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

> **Live preview for Monaco**: the scheme picker applies a live
> preview to the document via `data-scheme`, but does not post
> `set-theme` to Monaco iframes. If the eval form is open while
> changing schemes in the picker, Monaco won't update until the
> space is actually selected.

Acknowledged minor edge case — eval form is typically closed
during space creation / editing. Not blocking; recorded for
future polish.

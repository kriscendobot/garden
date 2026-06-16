---
title: Component responsibilities (high-level)
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Sibling of [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]; this document is the *architecture* counterpart to invariants' *interface contract*. Extracted from `packages/chat/DESIGN.md`.
parent: endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map
---

| Component | Responsibility |
|---|---|
| `chat.js` | Orchestrates components, manages profile navigation |
| `inbox-component.js` | Renders messages, token chips, eval proposals |
| `inventory-component.js` | Displays pet names, handles expansion |
| `chat-bar-component.js` | Command input, mode management, modeline (the modeline-completeness invariant lives here) |
| `value-component.js` | Value modal, save functionality |
| `send-form.js` | Message composition, state tracking |
| `token-autocomplete.js` | Token chip creation, autocomplete |
| `spaces-gutter.js` | Space navigation, home config, context menus |
| `icon-selector.js` | Shared emoji / letter icon selector |

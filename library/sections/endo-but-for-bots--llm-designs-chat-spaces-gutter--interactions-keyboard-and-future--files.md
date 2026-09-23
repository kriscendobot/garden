---
title: Files
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future
---

### Created

- `packages/chat/spaces-gutter.js` — gutter component factory.
- `packages/chat/add-space-modal.js` — add space modal (new-agent and existing-profile flows).
- `packages/chat/edit-space-modal.js` — edit space modal (name, icon, scheme).
- `packages/chat/scheme-picker.js` — standalone color scheme picker component.

### Modified

- `packages/chat/chat.js` — import `createSpacesGutter`; add `--gutter-width` CSS variable; add `#spaces-gutter` styles; shift `#pets`, `#messages`, `#chat-bar` right by `--gutter-width`; add `<div id="spaces-gutter"></div>` and `<div id="add-space-modal-container"></div>` to template; initialize gutter in `bodyComponent`.
- `packages/chat/index.css` — scheme picker grid and cell styles.

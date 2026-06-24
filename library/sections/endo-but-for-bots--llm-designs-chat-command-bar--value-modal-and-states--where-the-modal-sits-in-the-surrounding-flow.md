---
title: Where the modal sits in the surrounding flow
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
parent: endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states
---

The modal is reached *from* the command-bar states described in
[[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]]:

- **Token-only state, Enter** → inspect via the modal.
- **Token autocomplete visible, Enter** → complete token then inspect via the modal.
- **Click a token chip** anywhere in the inbox → inspect via the modal.
- **Click an attachment** in a message → inspect via the modal.

The modal does NOT change the underlying value identity — closing
the modal returns to whatever state the command bar was in. Saving
a value names it (creates a pet-name binding) but does not change
the value's formula identifier; pass-invariant-handle-equality
holds across the save.

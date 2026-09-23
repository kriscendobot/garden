---
title: Modal reuse via `showName`
source: designs/chat-spaces-home.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7f5671c6114a0100d8cc51064f9f68acf5a00ffb
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances
---

The `createEditSpaceModal` factory accepts an optional `showName`
boolean parameter:

| `showName` | Behavior |
|---|---|
| `true` (default) | Renders the Name field; validates name on submit |
| `false` | Omits the Name field; uses `editingSpace.name` on submit |

Two instances are created in `spaces-gutter.js`:

1. **`editSpaceModal`** — `showName: true`, for regular spaces.
2. **`homeEditModal`** — `showName: false`, for the home space.

The parameter-toggle approach (one factory, two configurations)
avoids two separate modal components with 95% shared code. The
**name is the only differentiating field** between regular-space
editing and home-space editing; everything else (icon picker,
scheme picker, OK / Cancel buttons, validation pipeline) is
identical.

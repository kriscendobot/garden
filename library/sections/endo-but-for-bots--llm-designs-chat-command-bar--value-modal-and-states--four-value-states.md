---
title: Four value states
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

The title bar of the modal renders the value's *identity surface*
in one of four shapes:

| State | Title display | Description |
|---|---|---|
| **Has ID + pet names** | `@foo @bar` (blue chips) | Value retained in store, has names |
| **Has ID + no pet names** | `(unnamed)` | Value retained but not named |
| **Has message context** | `#42:attachment` (gray chip) | Value from inbox message |
| **Ephemeral (no ID)** | `Ephemeral Value` | Transient value (e.g., from `/list`) |

> *A value can show BOTH message context chip AND pet name chips if
> applicable.*

The four-state classification is the chat-UI equivalent of the
daemon's [[pass-invariant-handle-equality]] discipline applied to
the *display* layer: the same backing identity gets the same
rendering, but the rendering varies along two axes — "has the user
named it?" and "did it arrive in a message?". Both axes can apply
to one value, and both chips render side-by-side when they do.

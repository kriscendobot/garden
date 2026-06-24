---
title: In-space message context
source: designs/chat-spaces-inbox.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-inbox--badges-message-context-and-future
---

When a user is *in* a space, the chat-bar context shifts:

| Affordance | Behavior |
|---|---|
| **Profile path** | Shown in breadcrumbs (already implemented; see [[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]]). |
| **Send target** | Defaults to the space's agent. |
| **Available commands** | Scoped to the space's capabilities. |

The send-target default is a worked example of the
[[endo-but-for-bots--llm-designs-chat-invariants--principles]]
*progressive disclosure* principle: simple operations stay simple.
A user in a space can send a message with `text + Enter` (no need
to type `@space-agent message`) because the recipient is already
implicit in the current context.

The *available-commands* scoping is the chat-bar manifestation of
the daemon's capability-confinement model: an agent only has the
commands its powers grant; the chat bar surfaces exactly those.

---
title: Error-handling pattern
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling
---

Errors surface in a consistent visual shape across modes:

| Mode | Error placement |
|---|---|
| Command mode | Red bubble above the command row |
| Send mode | Red bubble above the input field |

Both use a **speech-pointer** indicating the source of the error,
and errors **clear on next input** — the user does not need to
dismiss them; typing the next character clears the bubble.

The speech-pointer-attached-to-source pattern is the kind of small
visual discipline that compounds: a user who has read one
red-bubble-with-speech-pointer learns the convention and applies it
across every other mode the bubble appears in. This is the visual-
feedback principle from
[[endo-but-for-bots--llm-designs-chat-invariants--principles]]
working in practice.

---
title: Entering focus mode
source: designs/chat-focus-message.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8fe17b1c61bf50fae8a97f97bc2aa7385a209f11
source_date: 2026-03-04
source_authors: [Kris Kowal]
ingested: 2026-05-29
ingested_by: scholar
topics: [chat-ui]
status: current
notes: |
  Focus message mode supersedes the earlier `chat-reply-chain-visualization.md`
  (MOI / message-of-interest layout). The header of the source file names the
  supersession explicitly; this section captures the design's deliberate-mode
  framing and the entry/exit gestures that surround it.
parent: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit
---

The user enters focus mode by pressing `⌘↑` (Cmd+ArrowUp on macOS,
Ctrl+ArrowUp elsewhere) when **both** of these hold:

- The chat bar is in `send` mode.
- The input is empty.

On entry:

- Mode changes to `'focus'`.
- The input is blurred.
- The last message in the inbox is highlighted (receives `.focused`
  class).
- Reply-chain-aware indentation is computed (see the *indentation
  algorithm* section).
- A focus modeline appears showing available shortcut keys.

Clicking a message also enters focus mode (or changes the focused
message if already in focus mode), **provided the click is not
intercepted by an interactive element within the message**. The
click-to-focus path is the mouse-side parallel of the keyboard `⌘↑`
gesture; both lead to the same focused-state machine.

The `⌘↑` entry gesture uses `stopPropagation()` on the input's keydown
to prevent the global handler from treating the same event as a
navigation action. This matters because navigation `↑` and `↓` inside
focus mode are global `keydown` events (the input is blurred); the
entry gesture has to suppress the same handler that will later be
listening for navigation.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

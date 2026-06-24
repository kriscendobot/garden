---
title: Exiting focus mode
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

Pressing `Escape` exits focus mode:

- Mode returns to `'send'`.
- The `.focused` class is removed from all messages.
- The `.focus-active` class is removed from the messages container.
- The input is re-focused.

Pressing a shortcut key (the per-command single-letter keys covered
in the *navigation and shortcut keys* section) **also** exits focus
mode, by transitioning to the inline command form with the message
number pre-filled. From the user's perspective the shortcut press is
not "exit then enter a command"; it is "act on the focused message",
and the mode change is incidental to the action.

There is also an arrow-edge exit: pressing `↓` on the last message
exits focus mode and returns to the command line. This **mirrors the
entry gesture** (`⌘↑` from the command line) so the user can fluidly
move between the transcript and input. The symmetry is deliberate:
the same arrow that navigates within focus mode (down moves focus to
the next message) carries past the last message into a mode-exit.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

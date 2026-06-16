---
title: Edge-exit symmetry
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
  Both the per-message navigation gestures (arrow keys, PageUp/PageDown
  with viewport accumulation) and the per-command single-letter shortcuts
  that transition out of focus mode into the inline command form with
  `messageNumber` pre-filled. The five shortcut keys (`r`/`d`/`a`/`g`/`s`)
  are exactly the commands in `command-registry.js` that have a
  `messageNumber` field and are common enough to warrant a single-key
  dispatch.
parent: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys
---

Pressing `↓` on the **last** message exits focus mode entirely and
returns to the command line. This mirrors the entry gesture (`⌘↑` from
the command line; see the
[[endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit]]
section) so the user can fluidly move between the transcript and the
input. The same arrow that navigates within focus mode carries past the
last message into a mode-exit.

This is a small instance of the *escape consistency* UI invariant
([[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]):
every state has a path back to a safer ancestor, and the path is
discoverable from the same gestures the user already knows.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

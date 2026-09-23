---
title: Per-message navigation
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

`↑` and `↓` arrow keys move the focus highlight between messages while
in focus mode. The focused message scrolls into view if needed via
`scrollIntoView`.

`PageUp` and `PageDown` jump by roughly half a viewport, **computed by
accumulating actual rendered message heights from the current
position** rather than by a fixed number of messages. The
heights-accumulation discipline matters because messages in the
transcript vary in height (single-line acknowledgments, multi-paragraph
markdown bodies, eval-proposal envelopes with code blocks) and a fixed
`N`-message stride would feel uneven; accumulating actual heights makes
the motion proportional to visible content.

At the **edges**, the scroll container is scrolled to its limit
directly rather than via `scrollIntoView`. The reason is alignment:
`scrollIntoView` brings a target into the viewport but does not
guarantee flush alignment with the container boundary. Scrolling the
container directly ensures the first / last message in the transcript
aligns flush with the container's top / bottom edge.

These navigation handlers are global `keydown` events. This is
necessary because the input is blurred during focus mode, so the input
cannot be the event target. The global listener checks the chat bar's
mode (`'focus'`) and dispatches accordingly.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

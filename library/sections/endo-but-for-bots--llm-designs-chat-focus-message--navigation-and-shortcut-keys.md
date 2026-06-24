---
title: Navigation and shortcut keys
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
kind: index
section_count: 6
---

> Abstract: While in focus mode, `↑` and `↓` move the focus highlight
> between messages; the focused message scrolls into view if needed.
> `PageUp` and `PageDown` jump by roughly half a viewport, computed by
> **accumulating actual rendered message heights** from the current
> position (not by a fixed `N`-message stride). At the edges the scroll
> container is scrolled to its limit directly (rather than relying on
> `scrollIntoView`) to ensure the first/last message aligns flush with
> the container boundary. These are handled as global `keydown` events
> because the input is blurred. Single-letter shortcut keys enter a
> command with the focused `messageNumber` pre-filled: `r` reply, `d`
> dismiss, `a` adopt, `g` grant, `s` submit; the modeline displays them
> as `<kbd>`-decorated abbreviations plus `Esc` back. Each shortcut
> emerges from a single registry rule: the command must have a
> `messageNumber` field and must be common enough to warrant a one-key
> binding. Pressing any shortcut exits focus mode by transitioning into
> the inline command form (the mode change is incidental; the user's
> intent is "act on the focused message"). Pressing `↓` on the last
> message exits focus mode entirely and returns to the command line.

Sections:

- [Per-message navigation](endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys--per-message-navigation.md)
- [Edge-exit symmetry](endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys--edge-exit-symmetry.md)
- [Shortcut keys](endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys--shortcut-keys.md)
- [Modeline](endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys--modeline.md)
- [Extension by sibling designs](endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys--extension-by-sibling-designs.md)
- [See also](endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys--see-also.md)

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

---
title: Modeline
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

The modeline displays the shortcuts as `<kbd>`-decorated abbreviations:

```
<kbd>r</kbd> reply  <kbd>d</kbd> dismiss  <kbd>a</kbd> adopt  <kbd>g</kbd> grant  <kbd>s</kbd> submit  <kbd>Esc</kbd> back
```

The five action keys plus `Esc` form one line. Per the *modeline
completeness* UI invariant
([[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]),
the modeline must list every keyboard action available in the current
state; focus mode's modeline lists exactly the five command shortcuts
plus the back-out gesture.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

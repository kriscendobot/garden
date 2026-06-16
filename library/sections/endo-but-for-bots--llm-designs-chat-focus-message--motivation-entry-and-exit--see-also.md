---
title: See also
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

- [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — focus mode's modeline reveals shortcut keys, honoring the *modeline completeness* invariant; the entry gesture is one of the keyboard-manual parity surfaces.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] — focus is a state in the command-bar state machine; entry from `send` mode is one of the documented transitions.
- [[endo-but-for-bots--llm-designs-chat-components--inventory-and-messages]] — the inbox panel's message envelopes are the substrate focus mode highlights; the `.focused` class is applied to one envelope at a time.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority]] — the chat-message edit feature's `e` focus-mode shortcut depends on focus mode being entered first; this section establishes the entry/exit gestures the shortcut composes with.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]] — the blob-editor's `v` and `e` shortcuts extend the same focus-mode framework; this section establishes how the user gets into the mode where those shortcuts apply.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

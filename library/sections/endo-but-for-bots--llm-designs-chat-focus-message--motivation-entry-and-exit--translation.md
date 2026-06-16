---
title: Translation
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

| Design term | Library / chat-corpus term |
|---|---|
| `messageNumber` field | one of the eight typed field types in the chat command bar (see [[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]]) |
| chat bar | the command-bar component covered in the [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] section; focus mode is one of its states |
| modeline | the per-state line of `<kbd>` hints; the *modeline completeness* UI invariant covers this surface (see [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]) |
| reply chain | a primary-chain walk through `replyTo` links; visualized only after focus is entered |
| MOI / message of interest | the superseded layout from `chat-reply-chain-visualization.md`; replaced by deliberate user-initiated focus |

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

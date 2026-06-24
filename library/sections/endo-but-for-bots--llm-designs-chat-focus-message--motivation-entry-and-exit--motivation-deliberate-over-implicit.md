---
title: "Motivation: deliberate over implicit"
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

The earlier reply-chain visualization (the MOI layout, captured in the
now-superseded `chat-reply-chain-visualization.md`) tried to *automatically
infer* which message was interesting and visualize reply trees around it.
The design's first sentence frames the new mode by contrast:

> This was complex and implicit.

Focus message mode takes a different approach: it provides a deliberate,
user-initiated mode for selecting a message and dispatching commands
against it. The focused message is **never** implicitly the head of a
reply chain. It simply pre-populates the `messageNumber` field when the
user invokes a command from focus mode.

The three goals enumerated by the design:

1. Let users quickly act on messages without mouse interaction.
2. Pre-populate `messageNumber` fields for commands that need them.
3. Visualize reply-chain structure around the focused message.

Goal 3 is the visualization the MOI layout tried to do automatically;
focus mode subordinates it to the user-initiated mode rather than letting
the renderer infer it. The reply-chain visualization only happens when
the user has explicitly entered focus mode and pointed at a message.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

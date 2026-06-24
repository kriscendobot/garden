---
title: Motivation, entry, and exit
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
kind: index
section_count: 5
---

> Abstract: Focus message mode is a deliberate, user-initiated mode for
> selecting one message in the transcript and dispatching commands against
> it. It supersedes the earlier reply-chain-visualization (MOI) layout,
> which tried to *automatically infer* which message was interesting and
> visualize reply trees around it. The new mode is deliberate by design:
> the focused message is **never implicitly the head of a reply chain**;
> it simply pre-populates the `messageNumber` field when the user invokes
> a command from focus mode. Entry: `⌘↑` from an empty `send`-mode input
> (or click on a non-interactive part of a message); the input blurs, the
> last message receives `.focused`, the modeline reveals the shortcut keys.
> Exit: `Escape` returns to `send` mode and refocuses the input; pressing
> any shortcut key also exits by transitioning into the inline command
> form with the message number pre-filled. The entry gesture is
> symmetric with the exit-by-arrow gesture (`↓` on the last message
> exits focus mode and returns to the command line) so the user can
> fluidly move between transcript and input.

Sections:

- [Motivation: deliberate over implicit](endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit--motivation-deliberate-over-implicit.md)
- [Entering focus mode](endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit--entering-focus-mode.md)
- [Exiting focus mode](endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit--exiting-focus-mode.md)
- [Translation](endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit--translation.md)
- [See also](endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit--see-also.md)

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.

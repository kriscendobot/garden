---
title: Five concrete interaction patterns (one-line message; immediate command; inline-command-form fill; cancel mid-command; edit-a-value via cancel-and-restart); buffer-and-rollback handling of Web-Speech-API interim-result retraction; the dual-mechanism Escape (per-token literal `quote` prefix) + Enter (framing-pause submit cue) — why two mechanisms instead of one for the wake-word-vs-prose collision
source: designs/chat-voice-command-parser.md
source_repo: endojs/endo-but-for-bots
source_branch: design/chat-voice-command-parser
source_commit: e2134329191713132f5ecb5f1c7954a42b8ad4d4
source_date: 2026-05-10
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
notes: |
  **Status: Not Started** upstream. The interaction-and-disambiguation
  cluster of the chat-voice-command-parser design: five concrete
  user-flow patterns the parser must validate against during
  implementation; the buffer-and-rollback discipline for handling
  Web-Speech-API interim-result retractions (the chat bar's applied
  effects need inverses for `commit-token`, `enter-mode`, and
  `set-field`); the dual Escape (per-token literal `quote` prefix) +
  Enter (framing-pause submit cue with 600 ms silence on both sides
  of `submit` / `send now` / `cancel`) mechanism, with explicit
  argument for why two mechanisms are load-bearing for two different
  jobs (accidental keyword collisions in fragments vs terminal cues).
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony--abstract.md)
- [Body](endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony--common-confusions.md)

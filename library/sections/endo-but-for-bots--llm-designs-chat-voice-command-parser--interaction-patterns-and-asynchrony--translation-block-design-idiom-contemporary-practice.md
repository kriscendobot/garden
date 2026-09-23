---
title: Translation block (design idiom → contemporary practice)
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
parent: endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony
---

| Design concept | Contemporary practice |
| -------------- | --------------------- |
| Buffer-of-unconsumed-fragment + rollback-on-retract | Standard streaming-parser-with-undo discipline; the chat-bar interpreter's inverse-effect set is the rollback handle. |
| Framing-pause submit cue | The voice-assistant *terminal-cue-flanked-by-silence* pattern (Apple Dictation's "press period"; Google Assistant's "okay" disambiguation). |
| Per-token literal `quote` escape | The shell-style *quote-the-next-token* escape; minimum false-trigger; extensible to `quote begin … quote end` for multi-word literals. |
| Three submit channels unconditionally | Channel-redundancy discipline: voice never blocks button clicks or mic releases. |
| `cancel` mid-command resets without buffer | Eager-effect-application discipline; effects fire as recognized, not buffered to atomicity. |
| No invented edit gestures | Voice inherits the keyboard's affordance set; doesn't add channel-specific gestures. |

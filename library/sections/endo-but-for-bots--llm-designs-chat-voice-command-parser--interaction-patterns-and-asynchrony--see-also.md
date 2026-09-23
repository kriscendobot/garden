---
title: See also
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

- [[chat-ui]] (topic) — broader chat-UI surface.
- [[testing]] (topic) — the §Test Plan in this design's section 3 validates each pattern via unit tests and integration tests stubbing `SpeechRecognition`.
- `endo-but-for-bots--llm-designs-chat-voice-command-parser--problem-scope-mode-inventory-and-parser-shape` — the prior section in this source: parser shape + effect vocabulary + wake-word tables.
- `endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions` — the next section: design decisions + test plan + open questions.
- `endo-but-for-bots--llm-designs-chat-command-bar` — the keyboard pipeline that defines the five-pattern user-flows the voice parser must match.
- `endo-but-for-bots--llm-designs-chat-pending-commands` — the pending-commands UI that hosts voice-issued commands the same way as keyboard-issued ones.

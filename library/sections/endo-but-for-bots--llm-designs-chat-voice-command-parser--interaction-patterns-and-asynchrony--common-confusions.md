---
title: Common confusions
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

- **"Buffer-and-rollback adds complexity."** It does, but the Web Speech API's interim-result retraction makes it necessary. A non-buffered parser would emit effects on every interim result and then have to reverse them; the buffer-at-word-boundary discipline minimizes reversal scope.
- **"Three effects need inverses — that's a lot."** Three is the *minimum* set that handles retraction safely: `commit-token` (chip can be removed), `enter-mode` (mode can be reverted), `set-field` (field value can be cleared or restored). Other effects (`open-command-menu`, `pick-command`, `submit`, `cancel`, `append-text`) either have trivial inverses or are non-retractable by construction.
- **"`quote` should require closing."** The single-token form is intentional. A `quote begin … quote end` form is *available as a future extension* if the single-token form proves insufficient, but the single-token form covers the common case (escape one accidentally-wake-word token).
- **"Framing-pause submit means slow input."** Submit-via-pause is one of three channels; the on-screen Send button and mic-release (push-to-talk) are unconditional. Users who don't want to wait can use a button.
- **"Confidence thresholds should do this job."** They don't — transcription confidence measures *how confident the recognizer is of the words it transcribed*, not *what the user intended*. A high-confidence transcription of the literal word "submit" in prose still has high confidence; the framing-pause is what distinguishes intent.
- **"Voice should let the user edit mid-command."** No — the §Pattern-5 *Edit a value* explicitly defers to *cancel and restart*. Voice doesn't invent affordances the keyboard doesn't have. The keyboard user backspaces and re-enters; the voice user cancels and starts over.
- **"600 ms is arbitrary."** 600 ms is the existing `endpointing` parameter's default in `voice-input.js`. It's a *starting point* aligned with existing infrastructure; the design notes the threshold should be tunable per user (and that hint is in §Open Questions).

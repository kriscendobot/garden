---
title: Abstract
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

§Interaction Patterns enumerates **five concrete user flows** the parser must support — *one pattern per row of the wake-word table happy path*, plus the cancel-mid-command and edit-a-value patterns. (1) **Send a one-line message**: mic + `at Alice hello world` → `commit-token: alice` + `append-text: hello world`; submit via framing-pause `submit`, on-screen Send button click, or mic release if push-to-talk. (2) **Run an immediate command**: mic + `slash list` → `pick-command: list` → `submit` → Value-Modal mode. (3) **Fill an inline command form**: mic + `slash request from Alice description please send me the report` → multi-step state-progression through `slash request` (mode entry) + `from Alice` (set recipient field) + `description please send me the report` (set description field) + `submit`. (4) **Cancel mid-command**: mic + `slash list cancel` → opens command menu then immediately resets. (5) **Edit a value**: the parser does *not* invent edit gestures; the speaker says `cancel` and starts over, just like the keyboard user backspaces and re-enters. §Asynchrony and Race Conditions establishes the *buffer-and-rollback* discipline: transcripts arrive in fragments and the Web Speech API rewrites interim results, so the parser keeps an unconsumed *buffer* and only commits effects when a wake word is recognized at a *word boundary*; a subsequent fragment retracting the wake word causes the parser to *roll back the corresponding effect* (the chat bar's applied effects therefore *need inverses* for `commit-token`, `enter-mode`, and `set-field`); the `end` event from `SpeechRecognition` flushes the parser — any unconsumed buffer becomes a final `append-text` and the parser returns to the mode it was in when listening began. §Escape and Enter is the design's most substantial subsection, addressing the load-bearing question: how does the parser distinguish *the literal word "submit" in a message* from *the user's intent to submit*? Two complementary mechanisms: **Escape** — the reserved word `quote` (configurable per locale) marks the *next whitespace-delimited token* as literal; `"send the message quote slash list to Alice"` produces the text `"send the message slash list to Alice"`. **Enter** — `submit` / `send now` / `cancel` commit only when *flanked by silence on both sides*: the `SpeechRecognition` interim transcript must end on the previous fragment, a silence interval of *at least 600 ms* must elapse (tunable via the existing `endpointing` parameter), and the next fragment must begin with the wake word as its first token. *The framing pause is what distinguishes the user saying "... remember to submit the form by Friday" (no pauses) from "... remember to submit the form by Friday. [pause] submit. [pause]" (framed cue).* The §Why-two-mechanisms-instead-of-one subsection argues: a pure modal toggle imposes a context switch the keyboard doesn't require; a pure confidence-threshold approach cannot distinguish a high-confidence transcription of the literal word "submit" from a high-confidence transcription of the submit cue; *splitting the two cases — escape for accidental keyword collisions inside a fragment; framing pauses for terminal cues — keeps each mechanism load-bearing for one job*, and matches voice-assistant prior art (Google Assistant's "okay" disambiguation; Apple Dictation's "press period" model).

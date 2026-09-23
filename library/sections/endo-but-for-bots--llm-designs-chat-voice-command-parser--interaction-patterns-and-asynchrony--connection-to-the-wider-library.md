---
title: Connection to the wider library
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

This section is the **canonical worked example of *dual-mechanism wake-word disambiguation*** at the voice-UI layer. Three threads:

1. **The five-pattern user-flow validation strategy.** The §Interaction Patterns subsection is the *runtime acceptance criteria* in pattern form. Each pattern is a unit-test-able specification of *what the user did and what the parser produced*. Reusable for any input-channel design.

2. **The buffer-and-rollback discipline for interim transcripts.** Generalizes to any input pipeline whose source emits *interim results that may retract*. The chat-bar interpreter's *inverse-for-three-effects* pattern is the implementation handle.

3. **The dual-mechanism disambiguation pattern.** Escape for fragment-internal collisions + framing pauses for terminal cues. Each mechanism load-bearing for one job. Generalizes to any system where a structured-command vocabulary collides with an open prose vocabulary.

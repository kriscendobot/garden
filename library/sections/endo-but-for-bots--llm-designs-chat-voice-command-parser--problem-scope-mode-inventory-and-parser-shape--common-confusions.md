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
  **Status: Not Started** upstream. The architectural framing of the
  voice-parser design: voice should drive the *same* nine modes the
  keyboard already drives, via an asynchronous parse-monad state
  machine producing inert passable effects that the chat-bar
  interprets. Per-mode wake-word tables live next to the command
  registry so a new command picks up voice support automatically; the
  modeline shows the wake words for the current mode under the
  keyboard hints.
parent: endo-but-for-bots--llm-designs-chat-voice-command-parser--problem-scope-mode-inventory-and-parser-shape
---

- **"The parser should hook into key events directly."** No — the keyboard pipeline already does that. The voice parser produces effects that *match* what the keyboard pipeline produces; the two channels share a downstream interpreter. The factoring is *channel-specific normalizer + shared interpreter*.
- **"Effects should be callable functions."** They are *inert passable descriptions*. The parser stays pure; the interpreter does the DOM work. This makes the parser unit-testable without DOM scaffolding and matches the Hardened JavaScript convention.
- **"Wake-word tables should be a global grammar."** Per-mode tables match the modeline's shape (one set of hints per mode) and let new commands add their own wake words via registry entries. A global grammar would centralize the vocabulary but obscure *which words are significant when*.
- **"The parser must understand natural language."** It must understand the *wake-word vocabulary* in each mode. Outside the wake words, fragments are dispatched as `append-text`. The parser does *not* attempt to understand prose; it routes prose-without-wake-words to dictation.
- **"Voice should support always-on listening."** Out of scope. The button click remains the only trigger. Always-on listening raises privacy + battery + false-trigger concerns that warrant their own design.
- **"The async monad is over-engineered for this."** The two async-pressure points (interim transcript extension + pet-name autocomplete lookup) require an async-step shape. A pure-sync parser would race the interim transcripts or block on the lookup. The async monad keeps both correct.

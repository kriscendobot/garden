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

This section is the **canonical worked example of *voice-as-keyboard's-structural-peer* at the chat-UI layer**. Three threads:

1. **The async-parse-monad shape with inert passable effects.** Generalizes to any input pipeline that needs to interpret an async stream of fragments into a structured effect vocabulary. The library can cite this section whenever a design needs the *pure-parser-with-interpreter-side-effects* factoring.

2. **The registry-co-located-vocabulary discipline.** Wake words live next to command-registry entries. A new command's voice support is automatic. Generalizes to any system where *vocabulary should grow with the data, not the parser code*.

3. **The voice-hints-alongside-keyboard-hints modeline pattern.** The modeline as a *discoverability surface* for both input channels. Generalizes to any UI that supports multiple input channels and needs to surface the affordances of each.

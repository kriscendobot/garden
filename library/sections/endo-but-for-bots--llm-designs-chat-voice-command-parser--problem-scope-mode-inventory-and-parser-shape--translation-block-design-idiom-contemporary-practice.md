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

| Design concept | Contemporary practice |
| -------------- | --------------------- |
| Voice as keyboard's structural peer | The general pattern: alternate input channels normalize to the same effect vocabulary. |
| Asynchronous parse monad with state + buffer | Standard async streaming parser; the buffer-of-unconsumed-input pattern. |
| Inert passable effects + interpreter side effects | The standard Hardened JavaScript pattern: pure parser, side-effecting interpreter. |
| Per-mode wake-word tables next to command-registry | Vocabulary-as-data, not code. New commands get voice for free. |
| Modeline voice line | A *spoken-affordance-discoverability* surface — show the speaker what to say. |
| `voiceHints(mode, state)` sibling to keyboard hints | Parallel-channel hint functions; the modeline renderer composes both. |

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

§What is the Problem Being Solved establishes the thesis: the chat bar accepts speech-to-text via the Web Speech API (`packages/chat/voice-input.js`, PR #101), but the transcription arrives as a flat string that lands in the contenteditable input *exactly as if the user had typed those characters*. This works for Send mode but degrades the rest of the command bar — *a transcribed `slash list` does not open the command menu the way a typed `/` does, and a transcribed pet name does not become a chip the way the autocomplete pipeline produces*. **The voice channel needs to drive the same modes the keyboard already drives. The parser is what turns a transcript into the same effects a keystroke sequence would.** §Scope enumerates what's in (parser state machine + per-mode wake-word vocabulary sourced from `command-registry.js` + modeline integration + handoff between `voice-input.js` and the parser) and what's out (wake-word always-on listening — the button click remains the only trigger; text-to-speech output; languages other than the BCP-47 code already passed). §Existing Mode Inventory lists nine modes the parser must drive (Empty/Send, Token Autocomplete Visible, Token Only, Token + Message Text, Text Only, Command Selecting, Inline Command Form per-command, Eval Command Inline, Value Modal) — *one-for-one with chat-command-bar*, with state 7 (Inline-Command-Form) fanning out per command's field list. §Parser Shape introduces the *asynchronous parse-monad* — *the keyboard pipeline can assume each keystroke completes before the next arrives; the voice pipeline cannot: a `result` event carries an interim transcript that may extend on the next event, and a pet-name autocomplete lookup is itself async*. The minimal interface: `ParseState` (mode + per-mode fields + unconsumed buffer) + `ParseStep` (next state + effects) + `ParseFn: (state, fragment) → Promise<ParseStep>`. The eight effects (`enter-mode`, `commit-token`, `set-field`, `open-command-menu`, `pick-command`, `submit`, `cancel`, `append-text`) are *inert passable descriptions* — the parser is pure functional modulo the async lookups it performs against the host. Wake-word tables are *per-mode*; the Send-mode table is `at <pet-name>` / `slash` / `slash <command>` / `submit` (framed) / `cancel` (framed) / `quote <word>` (literal) / anything-else `append-text`. **The wake-word tables are the load-bearing piece of the design; they live next to the command registry so a new command picks up voice support automatically when its registry entry is added.** §Modeline Integration renders a second line under the keyboard hints when the voice button is listening: `Voice · "at NAME" · "slash" · "slash COMMAND" · "send" · "cancel"`.

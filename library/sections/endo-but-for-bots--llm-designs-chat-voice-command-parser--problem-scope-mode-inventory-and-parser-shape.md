---
title: The voice-channel-must-drive-keyboard-modes thesis; in-scope vs out-of-scope enumeration; the nine-mode existing inventory (one-for-one with chat-command-bar); the async-parse-monad shape (state + buffer + ParseFn returning effects); the eight-effect inert-passable vocabulary; the per-mode wake-word table sitting next to command-registry.js for new-command voice-support-by-default; the modeline integration showing voice hints alongside keyboard hints
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
---

## Abstract

§What is the Problem Being Solved establishes the thesis: the chat bar accepts speech-to-text via the Web Speech API (`packages/chat/voice-input.js`, PR #101), but the transcription arrives as a flat string that lands in the contenteditable input *exactly as if the user had typed those characters*. This works for Send mode but degrades the rest of the command bar — *a transcribed `slash list` does not open the command menu the way a typed `/` does, and a transcribed pet name does not become a chip the way the autocomplete pipeline produces*. **The voice channel needs to drive the same modes the keyboard already drives. The parser is what turns a transcript into the same effects a keystroke sequence would.** §Scope enumerates what's in (parser state machine + per-mode wake-word vocabulary sourced from `command-registry.js` + modeline integration + handoff between `voice-input.js` and the parser) and what's out (wake-word always-on listening — the button click remains the only trigger; text-to-speech output; languages other than the BCP-47 code already passed). §Existing Mode Inventory lists nine modes the parser must drive (Empty/Send, Token Autocomplete Visible, Token Only, Token + Message Text, Text Only, Command Selecting, Inline Command Form per-command, Eval Command Inline, Value Modal) — *one-for-one with chat-command-bar*, with state 7 (Inline-Command-Form) fanning out per command's field list. §Parser Shape introduces the *asynchronous parse-monad* — *the keyboard pipeline can assume each keystroke completes before the next arrives; the voice pipeline cannot: a `result` event carries an interim transcript that may extend on the next event, and a pet-name autocomplete lookup is itself async*. The minimal interface: `ParseState` (mode + per-mode fields + unconsumed buffer) + `ParseStep` (next state + effects) + `ParseFn: (state, fragment) → Promise<ParseStep>`. The eight effects (`enter-mode`, `commit-token`, `set-field`, `open-command-menu`, `pick-command`, `submit`, `cancel`, `append-text`) are *inert passable descriptions* — the parser is pure functional modulo the async lookups it performs against the host. Wake-word tables are *per-mode*; the Send-mode table is `at <pet-name>` / `slash` / `slash <command>` / `submit` (framed) / `cancel` (framed) / `quote <word>` (literal) / anything-else `append-text`. **The wake-word tables are the load-bearing piece of the design; they live next to the command registry so a new command picks up voice support automatically when its registry entry is added.** §Modeline Integration renders a second line under the keyboard hints when the voice button is listening: `Voice · "at NAME" · "slash" · "slash COMMAND" · "send" · "cancel"`.

## Body

### §What is the Problem Being Solved — voice as keyboard's structural peer

The §What is the Problem Being Solved subsection diagnoses the degradation:

> The chat bar accepts speech-to-text via the Web Speech API (see PR #101 and the implementation at `packages/chat/voice-input.js`). The transcription currently arrives as a flat string that lands in the contenteditable input, exactly as if the user had typed those characters. That works for the Send mode but degrades the rest of the command bar: a transcribed `slash list` does not open the command menu the way a typed `/` does, and a transcribed pet name does not become a chip the way the autocomplete pipeline produces.

The two diagnostic-failures:

1. **Mode entry by punctuation breaks**. The keyboard's `/` keypress opens the command menu by virtue of *which key is pressed*. The speech-to-text stream produces the *string* `slash` (or `/`), but the contenteditable input doesn't recognize this as a mode-entry signal.
2. **Autocomplete chip insertion breaks**. The keyboard's `@`-completion pipeline runs the autocomplete dropdown as the user types pet name characters. The voice stream produces the *string* of pet name characters, but the autocomplete pipeline (which keys on key events, not on text changes) doesn't fire.

The structural fix:

> The voice channel needs to drive the same modes the keyboard already drives. The parser is what turns a transcript into the same effects a keystroke sequence would.

The thesis is *voice as keyboard's structural peer*. Both channels produce sequences of intent-bearing tokens; the parser is the *normalizer* that maps each channel's encoding (keystrokes vs transcripts) into a common effect vocabulary.

### §Scope — in vs out

The §Scope subsection enumerates explicitly:

**In scope**:
- The parse-monad state machine.
- The per-mode wake-word vocabulary sourced from `command-registry.js`.
- Modeline advertising of wake words.
- The handoff between `voice-input.js` (microphone-button DOM + SpeechRecognition session) and the parser (command-bar dispatch).

**Out of scope**:
- Wake-word always-on listening. *The button click remains the only trigger.*
- Text-to-speech output.
- Languages other than the BCP-47 code already passed to `makeVoiceInput`.

The *button click remains the only trigger* discipline is a deliberate scope-narrowing: always-on wake-word listening is a substantial separate design (microphone-always-on raises privacy + battery + false-trigger concerns) that this design defers. The current trigger is *user-explicit*; the parser fires only after the user has clicked the mic button.

### §Existing Mode Inventory — nine modes, one-for-one with the keyboard

The §Existing Mode Inventory subsection lists the modes the parser must drive:

1. **Empty (Send Mode)** — the default mode when the input is empty.
2. **Token Autocomplete Visible** — typed `@` is active; the autocomplete dropdown is showing pet-name completions.
3. **Token Only (Chip Present, No Message)** — a single pet-name chip in the input, no message text yet.
4. **Token + Message Text** — chip plus accompanying text.
5. **Text Only (No Token)** — message text without any token chips.
6. **Command Selecting (After `/`)** — the command menu is open showing slash-command completions.
7. **Inline Command Form** — a specific command's inline form is open; *one sub-state per command in `command-registry.js`*.
8. **Eval Command (Inline)** — the `/eval` command's specialized inline editor.
9. **Value Modal** — a modal showing the result of a command.

State 7 fans out per command:

> The parser treats each command's field list as a sub-state machine whose alphabet is the field labels and the field type's domain (`petNamePath`, `messageNumber`, `text`, etc.).

The *fan-out per command* discipline is the *registry-driven-vocabulary* pattern: the parser's nine top-level modes plus the per-command sub-states are *exhaustive of the keyboard's UX surface*. Voice cannot drive a mode the keyboard cannot.

### §Parser Shape — async monad with state + buffer + effects

The §Parser Shape subsection's *Why an asynchronous monad* sub-subsection names the structural reason:

> The keyboard pipeline can assume each keystroke completes before the next arrives. The voice pipeline cannot: a `result` event carries an interim transcript that may extend on the next event, and a pet-name autocomplete lookup is itself async (resolves the name path against the host registry). The parser therefore composes async steps and tracks partial state across them.

Two async-pressure points:

1. **Interim transcript extension**. The Web Speech API's `result` events carry interim transcripts that the next event may *extend* (or *retract*). The parser cannot commit to *consume this fragment* until the fragment is finalized at a word boundary.
2. **Pet-name autocomplete lookup**. Resolving an `at <pet-name>` wake word to a chip requires looking up `<pet-name>` against the host registry; this is async.

The parser's minimal interface (paraphrased from the design's JSDoc):

```js
/**
 * @typedef {object} ParseState
 * @property {Mode} mode
 * @property {object} fields - per-mode accumulators
 * @property {string} buffer - transcript fragment not yet consumed
 */

/**
 * @typedef {object} ParseStep
 * @property {ParseState} next
 * @property {Effect[]} effects
 */

/**
 * @typedef {(state: ParseState, fragment: string) => Promise<ParseStep>} ParseFn
 */
```

**Structural read**:

- **`ParseState`** carries three things: the current mode, the per-mode accumulator (e.g. the field-being-filled in Inline-Command-Form mode), and an unconsumed transcript buffer.
- **`ParseStep`** returns the next state + a list of effects.
- **`ParseFn`** is one mode's parser; the set of `ParseFn`s keyed by mode is the *state machine* shape.

The *dispatch loop* (described in prose):

> A `dispatch(transcript)` call selects the `ParseFn` for the current mode, awaits its `ParseStep`, applies the effects to the DOM, and stores `next` for the following fragment.

#### §Effects — inert passable descriptions

The §Effects sub-subsection defines the eight-effect vocabulary:

| Effect | Meaning |
|--------|---------|
| `enter-mode` | Switch the command bar to a named mode |
| `commit-token` | Insert a token chip at the cursor |
| `set-field` | Write a value into a named field of the current command |
| `open-command-menu` | Show the command selector |
| `pick-command` | Choose a command by name |
| `submit` | Submit the current form |
| `cancel` | Escape out of the current mode |
| `append-text` | Insert literal text at the cursor |

The structural discipline:

> Effects are inert descriptions of what the parser wants done. The chat bar interprets them. ... Effects are passable values; the parser is pure functional modulo the async lookups it performs against the host.

The *inert-passable-effects-with-pure-parser-and-interpreter-side-effects* shape is the standard *Hardened JavaScript* convention for keeping effect descriptions Passable. The parser doesn't *do* DOM mutation; it *describes* DOM mutation, and a chat-bar interpreter does the actual mutation. This factoring lets the parser be *purely unit-testable* (given a state + fragment, assert the next state + effect list) without DOM scaffolding.

#### §Wake words per mode — registry-driven vocabulary

The §Wake words per mode sub-subsection establishes the *per-mode-table-living-next-to-command-registry* discipline. The Send-mode table:

| Spoken | Effect |
|--------|--------|
| `at <pet-name>` | `commit-token` for `<pet-name>` |
| `slash` | `enter-mode: command-selecting` |
| `slash <command>` | `pick-command: <command>` |
| `submit` (framed pause) | `submit` |
| `cancel` (framed pause) | `cancel` |
| `quote <word>` | `append-text: <word>` (literal escape) |
| anything else | `append-text` for the fragment |

The Command-Selecting table consumes the rest of the transcript as a command-name fuzzy match against the registry. The Inline-Command-Form tables are *generated from each command's field list*:

> Each field name becomes a wake word that selects it, and the rest of the transcript flows into the field's value.

The §Parser Shape's load-bearing observation:

> The wake-word tables are the load-bearing piece of the design. They live next to the command registry so a new command picks up voice support automatically when its registry entry is added.

The *registry-co-located-vocabulary* discipline is the *vocabulary-comes-from-the-data-not-the-code* pattern. A new slash command added to `command-registry.js` gains voice support *automatically* — no parser changes needed. The vocabulary is data, not code.

### §Modeline Integration — voice line under keyboard hints

The §Modeline Integration subsection adds a second modeline line when voice is listening:

```
Send · @ inspect or message · / commands · Space continue with @last
Voice · "at NAME" · "slash" · "slash COMMAND" · "send" · "cancel"
```

The design notes:

> The modeline already shows mode-specific keyboard hints. The parser exposes a sibling `voiceHints(mode, state)` function that returns the wake words the current mode honors. The chat-bar's modeline component renders both lines when the voice button is in the listening state.

The *sibling-voiceHints-function* discipline mirrors the existing *keyboardHints-function* shape: the parser exposes the wake-word table for the current mode, and the modeline renderer composes the two hint lines. *Outside listening state the voice line is hidden so the modeline stays compact.*

The *hint-the-speaker-what-to-say-next* discipline is the *spoken-affordance-must-be-discoverable* pattern. Without a visual hint, the speaker cannot guess what wake words are available; the modeline closes that gap.

## Connection to the wider library

This section is the **canonical worked example of *voice-as-keyboard's-structural-peer* at the chat-UI layer**. Three threads:

1. **The async-parse-monad shape with inert passable effects.** Generalizes to any input pipeline that needs to interpret an async stream of fragments into a structured effect vocabulary. The library can cite this section whenever a design needs the *pure-parser-with-interpreter-side-effects* factoring.

2. **The registry-co-located-vocabulary discipline.** Wake words live next to command-registry entries. A new command's voice support is automatic. Generalizes to any system where *vocabulary should grow with the data, not the parser code*.

3. **The voice-hints-alongside-keyboard-hints modeline pattern.** The modeline as a *discoverability surface* for both input channels. Generalizes to any UI that supports multiple input channels and needs to surface the affordances of each.

## Translation block (design idiom → contemporary practice)

| Design concept | Contemporary practice |
| -------------- | --------------------- |
| Voice as keyboard's structural peer | The general pattern: alternate input channels normalize to the same effect vocabulary. |
| Asynchronous parse monad with state + buffer | Standard async streaming parser; the buffer-of-unconsumed-input pattern. |
| Inert passable effects + interpreter side effects | The standard Hardened JavaScript pattern: pure parser, side-effecting interpreter. |
| Per-mode wake-word tables next to command-registry | Vocabulary-as-data, not code. New commands get voice for free. |
| Modeline voice line | A *spoken-affordance-discoverability* surface — show the speaker what to say. |
| `voiceHints(mode, state)` sibling to keyboard hints | Parallel-channel hint functions; the modeline renderer composes both. |

## See also

- [[chat-ui]] (topic) — the broader chat-UI surface.
- `endo-but-for-bots--llm-designs-chat-command-bar` — the keyboard pipeline this parser mirrors; the nine modes are documented there.
- `endo-but-for-bots--llm-designs-chat-pending-commands` — voice-issued commands queue through the same pending-command UI as keyboard-issued ones.
- `endo-but-for-bots--llm-designs-chat-slot-slash-commands` — the slot-input consolidation that voice extends through the same registry pathway.
- `endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony` — the next section in this source: the five concrete interaction patterns + race-condition handling + the Escape/Enter dual-mechanism.
- `endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions` — the third section: design decisions + test plan + open questions + §Prompt.
- `endo-but-for-bots--llm-designs-chat-edit-message-ui--*` — the chat-edit affordances that voice should also drive; the same registry-driven vocabulary discipline.

## Common confusions

- **"The parser should hook into key events directly."** No — the keyboard pipeline already does that. The voice parser produces effects that *match* what the keyboard pipeline produces; the two channels share a downstream interpreter. The factoring is *channel-specific normalizer + shared interpreter*.
- **"Effects should be callable functions."** They are *inert passable descriptions*. The parser stays pure; the interpreter does the DOM work. This makes the parser unit-testable without DOM scaffolding and matches the Hardened JavaScript convention.
- **"Wake-word tables should be a global grammar."** Per-mode tables match the modeline's shape (one set of hints per mode) and let new commands add their own wake words via registry entries. A global grammar would centralize the vocabulary but obscure *which words are significant when*.
- **"The parser must understand natural language."** It must understand the *wake-word vocabulary* in each mode. Outside the wake words, fragments are dispatched as `append-text`. The parser does *not* attempt to understand prose; it routes prose-without-wake-words to dictation.
- **"Voice should support always-on listening."** Out of scope. The button click remains the only trigger. Always-on listening raises privacy + battery + false-trigger concerns that warrant their own design.
- **"The async monad is over-engineered for this."** The two async-pressure points (interim transcript extension + pet-name autocomplete lookup) require an async-step shape. A pure-sync parser would race the interim transcripts or block on the lookup. The async monad keeps both correct.

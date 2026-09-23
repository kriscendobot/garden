---
title: Body
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

### §Interaction Patterns — five concrete user flows

The §Interaction Patterns subsection makes the parser concrete through *one validating pattern per user intent*:

#### Pattern 1: Send a one-line message

```
1. User clicks mic, says "at Alice hello world"
2. Parser dispatches `at` → `commit-token: alice` (pet-name lookup happens here)
3. Parser dispatches `hello world` → `append-text: hello world`, then waits
4. User pauses, says "submit" with the framing pause described in "Escape and Enter";
   parser dispatches `submit`. Or the user clicks the on-screen Send button.
   Or the user releases the mic button if push-to-talk is in use.
```

Three submit channels are available unconditionally: framing-pause `submit`, Send-button click, mic-button release (push-to-talk). The parser does not force a single submit channel.

#### Pattern 2: Run an immediate command

```
1. User clicks mic, says "slash list"
2. Parser dispatches `slash list` → `pick-command: list` → `submit`
3. Result modal opens, parser idles in Value-Modal mode
```

The two-effect chain `pick-command` → `submit` is automatic for *list-like immediate commands*. The parser doesn't wait for a separate submit; the command-registry entry signals the command is immediate.

#### Pattern 3: Fill an inline command form

```
1. User clicks mic, says "slash request from Alice description please send me the report"
2. Parser dispatches `slash request` → `pick-command: request`
3. Parser is now in Inline-Command-Form mode for `request`
4. Parser dispatches `from Alice` → `set-field: recipient = alice`
5. Parser dispatches `description please send me the report` → `set-field: description = please send me the report`
6. User says "submit" → `submit`
```

The structural pattern: **field-name as wake word**. The `from` and `description` are field labels in the `request` command's registry entry; the parser uses them as wake words that *select the field*, and the following content flows into the field's value until the next field-name wake word.

The *field-name-as-wake-word* discipline is the *registry-vocabulary-becomes-language* manifestation. The parser doesn't hardcode `from` / `description`; it reads them from the registry.

#### Pattern 4: Cancel mid-command

```
1. User says "slash list cancel"
2. Parser opens command menu, immediately `cancel` resets
```

The parser does not buffer-and-resolve all effects atomically; effects are applied as wake words are recognized. The cancel-mid-stream sequence is *open-menu then close-menu in the same dispatch*.

#### Pattern 5: Edit a value

```
The modeline tells the speaker which field is currently focused.
The parser does not invent edit gestures; the speaker has to say `cancel`
and start over, just like the keyboard user backspaces and re-enters.
```

The *no-invented-edit-gestures* discipline: voice should not introduce affordances the keyboard does not have. Editing a value is *cancel-and-restart* in both channels; the parser inherits this.

### §Asynchrony and Race Conditions — buffer + rollback

The §Asynchrony and Race Conditions subsection establishes the *buffer-and-rollback* discipline:

> Transcripts arrive in fragments; later fragments may extend earlier ones (the Web Speech API rewrites interim results). The parser keeps a `buffer` of the unconsumed portion and only commits effects when a wake word is recognised at a word boundary. A subsequent fragment that retracts the wake word causes the parser to roll back the corresponding effect (the chat bar's applied effects therefore need an inverse for `commit-token`, `enter-mode`, and `set-field`).

The structural picture:

- **Web Speech API interim results extend or retract**. A `result` event might carry the interim text `"at"`; the next event might carry `"at all"`, *retracting* the `"at"` standalone interpretation.
- **The parser buffers unconsumed fragments**. The `buffer` field of `ParseState` carries the portion of transcript not yet matched to a wake word.
- **Effects commit at word boundaries**. The parser commits a `commit-token` only when the wake word `at <pet-name>` is *complete and word-bounded*.
- **Retraction triggers rollback**. If the next fragment retracts the wake word, the chat-bar interpreter applies the *inverse* of the previously-applied effect.
- **Three effects need inverses**: `commit-token` (remove chip), `enter-mode` (return to previous mode), `set-field` (clear or restore-prior-value).

The other effects (`open-command-menu`, `pick-command`, `submit`, `cancel`, `append-text`) either: (a) cannot be retracted because they have no inverse (`submit`), (b) are followed-by-other-effects that override them (`pick-command` is followed by `set-field`s), or (c) have trivial inverses already supported by the chat bar (`append-text` is reversed by removing the appended text, which the contenteditable input already supports for incremental updates).

The §Asynchrony subsection closes with the *flush-on-end* discipline:

> The `end` event from `SpeechRecognition` flushes the parser: any unconsumed buffer becomes a final `append-text` into the input, and the parser returns to the mode it was in when listening began.

The *flush-on-end* discipline ensures *no transcript content is lost*: any partial fragment that hadn't yet matched a wake word becomes literal text. The mode reset prevents the parser from leaving the chat bar in a partially-entered state when the mic session ends.

### §Escape and Enter — the wake-word-vs-prose collision

The §Escape and Enter subsection is the design's deepest piece. The structural problem:

> The wake-word vocabulary collides with the open vocabulary of prose the speaker may want to put into a message or a text field. The user must be able to say the literal words "submit", "slash list", or "at" without triggering the parser; conversely, the parser must recognise the user's intent to submit the form without waiting for the mic button to be released.

The design picks **two complementary mechanisms**.

#### Escape: a literal-quote prefix

> The reserved word `quote` (configurable per locale) marks the following word as literal. A speaker who says "send the message quote slash list to Alice" produces the text "send the message slash list to Alice", with no command-mode entry. The parser consumes `quote` and emits `append-text` for the next whitespace-delimited token, then resumes ordinary parsing on the fragment that follows.

The structural reading:

- **`quote` is a *per-token* escape**: it scopes to the next whitespace-delimited token only.
- **The parser consumes `quote` itself silently** (no `append-text` for `quote`).
- **The following token is emitted as `append-text`** regardless of whether it would otherwise be a wake word.
- **Parsing resumes** on the fragment after that token.

The §Escape sub-subsection enumerates *why `quote`*:

> - It is unlikely to appear by accident in chat prose (compared to `say`, which is conversational, or `literally`, which is conversational filler).
> - It is one syllable and unambiguous when transcribed.
> - It generalises: a future `quote begin ... quote end` pair can cover multi-word literals if the single-token form proves insufficient.

The choice is *minimum-false-trigger* + *unambiguous-transcription* + *extensibility*.

The §Escape sub-subsection notes the escape applies *inside fields too*:

> The Inline-Command-Form mode applies the same escape inside a field's value, so a `request` command's `description` field can contain the words `from` or `description` literally.

#### Enter: a framing-pause submit cue

> The parser commits a `submit` effect when it observes the wake word `submit` (or the synonym `send now`) flanked by silence on both sides. "Flanked" means the `SpeechRecognition` interim transcript ended on the previous fragment, a silence interval of at least 600 ms elapsed (a tunable; the existing `voice-input.js` already exposes a silence threshold via the `endpointing` parameter), and the next fragment begins with the wake word as its first token. The same pause is required after the wake word before any following content is accepted as the next utterance.

The structural reading:

- **`submit` / `send now` are framed cues**: they fire only when *flanked* by silence on both sides.
- **The silence threshold is tunable**: 600 ms is the initial value, drawn from the existing `endpointing` parameter.
- **The framing is what distinguishes intent**: the same word "submit" can appear in prose (*"remember to submit the form by Friday"*) without firing, because the prose context provides no silence-framing.

The structural example:

> The framing pause is what distinguishes the user saying "... remember to submit the form by Friday" (no pauses) from "... remember to submit the form by Friday. [pause] submit. [pause]" (framed cue).

The §Enter sub-subsection lists the two non-pause submit channels (unconditional):

- **On-screen Send button click**: voice never blocks a click.
- **Mic button release** (if push-to-talk is enabled): release flushes the buffer to `append-text` and emits `submit`.

#### Cancel and other framed cues

> The same framing-pause rule covers `cancel`, since a speaker may also want to say the word "cancel" inside a message ("please cancel my reservation"). The full set of framed cues is `submit`, `send now`, and `cancel`; the `quote` escape itself does not require framing because its semantic is local to the next token.

Three framed cues; the others (mode entry, field-name selection, pet-name commit, `quote` escape) are *not* framed.

#### Why two mechanisms instead of one

The §Why-two-mechanisms subsection argues for the dual approach:

> A single mechanism leaves a usability hole. A pure modal toggle (a separate "command mode" the user enters explicitly) imposes a context switch on the speaker for every command and conflicts with the design's premise that voice should drive the same flow as the keyboard. A pure confidence-threshold approach (drop low-confidence command matches into dictation) cannot distinguish a high-confidence transcription of the literal word "submit" from a high-confidence transcription of the submit cue.
>
> Splitting the two cases (escape for accidental keyword collisions inside a fragment; framing pauses for terminal cues) keeps each mechanism load-bearing for one job, and matches what voice-assistant prior art (Google Assistant's "okay" disambiguation, Apple Dictation's "press period" model) already trains the speaker to expect.

The argument's structure:

- **Modal toggle** = single-mechanism for both jobs; fails because it imposes context switches.
- **Confidence threshold** = single-mechanism for both jobs; fails because transcription confidence does not encode user-intent.
- **Dual mechanism (quote + framing pauses)** = one mechanism per job; each load-bearing; matches prior-art training of speakers.

The voice-assistant-prior-art reference is the *trains-the-speaker-to-expect* argument: Google Assistant's "okay" disambiguation and Apple Dictation's "press period" model use similar dual-mechanism shapes. Users come to voice with this expectation; the design leverages it.

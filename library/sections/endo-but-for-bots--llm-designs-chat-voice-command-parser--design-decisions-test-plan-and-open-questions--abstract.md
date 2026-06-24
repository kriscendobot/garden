---
title: Abstract
source: designs/chat-voice-command-parser.md
source_repo: endojs/endo-but-for-bots
source_branch: design/chat-voice-command-parser
source_commit: e2134329191713132f5ecb5f1c7954a42b8ad4d4
source_date: 2026-05-10
source_authors: [Kris Kowal]
topics: [chat-ui, testing]
status: current
notes: |
  **Status: Not Started** upstream. The decisions-and-validation cluster
  of the chat-voice-command-parser design. Five load-bearing decisions
  with explicit rationale for each. Test plan with pure unit tests
  (state + fragment → next state + effects) plus stub-SpeechRecognition
  integration tests. Four-phase implementation strategy gated behind a
  feature flag (parser scaffold + effect dispatcher + modeline voice
  line + voice-input.js migration). Seven open questions the
  maintainer's reading owes the design (canonical command-menu wake
  word; inline vs deferred pet-name lookup; modeline aural cue; shared
  state across mic sessions; alternative literal-escape wake word;
  framing-pause threshold; non-voice long-press submit gesture).
parent: endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions
---

§Test Plan establishes the parser's *pure-unit-test-able* property: *feed a state and a transcript fragment, assert the next state and effect list*. Coverage targets enumerated: each wake-word table's happy path (one pattern per row); buffer extension across fragments (retraction of an interim word); mode entry from each predecessor mode (Send → Command-Selecting → Inline-Command-Form → Send on submit); cancel from each mode; pet-name lookup failure (an `at` whose name does not resolve emits `append-text` rather than `commit-token`); `quote <token>` escape suppresses wake-word interpretation in Send mode and inside Inline-Command-Form field values; `submit` / `send now` / `cancel` only fire when flanked by the configured silence threshold (an embedded "submit" inside a fragment without framing pauses is treated as `append-text`). Integration tests live under `packages/chat/test/component/` and exercise a *stub SpeechRecognition* whose interim/final results drive the parser end-to-end. §Dependencies enumerates three sibling designs: `chat-command-bar` is the source-of-truth for the modes the parser drives; `chat-pending-commands` queues voice-issued commands through the same pending-command UI; `chat-slot-slash-commands` extends the parser's wake-word table by the same registry pathway. §Phased Implementation lays out a four-phase strategy *behind a feature flag*: (1) Parser scaffold (pure `ParseFn` per mode with tests, no chat-bar wiring); (2) Effect dispatcher (chat-bar interpreter for the effect list with rollback); (3) Modeline voice line; (4) Migrate `voice-input.js` to call `parser.dispatch(transcript)` instead of writing `textContent` directly. §Design Decisions makes five choices explicit: (1) **Per-mode wake-word tables, not a global grammar** — *a grammar would centralise the vocabulary but obscure which words are significant when*; (2) **Effects are passable values, not function calls** — *the parser stays pure and testable; the chat bar owns the side effects*; (3) **Rollback on retraction, not on every interim** — *re-applying every interim would flicker the UI*; (4) **Framed-pause submit, not always-on submit wake word** — *a speaker who pauses naturally between sentences should not accidentally submit*; (5) **Per-token literal-quote escape** — *chosen over a modal command-mode toggle because the modal approach forces a context switch the keyboard pipeline does not require*. §Open Questions surfaces seven items the maintainer's reading owes the design.

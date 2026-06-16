---
title: Body
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

### §Test Plan — pure parser tests + stub-SpeechRecognition integration tests

The §Test Plan subsection opens with the *unit-test-pure* property:

> The parser's unit tests are pure: feed a state and a transcript fragment, assert the next state and effect list.

This is the unit-test direct consequence of the §Design-Decision-2 inert-passable-effects discipline (from this section's enumeration below). With effects as data, unit tests need no DOM scaffolding — they assert on returned effect-arrays.

The coverage targets enumerated:

- **Each wake-word table's happy path** — one pattern per row, all nine modes' tables.
- **Buffer extension across fragments** — retraction of an interim word; the §Asynchrony rollback-pathway exercise.
- **Mode entry from each predecessor mode** — Send → Command-Selecting → Inline-Command-Form → Send on submit; the full state-machine traversal.
- **Cancel from each mode** — `cancel` must work uniformly across all nine modes.
- **Pet-name lookup failure** — `at <unresolvable-name>` emits `append-text` rather than `commit-token`. This is the *fallback-to-dictation-when-lookup-fails* discipline.
- **`quote <token>` escape suppresses wake-word interpretation** — in Send mode and inside Inline-Command-Form field values. The escape's *applies-everywhere* property.
- **Framed-pause submit / send-now / cancel only fire when flanked** — an embedded "submit" inside a fragment without framing pauses is treated as `append-text`.

Integration tests live alongside the existing chat tests:

> Integration tests live alongside the existing chat tests under `packages/chat/test/component/` and exercise a stub `SpeechRecognition` whose interim/final results drive the parser end-to-end.

The *stub-SpeechRecognition* pattern is the standard chat-test infrastructure: integration tests don't need real microphones; they drive the parser through scripted interim/final transcript events.

### §Dependencies — three sibling designs

The §Dependencies table:

| Design | Relationship |
|---|---|
| `chat-command-bar` | Source of truth for the modes the parser drives. |
| `chat-pending-commands` | Voice-issued commands queue through the same pending-command UI as keyboard-issued ones. |
| `chat-slot-slash-commands` | Slot-based slash commands extend the parser's wake-word table by the same registry pathway. |

Three structural relationships:

1. **`chat-command-bar` defines the modes**. The parser's nine-mode inventory is sourced from this design; any new mode added there must be added to the parser's state machine.
2. **`chat-pending-commands` is downstream**. Voice-issued commands get the same pending-region treatment as keyboard-issued ones; voice doesn't bypass the pending-command pipeline.
3. **`chat-slot-slash-commands` extends the vocabulary**. New slot-based slash commands (e.g. `/js`, `/json`, `/locator`) register through `command-registry.js` and *automatically gain voice support* via the wake-word-tables-next-to-registry discipline.

### §Phased Implementation — four phases behind a feature flag

The §Phased Implementation subsection lists four phases:

1. **Parser scaffold**: pure `ParseFn` per mode with tests, no chat-bar wiring. *Lands behind a feature flag* so the existing voice button continues to use the flat-text path until the parser is ready.
2. **Effect dispatcher**: chat-bar interpreter for the effect list, with rollback for retracted interim transcripts.
3. **Modeline voice line**: render the wake-word table under the keyboard hints when listening.
4. **Migrate `voice-input.js`**: replace the direct `textContent` write with a call to `parser.dispatch(transcript)`.

The *behind-a-feature-flag* discipline is the *deployable-in-pieces* pattern: each phase is independently testable and shippable. The user-facing voice-input behavior switches only after phase 4 lands; phases 1-3 build the infrastructure without changing user behavior.

### §Design Decisions — five load-bearing choices

The §Design Decisions subsection makes five choices explicit with rationale.

#### Decision 1: Per-mode wake-word tables, not a global grammar

> A grammar would centralise the vocabulary but obscure which words are significant when. Per-mode tables match the modeline's shape and let a new command's registry entry add its own wake words without touching the parser.

The trade-off: *centralized-but-context-opaque grammar* vs *distributed-but-context-clear tables*. The design picks the latter for two reasons: (a) per-mode tables match the modeline's per-mode hint structure, (b) new commands gain voice support by adding registry entries, not by touching the parser.

#### Decision 2: Effects are passable values, not function calls

> The parser stays pure and testable; the chat bar owns the side effects. This matches the Hardened JavaScript convention of keeping effect descriptions inert.

The structural pattern: **parser produces effects-as-data; interpreter applies effects-as-side-effects**. Pure parser is unit-testable without DOM scaffolding. Inert effects match the Hardened JavaScript convention; they could (in principle) be transmitted across a marshal boundary if a future voice-server architecture needed it.

#### Decision 3: Rollback on retraction, not on every interim

> Re-applying every interim would flicker the UI. Wake words commit at word boundaries; only retracted wake words trigger inverses.

The optimization: *commit-at-word-boundary + roll-back-on-retract* minimizes UI flicker. The alternative *re-apply-on-every-interim* would cause the chat bar to flicker (chip appearing-and-disappearing-and-re-appearing as the interim transcript evolves).

#### Decision 4: Framed-pause submit, not always-on submit wake word

> A speaker who pauses naturally between sentences should not accidentally submit; the parser requires "submit" or "send now" to be flanked by a configured silence interval (initially 600 ms) on both sides. See "Escape and Enter" for the rule.

The trade-off: *always-on submit* (false-positives from any spoken `submit`) vs *framed-pause submit* (slightly slower but disambiguates). The §Escape-and-Enter argument from the prior section (this source's §2 cluster) is the deeper explanation; this decision-row records the consequence.

#### Decision 5: Per-token literal-quote escape

> The reserved word `quote` marks the next token as literal and suppresses wake-word interpretation, so a message can contain the words "slash", "at", "submit", or any other vocabulary the parser would otherwise eat. Chosen over a modal command-mode toggle because the modal approach forces a context switch the keyboard pipeline does not require.

The trade-off: *modal command-mode toggle* vs *per-token quote escape*. The modal approach requires the speaker to explicitly *enter-and-exit* command mode; the per-token escape lets the speaker stay in dictation flow with localized escapes. The keyboard pipeline has no equivalent modal toggle (it uses literal-character typing), so the per-token escape preserves keyboard-voice parity.

### §Open Questions — seven items deferred to maintainer call

The §Open Questions subsection enumerates seven items:

1. **Canonical command-menu wake word.** *`slash` is consistent with the keyboard but reads oddly aloud. `command` collides with the noun.* Trade-off between keyboard-parity and conversational readability.

2. **Inline vs deferred pet-name lookup.** *Should pet-name lookup happen inline during parsing, or should the parser emit `commit-token-pending` and let the chat bar resolve? Inline keeps the parser self-contained but couples it to the host; pending keeps the parser pure but defers errors.* This is the *parser-purity-vs-error-locality* trade-off.

3. **Modeline change loudness.** *A purely visual modeline misses the speaker who is looking at their face in the camera, not the screen. An aural cue is out of scope for this design but worth noting.* The *accessibility-via-aural-modeline* concern; deferred but flagged.

4. **Shared state across mic sessions.** *Does the parser want a shared state across mic sessions, or does each mic click reset to Send mode? The latter is simpler per se; the former enables resuming a multi-step command after an accidental pause.* The *session-isolation-vs-resume-capability* trade-off.

5. **Alternative literal-escape wake word.** *Is `quote` the right literal-escape wake word, or does an alternative read better aloud?* Candidates considered: `literally` (conversational filler; false-trigger risk), `say` (collides with imperative speech), `quote unquote` (requires closing token; doubles recognition surface), `escape` (overloaded with keyboard's Escape semantics). The choice deserves a *usability check before voice support ships beyond a feature flag*.

6. **Framing-pause threshold.** *600 ms is a starting point that aligns with the `endpointing` default in the existing `voice-input.js`, but short-pause speakers may trip it accidentally and long-pause speakers may need to wait. The threshold should be tunable per user, and the modeline should hint how long to wait.* The *per-user-tunable-threshold-with-modeline-hint* solution sketched.

7. **Non-voice long-press submit gesture.** *Should the parser also accept a non-voice "enter" gesture (e.g., a long-press on the mic button) as a submit cue, in addition to the framing-pause "submit" wake word? This would parallel push-to-talk's release-to-submit behaviour for tap-to-talk users.* The *gesture-redundancy-for-tap-to-talk* concern; flagged for future iteration.

### §Prompt — original ask preserved

The §Prompt subsection preserves the source ask:

> Please consider how we will parse voice transcription from the command line to fluently populate each of the kinds of commands afforded by the command line. Document the expected interaction patterns. Introduce a parser. That is likely an asynchronous parse monad state machine that tracks or drives the user interface mode. Consider using the modeline to hint what keywords are significant in each mode.
>
> (From kriskowal's review on [PR #44](https://github.com/endojs/endo-but-for-bots/pull/44), 2026-05-06.)

The §Prompt's four explicit asks map to the design: *parse voice transcription to populate command-line modes* (the thesis); *document interaction patterns* (§Interaction Patterns); *introduce a parser* (§Parser Shape); *asynchronous parse monad state machine* (§Why an asynchronous monad); *modeline hint* (§Modeline Integration). The design is *responsive to the prompt* with no scope creep — all four asks have corresponding sections.

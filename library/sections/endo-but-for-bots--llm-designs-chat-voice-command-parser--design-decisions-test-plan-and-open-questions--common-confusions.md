---
title: Common confusions
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

- **"The parser should be one big function."** Per-mode `ParseFn`s match the *registry-vocabulary-per-mode* discipline. A single parser would need to handle all nine modes' wake-word tables internally, which would be harder to test in isolation and harder to extend with new commands.
- **"Effects should be applied immediately by the parser."** The §Decision-2 *inert-passable-values* discipline keeps the parser pure. Side effects live in the chat-bar interpreter. This factoring is what makes the unit tests trivial (`assertDeepEqual(parser(state, fragment).effects, expectedEffects)`).
- **"600 ms is too short."** Or too long. The §Open-Question-6 explicitly acknowledges this: 600 ms is a *starting point* aligned with existing `endpointing`. The right answer is *per-user-tunable with a modeline hint*.
- **"The feature flag is dev-only."** It's a *deployable-in-pieces* discipline; the flag exists so phases 1-3 can land without changing user-facing behavior, and phase 4 flips the user-facing behavior once the infrastructure is solid. Production users can enable the flag for testing before it becomes default.
- **"The seven open questions block shipping."** Each open question is a *trade-off named for the maintainer*; the implementation can ship with the design's defaults (per-mode tables; `quote` escape; 600 ms threshold; reset-per-mic-session; etc.) and revisit each question as user feedback comes in. The open questions don't *block* the implementation; they *surface decisions for refinement*.
- **"Voice cannot drive Inline-Command-Form because field values are open-vocabulary."** The §Pattern-3 worked example shows voice driving an Inline-Command-Form with field-name wake words + open-vocabulary field values. The vocabulary collision is handled by *field-name as wake word, then the rest of the fragment flows into the value until the next field-name wake word*.

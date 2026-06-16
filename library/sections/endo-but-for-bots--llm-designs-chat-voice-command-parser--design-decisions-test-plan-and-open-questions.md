---
title: Five load-bearing design decisions (per-mode wake-word tables not global grammar; effects as passable values not function calls; rollback on retraction not on every interim; framed-pause submit not always-on; per-token `quote` literal escape); test plan (pure unit tests + stub-SpeechRecognition integration tests); dependencies on chat-command-bar / chat-pending-commands / chat-slot-slash-commands; four-phase implementation behind a feature flag; seven open questions deferred to maintainer call
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions--abstract.md)
- [Body](endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions--common-confusions.md)

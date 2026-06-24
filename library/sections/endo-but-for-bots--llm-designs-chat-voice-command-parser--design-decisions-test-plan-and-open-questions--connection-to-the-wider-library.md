---
title: Connection to the wider library
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

This section is the **canonical worked example of *deployable-behind-a-feature-flag-in-four-phases*** at the chat-UI level. Three threads:

1. **The pure-parser-test-plan discipline.** The §Test Plan is one-paragraph because the parser is pure: feed state + fragment, assert next state + effects. Generalizes to any input-channel design that uses inert effects.

2. **The five-design-decisions explicit-rationale form.** Each decision names the choice + the rejected alternative + the rationale. Reusable for any chat-UI design that makes load-bearing choices reviewers should understand.

3. **The seven-open-questions enumeration.** Each question names the choice the maintainer's reading owes the design. The form is reusable; the *trade-off-named-and-deferred* pattern keeps the design implementable while surfacing decisions explicitly.

---
title: See also
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

- [[chat-ui]] (topic) — the broader chat-UI surface.
- [[testing]] (topic) — the test-plan strategy generalizes to other input-channel designs.
- `endo-but-for-bots--llm-designs-chat-voice-command-parser--problem-scope-mode-inventory-and-parser-shape` — the prior section: parser shape + effect vocabulary + wake-word tables + modeline.
- `endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony` — the second section: five user-flow patterns + buffer-and-rollback + dual-mechanism Escape/Enter.
- `endo-but-for-bots--llm-designs-chat-command-bar` — source-of-truth for the modes.
- `endo-but-for-bots--llm-designs-chat-pending-commands` — pending-command pipeline that voice queues through.
- `endo-but-for-bots--llm-designs-chat-slot-slash-commands` — slot-based slash commands extending wake-word tables through the registry.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke` — the broader test-infrastructure surface this design's integration tests live alongside.

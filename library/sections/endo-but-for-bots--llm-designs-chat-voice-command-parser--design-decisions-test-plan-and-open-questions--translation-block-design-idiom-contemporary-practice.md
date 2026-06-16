---
title: Translation block (design idiom → contemporary practice)
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

| Design concept | Contemporary practice |
| -------------- | --------------------- |
| Pure-parser-test-plan | Unit tests on a pure function; no DOM scaffolding. The standard *inert-passable-effects* test pattern. |
| Stub `SpeechRecognition` integration tests | Integration tests on a scripted-fake event source; the standard chat-test infrastructure. |
| Behind-a-feature-flag four-phase implementation | Deployable-in-pieces; user-facing behavior switches only after the last phase lands. |
| Per-mode wake-word tables not global grammar | Vocabulary-as-data co-located with the registry entry that uses it. |
| Effects-as-passable-values | The Hardened JavaScript convention: inert descriptions, side-effecting interpreters. |
| Rollback-on-retraction at word boundaries | UI-flicker-minimizing event coalescing. |
| Seven open questions enumerated for maintainer | The standard chat-corpus *trade-off-named-and-deferred* form. |
| §Prompt preserved with PR review timestamp | The reconcile-against-original-ask discipline. |

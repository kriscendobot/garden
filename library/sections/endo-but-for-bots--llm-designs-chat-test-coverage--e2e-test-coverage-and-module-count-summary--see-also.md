---
title: See also
source: designs/chat-test-coverage.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, testing]
status: current
notes: |
  **Status: Complete** upstream. The E2E-and-coverage-summary cluster
  of the chat-test-coverage document: Playwright spec files for the
  two test classes that *cannot* be tested under happy-dom (token
  autocomplete in contenteditable; Monaco editor with cross-window
  postMessage); the protocol-documentation-as-tests pattern that the
  monaco-wrapper component test enacts; and the per-module breakdown
  showing 244 unit/component tests across 15 modules plus 39 E2E
  tests across 2 specs (283 total).
parent: endo-but-for-bots--llm-designs-chat-test-coverage--e2e-test-coverage-and-module-count-summary
---

- [[chat-ui]] (topic) — the broader chat-UI surface covered.
- [[testing]] (topic) — the broader test-discipline surface.
- `endo-but-for-bots--llm-designs-chat-test-coverage--test-organization-and-untestable-behaviors` — the prior section: directory layout + mock-powers + happy-dom + untestable-behaviors enumeration.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--*` (cycle 86) — the narrow CI guard *complementary* to this broader suite. The smoke targets *bundle builds and loads*; this suite targets *loaded UI behaves correctly*. Both share the Playwright infrastructure.
- `endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions` (cycle 89) — the voice-command-parser test plan extends this broader suite via *stub SpeechRecognition* component tests + Playwright integration tests.
- `endo-but-for-bots--llm-designs-chat-edit-message-ui--*` — the chat-edit-message-ui design's tests would live alongside this suite's structure.
- `endo-but-for-bots--llm-designs-chat-components` — the component-architecture design whose tests are catalogued here.

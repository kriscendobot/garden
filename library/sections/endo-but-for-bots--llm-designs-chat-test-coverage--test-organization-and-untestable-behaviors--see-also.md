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
  **Status: Complete** upstream. Extracted from
  `packages/chat/DESIGN.md`. This section captures the test-organization
  cluster: directory layout (helpers / unit / component / e2e); the
  mock-powers Far()-remotable approach; happy-dom with the
  DOM-globals-before-import discipline; and the explicit enumeration of
  three test surfaces that *cannot* be tested with happy-dom and
  require Playwright (token-autocomplete-in-contenteditable; Monaco-
  editor-cross-window-messaging; WebSocket-connection).
parent: endo-but-for-bots--llm-designs-chat-test-coverage--test-organization-and-untestable-behaviors
---

- [[chat-ui]] (topic) — the broader chat-UI surface this test suite covers.
- [[testing]] (topic) — the broader test-discipline surface.
- `endo-but-for-bots--llm-designs-chat-test-coverage--e2e-test-coverage-and-module-count-summary` — the next section in this source: E2E tests (Playwright) + test count tables.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--*` (cycle 86) — the *narrow CI guard* that complements this broader test suite; the playwright-smoke targets *the bundle builds and loads*, while this suite targets *the loaded UI behaves correctly*.
- `endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions` (cycle 89) — the chat-voice-command-parser test plan composes with this broader test suite via the *stub SpeechRecognition* approach.
- `endo-but-for-bots--llm-designs-chat-command-bar` — the command-bar component whose tests live under `component/inline-command-form.test.js`.
- `endo-but-for-bots--llm-designs-chat-spaces-gutter` — the spaces-gutter design whose tests live under `component/spaces-gutter-home.test.js`.

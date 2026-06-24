---
title: Abstract
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

§Test Organization establishes the `packages/chat/test/` directory layout: `index.test.js` (infrastructure verification); `helpers/` (`mock-powers.js` + tests for the mock itself; `dom-setup.js` for happy-dom; `keyboard-events.js` for event simulation); `unit/` (eight pure-logic test files — command-registry, command-executor, message-parse, ref-iterator, time-formatters, markdown-render, value-render); `component/` (seven happy-dom-based component tests — send-form, two petname-path-autocomplete variants, inline-command-form, monaco-wrapper protocol docs, form-request-inbox, spaces-gutter-home); `e2e/` (Playwright tests requiring a real browser). §Testing Approach makes two structural commitments: (1) **mock powers via `Far()` remotable** — `makeMockPowers()` returns a Far-remotable that *simulates the daemon's powers interface*, *tracks method calls, supports async iteration, and can be configured with initial names, values, and IDs*; (2) **happy-dom with global setup before chat-module imports** — *happy-dom provides a lightweight DOM implementation; global setup is done BEFORE importing chat modules because they reference DOM globals at module load time*. §Untestable Behaviors enumerates three specific behaviors that *cannot be tested with happy-dom due to Selection API limitations*: (1) **token autocomplete in contenteditable** — *typing `@`, filtering suggestions, arrow navigation, and Escape to close menu all require the browser's Selection API for cursor positioning in contenteditable elements*; (2) **Monaco editor integration** — *runs in an iframe with cross-window messaging*, requiring a real browser; (3) **WebSocket connection** — *requires actual or mock server*. The §Untestable framing is honest about the test surface's limits: *these behaviors require Playwright for proper E2E testing*. The three-class enumeration is a worked example of the *what-can-be-tested-where* discipline: pure logic → unit tests; DOM-event-driven UI → component tests under happy-dom; Selection-API-or-iframe-or-network → E2E tests under Playwright.

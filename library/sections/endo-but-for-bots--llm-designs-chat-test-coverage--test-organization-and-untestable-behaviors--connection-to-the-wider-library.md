---
title: Connection to the wider library
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

This section is the **canonical *test-decomposition-by-required-runtime* worked example** at the chat-UI level. Three threads:

1. **The Far()-remotable mock-daemon-powers pattern** generalizes to any chat-or-daemon-adjacent test. The library can cite this section whenever a test design needs to mock the daemon's powers interface.

2. **The DOM-globals-before-import discipline** is a hardened-JavaScript-friendly version of the *fixture-before-test* pattern. Reusable for any module that references globals at module-load time.

3. **The three-class enumeration (pure-logic / happy-dom-component / Playwright-E2E)** is the canonical decomposition for component-based frontend testing. Any chat-or-frontend test design should make this decomposition explicit.

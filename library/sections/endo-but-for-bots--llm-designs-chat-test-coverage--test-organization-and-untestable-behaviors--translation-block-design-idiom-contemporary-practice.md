---
title: Translation block (design idiom → contemporary practice)
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

| Design concept | Contemporary practice |
| -------------- | --------------------- |
| Far()-remotable mock daemon | Test infrastructure that mimics the eventual-send pattern; structurally analogous to GraphQL/RPC mocking. |
| happy-dom global setup before chat imports | The *side-effecting-setup-import-first* discipline; reusable for any DOM-dependent module. |
| Selection API limitations in happy-dom | A standard happy-dom caveat; documented across the testing community. |
| iframe cross-window messaging requires Playwright | A common Playwright use-case; postMessage flows across iframes are testable only with a real browser. |
| WebSocket connection requires mock server | The daemon-test-suite's responsibility; chat tests mock the daemon-powers layer above. |
| Three-class cost-tier hierarchy | Unit (cheap) / Component (moderate) / E2E (expensive); the standard frontend-test cost decomposition. |

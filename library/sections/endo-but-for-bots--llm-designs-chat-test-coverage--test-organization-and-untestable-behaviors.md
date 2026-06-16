---
title: How the chat package's tests are organized across `helpers/` + `unit/` + `component/` + `e2e/`; the mock-powers Far()-remotable test fixture; happy-dom for component tests with the *DOM-globals-must-be-set-before-importing-chat-modules* constraint; the three classes of *untestable-with-happy-dom* behavior that require a full browser (token autocomplete in contenteditable, Monaco editor cross-window messaging, WebSocket connection)
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-test-coverage--test-organization-and-untestable-behaviors--abstract.md)
- [Body](endo-but-for-bots--llm-designs-chat-test-coverage--test-organization-and-untestable-behaviors--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-chat-test-coverage--test-organization-and-untestable-behaviors--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-chat-test-coverage--test-organization-and-untestable-behaviors--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-chat-test-coverage--test-organization-and-untestable-behaviors--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-chat-test-coverage--test-organization-and-untestable-behaviors--common-confusions.md)

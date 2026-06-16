---
title: The Playwright E2E test coverage — token-autocomplete.spec.ts (25 tests covering menu/filtering/navigation/selection/edge-names) + monaco-editor.spec.ts (14 tests covering loading/content/shortcuts/protocol); the documenting-the-postMessage-protocol-as-tests pattern via `component/monaco-wrapper.test.js`; the per-module test count summary (244 unit+component tests across 15 modules; 39 E2E tests across 2 spec files; 283 total)
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-test-coverage--e2e-test-coverage-and-module-count-summary--abstract.md)
- [Body](endo-but-for-bots--llm-designs-chat-test-coverage--e2e-test-coverage-and-module-count-summary--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-chat-test-coverage--e2e-test-coverage-and-module-count-summary--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-chat-test-coverage--e2e-test-coverage-and-module-count-summary--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-chat-test-coverage--e2e-test-coverage-and-module-count-summary--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-chat-test-coverage--e2e-test-coverage-and-module-count-summary--common-confusions.md)

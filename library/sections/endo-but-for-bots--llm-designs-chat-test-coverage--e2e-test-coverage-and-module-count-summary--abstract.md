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

§E2E Tests (Playwright) catalogs the two `.spec.ts` files in `test/e2e/`. **`token-autocomplete.spec.ts` (25 tests)** covers: *menu visibility (`@` opens menu, `@@` escapes, Escape/Backspace closes); filtering (case-insensitive, "No matches" display); navigation (ArrowUp/Down, wrap-around); selection (Tab, Enter, Space, click); edge names (`:` enters mode, typing edge name); token deletion (Backspace after token); getMessage parsing (single/multiple tokens, edge names); edge cases (`@` not triggered after alphanumeric)*. **`monaco-editor.spec.ts` (14 tests)** covers: *loading (iframe loads, editor focused); content (typing updates, initial value); keyboard shortcuts (Cmd+Enter submit, Escape, Cmd+E add endowment); syntax highlighting, line numbers, multi-line; dispose removes iframe; postMessage protocol tests*. §Component-Tests-happy-dom-includes-monaco-wrapper-protocol-docs — the §E2E paragraph closes with *Component Tests (happy-dom) include `monaco-wrapper.test.js` which documents the postMessage protocol without requiring a browser*. This is the *protocol-documentation-as-tests* discipline: even though Monaco's behavior cannot be tested under happy-dom, the *expected* postMessage protocol is captured as tests-that-document (skipped or assertion-light) so future developers can read the test suite to understand the contract. §Test Count by Module presents the per-module breakdown: **244 unit/component tests across 15 modules** with completeness annotations per module (most marked *Complete*; `send-form: 4 Partial — state management only`; `monaco-wrapper: 1 Protocol documentation (skipped tests document API)`). §E2E Test Count adds **39 E2E tests across 2 specs**: token-autocomplete (25) + monaco-editor (14). **Total: 283 tests** across the chat package's test suite. The structural pattern: *each module's test count + completeness-status is explicit*, making the test surface auditable at a glance.

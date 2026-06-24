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

This section is the **canonical worked example of *coverage-honesty-with-scope-notes*** at the chat-UI level. Three threads:

1. **The protocol-documentation-as-tests pattern.** When a protocol cannot be exercised in the current test runtime, capture the expected messages as skipped or assertion-light tests that *document* the contract. Reusable for any protocol-across-boundary that the test runtime cannot cross.

2. **The cost-tier-hierarchy + coverage-decomposition pattern.** Unit (155 tests; fast) / Helpers (10 tests; moderate) / Component (79 tests; moderate) / E2E (39 tests; slow). The 6.3:1 fast-to-slow ratio reflects the discipline of *prefer fast tests; reserve slow tests for what only they can cover*. Reusable for any tiered test suite.

3. **The per-module coverage table with completeness annotations.** Every module has an explicit *Complete* / *Partial - scope-note* / *Protocol documentation* label. The label is the *honest* coverage signal that prevents the test suite from feeling falsely comprehensive. Reusable for any test-coverage audit.

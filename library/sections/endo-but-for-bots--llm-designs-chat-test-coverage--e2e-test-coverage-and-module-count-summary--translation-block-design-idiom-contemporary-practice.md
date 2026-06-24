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

| Design concept | Contemporary practice |
| -------------- | --------------------- |
| Eight-category token-autocomplete coverage | Comprehensive feature-surface enumeration; the *what-can-go-wrong-with-this-UI-component* checklist. |
| `.spec.ts` for E2E vs `.test.js` for unit/component | Filename-level test-type signal; reusable for any tiered test suite. |
| Protocol-documentation-as-tests | Skipped tests as protocol specs; the test file is *documentation that compiles to runnable artifacts*. |
| Per-module coverage table with annotations | The standard frontend-test-suite documentation form; each module's test count + completeness label visible at a glance. |
| 6.3:1 fast-to-slow test ratio | The cost-tier-hierarchy discipline; aim for >5:1 fast-to-slow to keep every-commit CI tractable. |
| Coverage-honesty (*Partial - state management only*) | Reserve *Complete* for modules with full coverage; partial coverage gets a scope-note. |
| 283-test-total scale | A moderate chat-package test suite; comparable to other complex frontend-component packages. |

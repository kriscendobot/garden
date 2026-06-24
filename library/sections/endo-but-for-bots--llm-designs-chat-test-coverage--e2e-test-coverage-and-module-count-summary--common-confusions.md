---
title: Common confusions
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

- **"244 tests is too few for 15 modules."** It is *appropriate for the modules' scope*: most modules have 10-30 tests covering their full surface. The `monaco-wrapper`'s 1 test is *protocol documentation*, not under-coverage. The `send-form`'s 4 partial tests are *state-management only*, with the UI behaviors tested at E2E. Headcount-without-context is misleading; the scope-notes are the honest signal.
- **"The 39 E2E tests should be more."** The cost-tier hierarchy: every-commit-CI cost of 39 E2E tests is *the right budget* for a chat package; more E2E tests would slow the CI without proportional coverage gain (most behaviors that *can* be tested at unit/component are tested there).
- **"Protocol-documentation-as-tests is misleading — the tests don't actually test anything."** They *document the protocol*. A developer reading `monaco-wrapper.test.js` learns the postMessage contract. The skipped tests are *executable specs that don't execute* — they fail informatively if the file is ever rewritten to test the actual integration (which would require moving the file to E2E).
- **"`.spec.ts` is a Playwright convention."** It is — Playwright's default test discovery looks for `*.spec.ts` and `*.spec.js`. The chat package adopts the convention to distinguish E2E tests from `.test.js` unit/component tests. The convention reduces test-runtime ambiguity at the filename level.
- **"Coverage tables go stale."** The §Test Count by Module table is *a snapshot at 2026-03-02*. The library captures it for reference; the live test suite's coverage is what matters. The library's value is the *structural pattern* of the table, not the specific counts.
- **"Complete is binary."** The §Test Count by Module table uses *Complete*, *Partial - <scope>*, and *Protocol documentation* — three labels, not two. The intermediate labels are the *coverage-honesty* discipline.
- **"`packages/chat/DESIGN.md` is the source of truth, not this doc."** This design *is* the source of truth for the test-coverage portion. `packages/chat/DESIGN.md` may have additional information about the overall design, but the test-coverage information is *extracted-and-self-contained* here.

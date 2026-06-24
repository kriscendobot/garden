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

- **"happy-dom is jsdom."** They are different libraries with different trade-offs: happy-dom is *faster but less complete*; jsdom is *slower but more complete*. The chat test suite picks happy-dom for the cost-tier-hierarchy reason — component tests should be *fast enough* to run on every commit, which happy-dom enables.
- **"The mock-daemon Far() is overkill — a plain object would do."** A plain object would behave subtly differently when accessed via the `E(...)` eventual-send pattern. The `Far()` shape ensures the mock is indistinguishable from a real remote daemon from the chat code's perspective. The cost is small; the fidelity benefit is substantial.
- **"Selection API limitations are happy-dom's fault."** It is happy-dom's *intentional minimalism* — supporting the full Selection API would slow happy-dom down and most use cases don't need it. The chat test suite *accepts the limitation* and pushes the relevant tests to E2E.
- **"All chat tests should run in Playwright."** The cost-tier argument: Playwright is *much slower* than happy-dom (browser startup ~1-5 seconds vs happy-dom startup ~10-100ms). Running 244 unit/component tests under Playwright would be prohibitive for every-commit CI. The decomposition favors fast tests for fast feedback.
- **"DOM-globals-before-import is a JavaScript quirk."** It is a *hardened-JavaScript-friendly version* of fixture-before-test. The constraint comes from how SES + Compartment + chat-module structure work: top-level imports execute synchronously, so any global the imports depend on must already be set.
- **"The 7 untestable behaviors break the test suite's value."** The decomposition is explicit: *what cannot be tested here* is pushed to E2E. The component tests still cover most of the chat package's surface; the E2E tests cover the gaps. The combined coverage is comprehensive.

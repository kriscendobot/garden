---
title: Connection to the wider library
source: designs/chat-playwright-smoke.md
source_repo: endojs/endo-but-for-bots
source_branch: design/chat-playwright-smoke
source_commit: 2a97b2d6c4c0e1714631fc42f6c34cd78e18db5b
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, testing]
status: current
notes: |
  **Status: Not Started** upstream. The "What is the Problem Being
  Solved?" framing for the chat-playwright-smoke design. Names a specific
  regression class — *the Chat production bundle fails to build, parse,
  lockdown, or reach its first user-visible state* — that lands silently
  in CI today, and explains why the sibling `chat-test-coverage` e2e
  suite (Complete; uses `yarn dev` + daemon fixture) is the wrong tool
  for this narrower regression.
parent: endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage
---

This section is the **motivational framing for a narrow CI guard against silent bundle regressions**. The library can cite this section whenever:

1. **A design needs to motivate a narrow CI guard.** The pattern of *targeting a regression class so narrow that the broader test suite is the wrong tool* is rare and useful. The chat-playwright-smoke is a worked example.
2. **A design discusses the dev-vs-prod build divergence.** Vite's dev-server bundle differs from its production bundle in module resolution, transformations, and module shape; tests that pass against `yarn dev` can miss regressions that only the production bundle exposes. The smoke's daemon-free production-bundle scope is the canonical answer.
3. **A design needs to explain why two test surfaces are complementary, not duplicative.** The chat-test-coverage e2e suite + the chat-playwright-smoke each catch a different class of failure; running both is not redundant.

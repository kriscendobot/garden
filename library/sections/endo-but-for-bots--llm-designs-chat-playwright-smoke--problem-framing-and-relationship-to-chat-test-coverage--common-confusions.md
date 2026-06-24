---
title: Common confusions
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

- **"Why not just run chat-test-coverage in CI?"** Three reasons: (a) it doesn't run there today; (b) it tests `yarn dev` not the production bundle, and the two bundles can diverge; (c) it requires daemon-shaped fixtures the smoke doesn't. The smoke and the e2e suite are *complementary*: smoke catches build-and-load; e2e catches behavior post-load.
- **"The smoke duplicates the canary spec."** The canary spec exercises the SES UMD bundle as a standalone; the smoke exercises the Chat Vite bundle. The two are different artifacts with different failure modes. The canary catches SES-bundle regressions; the smoke catches Chat-bundle regressions.
- **"The 'Gateway not configured' heading is brittle."** The heading text is the existing fallback state the entry point already implements (lines 33-46 of `packages/chat/main.js`). Renaming it would be a deliberate UI change and would be caught by the smoke, prompting the engineer to update the assertion. The brittleness is *intentional*: the heading is the deterministic signal that the bundle reached its first user-visible state.
- **"Without a daemon, the smoke doesn't test anything realistic."** The smoke explicitly targets *build-and-load*, not behavior. Behavior is tested by the e2e suite. Asking the smoke to test behavior is asking the wrong question.

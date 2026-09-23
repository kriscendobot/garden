---
title: Implications for Endo / Agoric
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

This section maps directly to the contemporary Endo `browser-tests` CI workflow. The library can cite it whenever:

1. **A design discusses adding a new Vite-built package to CI.** The chat-playwright-smoke pattern (fragment-less navigation + deterministic fallback state assertion) generalizes to any Vite-built React/SES application.
2. **A design discusses SES lockdown failures.** The bundle parse / lockdown-time error / top-level import failure regression classes all reach back to SES's strict requirements; a "bundle builds and loads" smoke is the right CI surface for those classes.

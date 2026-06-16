---
title: See also
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

- [[hardened-javascript]] (topic) — SES is the strict environment that catches bundle regressions; the smoke is the CI surface that exposes them.
- [[testing]] (topic) — CI test-suite design choices; the smoke is a worked example of *deliberately-narrow* scoping.
- `endo-but-for-bots--llm-designs-chat-components` — the broader Chat component design that the smoke protects against silent regression.
- `endo-but-for-bots--llm-designs-chat-pending-commands` — adjacent chat-UI design; both target the same Vite-built package.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture` — the next section in this source: how the smoke is built, served, and run.

---
title: The silent-bundle-regression problem; what the existing browser-tests job exercises; why chat-test-coverage's broader e2e suite isn't the answer for this narrower regression class
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage--abstract.md)
- [Body](endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage--connection-to-the-wider-library.md)
- [Implications for Endo / Agoric](endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage--implications-for-endo-agoric.md)
- [See also](endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage--common-confusions.md)

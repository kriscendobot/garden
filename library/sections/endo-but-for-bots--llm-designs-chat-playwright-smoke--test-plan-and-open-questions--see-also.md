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
  **Status: Not Started** upstream. The validation + decisions cluster
  of the chat-playwright-smoke design: how to verify the smoke catches
  what it claims to via deliberate injection + revert; what is
  explicitly out of scope; and five open questions the maintainer's
  reading owes the design before it can be implemented.
parent: endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions
---

- [[testing]] (topic) — the broader CI test-suite design surface this section sits within.
- [[chat-ui]] (topic) — the Chat application under test.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage` — the first section: what regression class this smoke targets.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture` — the second section: how the smoke is built, served, and exercised.
- `endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems` — adjacent chat design with a similar problem-framing + out-of-scope structure.

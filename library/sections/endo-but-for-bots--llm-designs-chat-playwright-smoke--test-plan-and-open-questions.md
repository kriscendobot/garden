---
title: The injection-test verification (pass on clean tree, fail on deliberate regression, pass again after revert); out-of-scope explicit list; five open questions the maintainer owes the design (browser engine, console-error strictness, failed-request strictness, serve mechanism, screenshot artifact)
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions--abstract.md)
- [Body](endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions--common-confusions.md)

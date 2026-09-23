---
title: How the smoke is built (existing yarn build), served (extend browser-test/server.js or add a second Playwright webServer), and exercised (Playwright fixture at browser-test/tests/chat.spec.js); plus CI integration
source: designs/chat-playwright-smoke.md
source_repo: endojs/endo-but-for-bots
source_branch: design/chat-playwright-smoke
source_commit: 2a97b2d6c4c0e1714631fc42f6c34cd78e18db5b
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, testing]
status: current
notes: |
  **Status: Not Started** upstream. The implementation cluster of the
  chat-playwright-smoke design: three steps (build, serve, exercise) plus
  CI integration, with two acceptable serve approaches enumerated and a
  preference for extending the existing static-file server over adding
  an `http-server` dependency.
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture--abstract.md)
- [Body](endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture--body.md)
- [Dependencies and the dependency-surface argument](endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture--dependencies-and-the-dependency-surface-argument.md)
- [Translation block (design idiom → contemporary CI surface)](endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture--translation-block-design-idiom-contemporary-ci-surface.md)
- [See also](endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture--common-confusions.md)

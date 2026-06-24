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
  **Status: Not Started** upstream. The implementation cluster of the
  chat-playwright-smoke design: three steps (build, serve, exercise) plus
  CI integration, with two acceptable serve approaches enumerated and a
  preference for extending the existing static-file server over adding
  an `http-server` dependency.
parent: endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture
---

- [[hardened-javascript]] (topic) — SES is the lockdown environment; the smoke's heading assertion is the proof that lockdown succeeded.
- [[testing]] (topic) — Playwright e2e infrastructure; the smoke reuses the existing canary's Playwright + server pattern.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage` — the prior section: why this smoke is the right tool for this regression class.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions` — the next section: how to verify the smoke catches what it claims to, and what decisions the maintainer still owes the design.
- `endo-but-for-bots--llm-designs-chat-components` — the Chat application under test; defines the entry-point and the "Gateway not configured" fallback state.

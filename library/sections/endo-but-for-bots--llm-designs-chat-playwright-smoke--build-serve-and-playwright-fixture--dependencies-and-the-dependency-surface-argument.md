---
title: Dependencies and the dependency-surface argument
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

The design's `Dependencies` table is short and load-bearing:

| Dependency | Relationship |
|---|---|
| `.github/workflows/browser-test.yml` (job `browser-tests`) | The existing CI job this design extends. |
| `browser-test/playwright.config.js` and `browser-test/server.js` | The existing Playwright + static-server infrastructure the new spec reuses. |
| `packages/chat/` | The application under test. The smoke depends on `vite build` producing `dist/index.html` and on the entry point's "Gateway not configured" fallback path. |
| `chat-test-coverage.md` (Complete) | Sibling design covering the broader unit, component, and e2e test surface inside `packages/chat/test/`. This smoke is intentionally narrower. |
| `@playwright/test` | Already a dev dependency of `browser-test/` and of `packages/chat/`. No new dependency needed. |

The argument is *zero new runtime/test dependencies are needed*. Approach 2 specifically minimizes the dependency surface: the smoke adds one new spec file + a short route-extension to `browser-test/server.js`, with no new packages and no new dev-dependencies. Approach 1 adds one optional dev-dependency (`http-server`) or one new file (`browser-test/chat-server.js`); both are acceptable but neither is preferred over the dependency-free Approach 2.

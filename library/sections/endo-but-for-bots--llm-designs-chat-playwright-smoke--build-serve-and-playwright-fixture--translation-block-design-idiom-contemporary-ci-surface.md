---
title: Translation block (design idiom → contemporary CI surface)
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

| Design concept | Contemporary CI surface |
| -------------- | ----------------------- |
| Reuse `yarn build` for the smoke | The existing workspace build step in `.github/workflows/browser-test.yml`. |
| Extend `browser-test/server.js` to mount `/chat/` | Static-file route addition to the existing Node HTTP server; structurally a small `if (url.startsWith('/chat/'))` branch. |
| Second `webServer` entry in `playwright.config.js` | An array-form `webServer` in Playwright config; Playwright orchestrates start/stop. Requires careful port allocation. |
| Fragment-less navigation reaches "Gateway not configured" | The entry-point's deterministic fallback state; daemon-free by design. |
| `pageerror` + `requestfailed` event handlers | Playwright's standard event API for catching top-level errors and network failures. |

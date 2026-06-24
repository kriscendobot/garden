---
title: Abstract
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

§Design breaks the smoke into three steps — *build*, *serve*, *exercise* — plus *CI integration*. The **build step** relies on the existing `yarn build` invocation at the workspace root that the `browser-tests` job already runs as the "Build artifacts" step; it builds every workspace including `@endo/chat` to `packages/chat/dist/`, so no additional build invocation is required. The **serve step** needs `packages/chat/dist/index.html` and its assets reachable over HTTP. Two acceptable approaches in preference order: (1) reuse the Playwright `webServer` config in `browser-test/playwright.config.js` by adding a second entry that serves `packages/chat/dist` — either via `npx http-server packages/chat/dist -p 3001 -c-1 --silent` (adds `http-server` as a `browser-test/` dev dependency) or via a tiny static-file server in `browser-test/chat-server.js` mirroring `browser-test/server.js`; or (2) extend `browser-test/server.js` to serve `packages/chat/dist/*` from a `/chat/` URL prefix, keeping the dependency surface unchanged. The design recommends approach (2): fewer dependencies, matches the existing `browser-test/server.js` shape, and avoids the `webServer` composition concerns. The **exercise step** is a new spec at `browser-test/tests/chat.spec.js` that navigates to `http://127.0.0.1:3000/chat/` (the served URL), registers `pageerror` and `requestfailed` handlers, and asserts: (a) the "Gateway not configured" heading is visible within 30s; (b) no uncaught page errors occurred; (c) no failed requests occurred. The **CI integration step** is a new step in the `browser-tests` job between "Install Playwright Browsers" and "Run Playwright tests" that ensures `packages/chat/dist/` is present (it is, after Build artifacts) and lets the existing Playwright-test step pick up the new spec automatically because it lives under `browser-test/tests/`. The new step is *only* required if approach (1) is taken (to start the second `webServer`); approach (2) requires no additional CI step.

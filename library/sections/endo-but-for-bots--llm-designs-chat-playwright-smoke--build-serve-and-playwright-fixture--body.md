---
title: Body
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

### Build step — relies on existing `yarn build`

Chat already builds with Vite via `yarn build` in `packages/chat/` (`packages/chat/package.json`, `"build": "vite build"`). The output lands in `packages/chat/dist/`, configured in `packages/chat/vite.config.js` (`base: './'`, `outDir: 'dist'`). The relative `base` is what makes `dist/` directly servable as static files from any path.

The browser-tests job already runs `yarn build` at the workspace root (`.github/workflows/browser-test.yml`, step "Build artifacts"), which builds every workspace including `@endo/chat`. The new smoke can rely on the existing build step; it does not need its own `yarn workspace @endo/chat run build` invocation.

This is a *zero-cost reuse*: no new build invocation, no new CI step for the build, no new artifacts to manage. The existing workflow's Build artifacts step already produces what the smoke needs.

### Serve step — extend `browser-test/server.js` (preferred) or add a second `webServer`

The smoke needs `packages/chat/dist/index.html` and its assets served over HTTP so the bundle module URLs resolve as a browser expects. The design enumerates two acceptable approaches, in preference order:

**Approach 1 (acceptable but adds dependency or file)**: reuse the Playwright `webServer` config in `browser-test/playwright.config.js` by adding a second entry that serves `packages/chat/dist`. Playwright supports an array of `webServer` entries. The serve command can be:

- `npx http-server packages/chat/dist -p 3001 -c-1 --silent` if `http-server` is added as a dev dependency to `browser-test/`, OR
- a tiny static-file server in `browser-test/chat-server.js` mirroring `browser-test/server.js`.

**Approach 2 (recommended)**: extend `browser-test/server.js` to serve `packages/chat/dist/*` from a `/chat/` URL prefix. This keeps the dependency surface unchanged. The static-file server pattern in `browser-test/server.js` is already shaped for this — adding a URL-prefix-based route to `packages/chat/dist/` is a small structural addition, not a new file or dependency.

The design picks approach 2 as the starting point: *fewer dependencies, matches the existing `browser-test/server.js` shape, and avoids the `webServer` composition concerns*. The composition concerns are real: a second `webServer` entry must compose cleanly with the existing one — same port-allocation discipline, same start/stop semantics, same readiness signal. Adding a static-file route to an existing server is structurally simpler.

### Exercise step — the Playwright fixture at `browser-test/tests/chat.spec.js`

A new spec at `browser-test/tests/chat.spec.js` does the following:

```js
// @ts-check
const { test, expect } = require('@playwright/test');

test('chat bundle builds and loads', async ({ page }) => {
  /** @type {string[]} */
  const pageErrors = [];
  /** @type {{ url: string, status: number }[]} */
  const failedRequests = [];

  page.on('pageerror', err => {
    pageErrors.push(err.stack || err.message);
  });
  page.on('requestfailed', req => {
    failedRequests.push({
      url: req.url(),
      status: req.response()?.status() ?? 0,
    });
  });

  await page.goto('http://127.0.0.1:3000/chat/');

  // The entry point at packages/chat/main.js renders a
  // "Gateway not configured" heading when navigated without a
  // fragment containing gateway and agent parameters.  Reaching
  // that heading proves SES lockdown succeeded, the bundle parsed,
  // and the entry script ran past its top-level imports.
  await expect(
    page.getByRole('heading', { name: /Gateway not configured/i }),
  ).toBeVisible({ timeout: 30_000 });

  expect(pageErrors, 'no uncaught page errors').toEqual([]);
  expect(failedRequests, 'no failed requests').toEqual([]);
});
```

The fixture has three independently-falsifiable assertions:

1. **The "Gateway not configured" heading is visible within 30s**: reaching this state proves SES lockdown succeeded, the bundle parsed, the entry script ran past its top-level imports, and the React render reached its first state.
2. **`pageErrors` is empty**: no uncaught JavaScript error fired during page load. The `pageerror` event covers errors that escape to the top level — exactly the regression class the smoke targets.
3. **`failedRequests` is empty**: no asset 404 / 5xx / network-error occurred. Catches asset-path mismatches, missing chunks, missing CSS imports.

The three assertions are *independently* falsifiable: a regression in bundle parsing fails (2); a regression in asset paths fails (3); a regression that reaches the entry script but breaks before the heading renders fails (1). All three together form a tight, falsifiable assertion.

The fragment-less navigation is *intentional*. Supplying a fake gateway and agent would force the bundle into WebSocket connection logic which would fail without a daemon; filtering those errors out would weaken the assertion. The "Gateway not configured" path is the deterministic, daemon-free state the entry point already implements (`packages/chat/main.js`, lines 33 to 46).

### CI integration step — automatic pickup or one new step

The design recommends adding a new step to the `browser-tests` job in `.github/workflows/browser-test.yml`, between `Install Playwright Browsers` and `Run Playwright tests`, that ensures `packages/chat/dist/` is present (it is, after the existing `Build artifacts` step builds the workspace), and letting the existing `Run Playwright tests` step pick up the new spec automatically because it lives under `browser-test/tests/`.

The key insight is *Playwright already discovers specs by directory*. A new `browser-test/tests/chat.spec.js` is automatically run by `npx playwright test` without any configuration change. So:

- **If approach 2 is taken** (extend `browser-test/server.js`): no new CI step is required. The existing `Run Playwright tests` step picks up `chat.spec.js` automatically.
- **If approach 1 is taken** (separate `webServer` entry): a new CI step IS required, purely "ensure the second server starts". The Playwright `webServer` orchestration handles the actual start; the CI step is the readiness check.

The smoke must run before any heavier Chat e2e test that depends on a daemon, because if the bundle does not load there is no point exercising deeper behavior. The Playwright `test.describe.serial` mechanism or the file-ordering convention (`chat.spec.js` before `chat-e2e.spec.js`) handles ordering when the e2e suite eventually lands in CI.

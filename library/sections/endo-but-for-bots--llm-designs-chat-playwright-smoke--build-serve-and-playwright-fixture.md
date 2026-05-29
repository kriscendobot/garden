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
---

## Abstract

§Design breaks the smoke into three steps — *build*, *serve*, *exercise* — plus *CI integration*. The **build step** relies on the existing `yarn build` invocation at the workspace root that the `browser-tests` job already runs as the "Build artifacts" step; it builds every workspace including `@endo/chat` to `packages/chat/dist/`, so no additional build invocation is required. The **serve step** needs `packages/chat/dist/index.html` and its assets reachable over HTTP. Two acceptable approaches in preference order: (1) reuse the Playwright `webServer` config in `browser-test/playwright.config.js` by adding a second entry that serves `packages/chat/dist` — either via `npx http-server packages/chat/dist -p 3001 -c-1 --silent` (adds `http-server` as a `browser-test/` dev dependency) or via a tiny static-file server in `browser-test/chat-server.js` mirroring `browser-test/server.js`; or (2) extend `browser-test/server.js` to serve `packages/chat/dist/*` from a `/chat/` URL prefix, keeping the dependency surface unchanged. The design recommends approach (2): fewer dependencies, matches the existing `browser-test/server.js` shape, and avoids the `webServer` composition concerns. The **exercise step** is a new spec at `browser-test/tests/chat.spec.js` that navigates to `http://127.0.0.1:3000/chat/` (the served URL), registers `pageerror` and `requestfailed` handlers, and asserts: (a) the "Gateway not configured" heading is visible within 30s; (b) no uncaught page errors occurred; (c) no failed requests occurred. The **CI integration step** is a new step in the `browser-tests` job between "Install Playwright Browsers" and "Run Playwright tests" that ensures `packages/chat/dist/` is present (it is, after Build artifacts) and lets the existing Playwright-test step pick up the new spec automatically because it lives under `browser-test/tests/`. The new step is *only* required if approach (1) is taken (to start the second `webServer`); approach (2) requires no additional CI step.

## Body

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

## Dependencies and the dependency-surface argument

The design's `Dependencies` table is short and load-bearing:

| Dependency | Relationship |
|---|---|
| `.github/workflows/browser-test.yml` (job `browser-tests`) | The existing CI job this design extends. |
| `browser-test/playwright.config.js` and `browser-test/server.js` | The existing Playwright + static-server infrastructure the new spec reuses. |
| `packages/chat/` | The application under test. The smoke depends on `vite build` producing `dist/index.html` and on the entry point's "Gateway not configured" fallback path. |
| `chat-test-coverage.md` (Complete) | Sibling design covering the broader unit, component, and e2e test surface inside `packages/chat/test/`. This smoke is intentionally narrower. |
| `@playwright/test` | Already a dev dependency of `browser-test/` and of `packages/chat/`. No new dependency needed. |

The argument is *zero new runtime/test dependencies are needed*. Approach 2 specifically minimizes the dependency surface: the smoke adds one new spec file + a short route-extension to `browser-test/server.js`, with no new packages and no new dev-dependencies. Approach 1 adds one optional dev-dependency (`http-server`) or one new file (`browser-test/chat-server.js`); both are acceptable but neither is preferred over the dependency-free Approach 2.

## Translation block (design idiom → contemporary CI surface)

| Design concept | Contemporary CI surface |
| -------------- | ----------------------- |
| Reuse `yarn build` for the smoke | The existing workspace build step in `.github/workflows/browser-test.yml`. |
| Extend `browser-test/server.js` to mount `/chat/` | Static-file route addition to the existing Node HTTP server; structurally a small `if (url.startsWith('/chat/'))` branch. |
| Second `webServer` entry in `playwright.config.js` | An array-form `webServer` in Playwright config; Playwright orchestrates start/stop. Requires careful port allocation. |
| Fragment-less navigation reaches "Gateway not configured" | The entry-point's deterministic fallback state; daemon-free by design. |
| `pageerror` + `requestfailed` event handlers | Playwright's standard event API for catching top-level errors and network failures. |

## See also

- [[hardened-javascript]] (topic) — SES is the lockdown environment; the smoke's heading assertion is the proof that lockdown succeeded.
- [[testing]] (topic) — Playwright e2e infrastructure; the smoke reuses the existing canary's Playwright + server pattern.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage` — the prior section: why this smoke is the right tool for this regression class.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions` — the next section: how to verify the smoke catches what it claims to, and what decisions the maintainer still owes the design.
- `endo-but-for-bots--llm-designs-chat-components` — the Chat application under test; defines the entry-point and the "Gateway not configured" fallback state.

## Common confusions

- **"Why not just add `http-server` as a dependency?"** The design's preference for Approach 2 is that *the dependency surface should stay minimal in a security-sensitive workspace*. `http-server` is a small, widely-used package, but every dependency is one more thing to audit; the static-file server pattern in `browser-test/server.js` is already there. The design *allows* Approach 1 but prefers Approach 2.
- **"The 30s timeout is arbitrary."** It is the canary spec's timeout, chosen to absorb cold-start variance in CI runners. A faster bundle (or a regression that fails fast) doesn't pay the full timeout; a slow bundle (or a transient CI lag) is given enough time to load. The number is a single-knob value with a clear rationale.
- **"What if the bundle loads but the WebSocket fails?"** The smoke navigates *without* a fragment, so the entry point never attempts a WebSocket connection. The fragment-less path is a deterministic daemon-free fallback. If a future change makes the WebSocket connection attempt unconditional, the smoke would catch it as a `pageerror` (because the WebSocket connection would fail without a daemon) — which is the correct outcome: the bundle would no longer be running in a daemon-free environment without throwing.
- **"What if approach 1 and approach 2 are both impractical?"** The design enumerates exactly these two; the maintainer's choice is between them. If both prove problematic in implementation, the design's prompt invites a follow-up dispatch to revise the approach — but the design notes "either path is acceptable" before recommending approach 2, signaling the design is implementation-flexible.
- **"`vite.config.js`'s `base: './'` is fragile."** It is *required* for the smoke to work — without a relative base, the bundle's asset URLs would be absolute and the `/chat/` prefix would not work. The smoke implicitly depends on this Vite config; a regression that changes `base:` would be caught by the smoke (assets would 404) and the engineer would update both the Vite config and the smoke together.

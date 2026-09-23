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
  **Status: Not Started** upstream. The "What is the Problem Being
  Solved?" framing for the chat-playwright-smoke design. Names a specific
  regression class — *the Chat production bundle fails to build, parse,
  lockdown, or reach its first user-visible state* — that lands silently
  in CI today, and explains why the sibling `chat-test-coverage` e2e
  suite (Complete; uses `yarn dev` + daemon fixture) is the wrong tool
  for this narrower regression.
parent: endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage
---

### What the existing `browser-tests` job exercises

The `.github/workflows/browser-test.yml` workflow defines a `browser-tests` job that:

1. Installs Playwright and its browser binaries.
2. Runs `yarn build` at the workspace root (the `Build artifacts` step), which builds every workspace package — including `@endo/chat`'s Vite output to `packages/chat/dist/`.
3. Runs `npx playwright test` against the specs in `browser-test/tests/`, the main of which is `canary.spec.js` — a Playwright check that the SES UMD bundle loads in a real browser.

The job *already does* the heavy infrastructure work: Playwright is provisioned, a real browser is available, the workspace is built, and a static-file server is running (via `browser-test/server.js` plus the `webServer` config in `browser-test/playwright.config.js`). What the job does *not* do is point Playwright at the `@endo/chat` bundle and assert it loads.

### The regression class this design targets

The narrow regression this smoke catches is *the production bundle fails to reach its first user-visible state*. Specifically:

- **Bundle parse failures**: SES rejecting an asset for non-strict-mode constructs; Vite output that surprises SES's parser; a `lockdown()` call that throws before any user-visible UI renders.
- **Top-level import failures**: `main.js`'s top-level imports (`ses`, `@endo/eventual-send/shim.js`, `connection.js`, `chat.js`, and their transitive imports) all execute before any UI renders. A missing or renamed module surfaces only when the bundle is loaded by a browser.
- **Asset path mismatches**: a 404 on the bundle, on `index.css`, or on a chunk — caused by a bad `base:` in `vite.config.js`, a missing `assetsInclude`, or a stray reference to an asset that no longer exists.
- **Lockdown-time errors**: errors that throw between bundle-parse and entry-script-execution — e.g. a `lockdown` call with an option the current SES doesn't recognize.

All four classes share a property: they fail *before any user-visible UI renders*, so a developer using `yarn dev` sees a blank page or a console error and a contributor running CI sees nothing at all (because no CI test exercises the bundle in a browser).

### Why `chat-test-coverage` is not the answer for this regression

The sibling design `chat-test-coverage.md` (Complete) describes the broader unit, component, and Playwright e2e tests that already live inside `packages/chat/test/`. Those tests:

- **Exercise UI behaviors**, not just bundle-load. They assume the bundle loads and check what happens after.
- **Require `yarn dev`**, the Vite dev server, not the production build. The dev-server bundle is *different* from the production bundle — Vite resolves imports differently, applies different transformations, and serves modules in a different shape. A regression in the production bundle that the dev-server bundle masks can land silently even if the e2e suite passes.
- **Require a daemon-shaped powers fixture**. The Chat e2e tests mock or stub the daemon connection; setting up that fixture is non-trivial for CI.
- **Do not currently run in CI**. The `chat-test-coverage` design notes they live in `packages/chat/test/` but the existing `browser-tests` workflow does not invoke them.

So the chat-test-coverage suite is the wrong tool for this regression for *three independent reasons*: (1) it doesn't run in CI today; (2) even when it does run, it tests `yarn dev` not the production bundle; (3) it requires daemon-shaped fixtures.

The chat-playwright-smoke is *deliberately* narrower:

- **Production-bundle**: tests what CI builds, which is what users get.
- **Daemon-free**: navigates without a fragment, so the entry point reaches the "Gateway not configured" deterministic fallback state and never attempts a WebSocket connection.
- **Fixture-free**: no daemon stubs, no powers mocks, no setup overhead.

The two designs are complementary. The smoke catches "the bundle builds and loads"; chat-test-coverage catches "the loaded UI behaves correctly". The smoke is a *prerequisite* for the e2e suite — if the bundle doesn't load, there is no point exercising deeper behavior.

### The "build-and-load" invariant

The design's choice of invariant is *the entry point reaches the "Gateway not configured" heading without any uncaught error or failed request*. This invariant has three nice properties:

1. **Deterministic without fixtures**: the entry point at `packages/chat/main.js` lines 33-46 renders a "Gateway not configured" heading when no `gateway` and `agent` parameters are in the URL fragment. So a fragment-less navigation deterministically reaches this state. No daemon, no WebSocket, no fixtures needed.
2. **Strong**: reaching the heading proves SES lockdown succeeded, the bundle parsed, the entry script ran past its top-level imports, the asset URLs all resolved, and the React render reached its first state. *All four regression classes* fail this invariant.
3. **Tight**: the assertion is "heading is visible AND no uncaught pageerror AND no failed request". Each of the three conditions independently catches a regression class. Together they form a tight, falsifiable assertion that admits no false-pass.

The design notes that supplying a fake gateway and agent would force the bundle into WebSocket connection logic which would fail without a daemon; filtering those errors out would *weaken* the assertion. The fragment-less path is the deterministic, daemon-free state the entry point already implements, so it is the right target for the smoke.

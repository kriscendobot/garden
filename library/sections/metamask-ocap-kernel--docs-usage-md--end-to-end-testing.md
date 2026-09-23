---
title: End-to-End Testing
source: docs/usage.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/usage.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [testing]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]]. Net-new operational/testing surface omitted by the kernel guide.
---

## Abstract

ocap-kernel's end-to-end tests use **Playwright** to exercise the browser extension and kernel together in a real browser. The flow has a hard ordering: bundle vats first (`yarn ocap bundle ./src/vats`, required for every test command), then for `yarn test:e2e` *also* serve the vats in a separate terminal (`yarn ocap serve ./src/vats`), then run `yarn test:e2e` (or `yarn test:e2e:ui` for the watch-and-inspect UI mode, which also needs the served vats). The all-in-one alternative is `yarn test:e2e:ci`, which bundles, serves, and runs in one step. The e2e suite demonstrates complete kernel workflows — extension initialization, launching vats, vat-to-vat message passing, and UI interaction with the kernel control panel. Reports open from `playwright-report/index.html`.

## Body

The project includes Playwright end-to-end tests for the extension and kernel integration in a real browser, run from `packages/extension`:

```bash
cd packages/extension

# 1. Bundle vats first (required for all test commands)
yarn ocap bundle ./src/vats

# 2. For yarn test:e2e, you must also serve the vats in a separate terminal
yarn ocap serve ./src/vats

# 3. Then run E2E tests
yarn test:e2e

# Run E2E tests with UI (also requires the vats to be served)
yarn test:e2e:ui

# ALTERNATIVELY: the CI command bundles vats, serves them, and runs in one step
yarn test:e2e:ci
```

UI mode (`test:e2e:ui`) lets you watch tests execute in real time, see steps and assertions as they happen, explore the DOM and application state at each step, and debug failures visually.

The e2e tests demonstrate complete kernel workflows: extension initialization, launching vats, message passing between vats, and UI interaction with the kernel control panel. To view reports after a run:

```bash
open playwright-report/index.html
```

### Lineage note

The three-step "bundle, serve, then test" ordering — and the `test:e2e:ci` command that folds all three into one — is ocap-kernel's operational answer to testing a confined-code system end to end: the vat bundles are build artifacts that must exist and be served before the browser harness can load them. The garden's own corpus has a sibling pattern in the chat-UI Playwright work (`chat-playwright-smoke`, the daemon-free / fixture-free browser smoke test), and the e2e package-per-platform split (extension for browser, kernel-test for Node) matches the [platform-specific](../sources/metamask-ocap-kernel--docs-platform-specific-md.md) doc's per-platform-test-package convention. This is reference-shelf material: the garden reads ocap-kernel's e2e harness shape, it does not run it.

Source: [docs/usage.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/usage.md) at commit `175b7c0`.

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
  **Status: Not Started** upstream. The "What is the Problem Being
  Solved?" framing for the chat-playwright-smoke design. Names a specific
  regression class — *the Chat production bundle fails to build, parse,
  lockdown, or reach its first user-visible state* — that lands silently
  in CI today, and explains why the sibling `chat-test-coverage` e2e
  suite (Complete; uses `yarn dev` + daemon fixture) is the wrong tool
  for this narrower regression.
parent: endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage
---

The endo-but-for-bots repo already has a `Browser Tests` GitHub Actions workflow (`.github/workflows/browser-test.yml`, job `browser-tests`) that provisions Playwright and exercises the SES UMD bundle in a real browser via `browser-test/tests/canary.spec.js`. But the `@endo/chat` package's substantial Vite-built React/SES bundle is *not* exercised by that job today, so a regression in the Chat entry point — a stray top-level import that fails under SES, a Vite plugin misconfiguration, a dependency upgrade that breaks the bundle, a CSS import that 404s, a runtime error before the WebSocket connection is attempted — currently lands silently. The first signal is a contributor running `yarn dev` locally and seeing a blank page or a `pageerror` in the devtools console. The sibling design `chat-test-coverage.md` (Complete) describes the unit, component, and Playwright e2e tests that already live inside `packages/chat/test/`. Those tests are valuable but they (a) do not currently run in CI, and (b) exercise UI behaviors against `yarn dev` (Vite dev server) and require a daemon-shaped powers fixture; the present design proposes a single Playwright smoke that proves the *production bundle* builds and loads, scoped deliberately narrower than the Chat e2e suite so it can run without a daemon, without `yarn dev`, and without test fixtures.

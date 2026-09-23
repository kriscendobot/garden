---
source: designs/chat-playwright-smoke.md
source_repo: endojs/endo-but-for-bots
source_branch: design/chat-playwright-smoke
source_commit: 2a97b2d6c4c0e1714631fc42f6c34cd78e18db5b
source_date: 2026-05-06
source_authors: [Kris Kowal]
ingested: 2026-05-29
ingested_by: scholar
section_count: 3
status: current
notes: |
  **Status: Not Started** upstream. A narrowly-scoped Playwright smoke
  proving the `@endo/chat` production bundle builds, parses, lockdowns,
  and reaches its first user-visible state without throwing — to be
  added as an additional step in the existing `browser-tests` GitHub
  Actions workflow. Deliberately narrower than the sibling
  `chat-test-coverage` e2e suite (Complete): daemon-free, fixture-free,
  fragment-less navigation reaching the "Gateway not configured"
  deterministic fallback heading. Three sections cover (1) problem
  framing + why the e2e suite is the wrong tool for this regression
  class; (2) build (reuse `yarn build`) + serve (extend
  `browser-test/server.js` preferred; alternative `webServer` entry
  enumerated) + Playwright fixture at `browser-test/tests/chat.spec.js`
  + CI integration; (3) test plan injection-revert pattern + explicit
  out-of-scope + five open questions the maintainer's reading owes the
  design.
---

> Abstract: The endo-but-for-bots `browser-tests` GitHub Actions
> workflow already provisions Playwright and exercises the SES UMD
> bundle in a real browser via `browser-test/tests/canary.spec.js`,
> but the `@endo/chat` package's substantial Vite-built React/SES
> bundle is not exercised by that job today, so a regression in the
> Chat entry point lands silently. This design proposes a single
> Playwright smoke (one new spec at `browser-test/tests/chat.spec.js`)
> that proves the Chat production bundle builds, parses, lockdowns,
> and reaches the "Gateway not configured" deterministic fallback
> heading without throwing or 404'ing. Deliberately narrower than the
> sibling `chat-test-coverage` e2e suite — daemon-free, fixture-free,
> fragment-less navigation — so it can run in the existing CI job
> without infrastructure additions. Three open questions the maintainer
> still owes the design: browser engine scope, console-error /
> failed-request strictness, serve mechanism (extend
> `browser-test/server.js` preferred), and whether to upload a
> screenshot artifact.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-framing-and-relationship-to-chat-test-coverage](../sections/endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage.md) | chat-ui, testing | current |
| [build-serve-and-playwright-fixture](../sections/endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture.md) | chat-ui, testing | current |
| [test-plan-and-open-questions](../sections/endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions.md) | chat-ui, testing | current |

The design's six sections (What is the Problem Being Solved? + Design + Dependencies + Test Plan + Open Questions + Prompt) collapse to three argument-cluster sections. §Problem + design's relationship to chat-test-coverage → section 1; §Design (build / serve / fixture / CI integration) + §Dependencies → section 2; §Test Plan + §Open Questions + §Prompt → section 3.

## Provenance

- Fetched 2026-05-29 from `endojs/endo-but-for-bots@2a97b2d6c4c0e1714631fc42f6c34cd78e18db5b` (the file's last-modifying commit on `origin/design/chat-playwright-smoke`).
- File last modified 2026-05-06 by Kriscendo Bot (the bot identity for the maintainer's prompt-driven design dispatches).
- Verified via bare-clone listing before drafting (cycle 73 / 74 verify-bare-clone discipline). Note: the file is at `designs/chat-playwright-smoke.md` on this branch (not `llm/designs/`); the slug retains the `endo-but-for-bots--llm-designs-` prefix per the library's path-encoding convention.

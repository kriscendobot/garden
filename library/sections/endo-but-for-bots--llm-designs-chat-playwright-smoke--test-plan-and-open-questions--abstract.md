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
  **Status: Not Started** upstream. The validation + decisions cluster
  of the chat-playwright-smoke design: how to verify the smoke catches
  what it claims to via deliberate injection + revert; what is
  explicitly out of scope; and five open questions the maintainer's
  reading owes the design before it can be implemented.
parent: endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions
---

§Test Plan claims the proposed smoke *catches build-and-load regressions in the Chat bundle*; §Test Plan offers two verification steps that prove the claim once the smoke is implemented: (1) **on a clean tree the spec passes** — `cd browser-test && npx playwright test tests/chat.spec.js`; (2) **inject a deliberate regression** (rename a top-level import in `packages/chat/main.js` to a missing module; rebuild; rerun the spec) **and confirm the spec fails** with a `pageerror` or a missing heading; revert and confirm the spec passes again. The §Test Plan also explicitly enumerates what is **out of scope** for this design, deferred to follow-up coverage: interaction tests (typing in the command bar, sending a message, inventory rendering); tests that require a live daemon or a mocked gateway; visual regression / screenshot diffs; cross-browser coverage beyond what the existing `browser-tests` job exercises. §Open Questions lists **five decisions the maintainer's reading owes the design**: (1) browser engine scope — only the `chrome-dev` project the canary uses, or also `chromium` / `firefox` / `webkit`? (2) console-error strictness — fail on `pageerror` only (the proposal) or also fail on `console.error` calls? (3) failed-request strictness — strict on all 404s, or filter to same-origin only? (4) serve mechanism — extend `browser-test/server.js` or add a second `webServer` entry? (the design recommends the former in §Design but the open question explicitly invites a maintainer override) (5) screenshot artifact — should the smoke upload a screenshot to the existing `actions/upload-artifact` step for after-the-fact inspection? §Prompt closes by recording the original ask: *"Please dispatch a designer to propose verifying that the Chat application builds and loads properly in Playwright. This should be added to the existing browser CI job."*

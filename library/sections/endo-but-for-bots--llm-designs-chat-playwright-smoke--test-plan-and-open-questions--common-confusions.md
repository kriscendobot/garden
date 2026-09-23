---
title: Common confusions
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

- **"Why is the §Test Plan so short?"** Because the smoke's claim is also short — *the smoke catches build-and-load regressions in the Chat bundle*. A short claim deserves a short verification. The two-step injection-revert pattern is sufficient to prove the claim is falsifiable in the right direction. Heavier validation (e.g. mutation testing) would be appropriate for a heavier claim.
- **"The §Open Questions delay implementation."** They surface decisions; they do not *block* implementation. The designer can implement the design with the §Design defaults (approach 2 for serve; `pageerror`-only for console-error; strict for failed-request; chrome-dev only for engine; no screenshot artifact) and revisit each question if the implementation surfaces a need to revisit.
- **"`console.error` should always be a failure."** Not if the entry point legitimately uses `console.error` for diagnostic output. The §Open Question makes this explicit; the maintainer must make the call about whether the production Chat bundle's `console.error` calls are *ever* legitimate.
- **"Cross-browser coverage is essential for a web app."** It is essential for the *broader* test surface; it may not be essential for the *smoke*. The smoke catches bundle-load regressions, which are mostly engine-agnostic (SES, Vite, module-resolution). Engine-specific regressions (e.g. webkit-specific timing) are caught by a *separate* test surface that the design explicitly defers. The §Open Question lets the maintainer choose how aggressive to be.
- **"The §Prompt is just historical."** It is *load-bearing context*. Future readers can reconcile the design's scope against the original ask. A design that drifts from its prompt — e.g. by including interaction tests after being asked to "verify Chat builds and loads" — is a signal of scope creep.

---
title: Connection to the wider library
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

This section is the **validation-and-decision template for a narrow CI guard design**. The library can cite this section whenever:

1. **A design needs an injection-revert verification pattern.** The §Test Plan's two-step pattern (clean-tree pass + deliberate-regression fail + revert pass) is the canonical way to prove a regression-catching test is *falsifiable in the right direction*. Generalizes to any test that claims to catch a specific regression class.
2. **A design needs an explicit out-of-scope list.** The §Test Plan's enumeration is the *negative spec*: what the design does *not* claim to do. Worth including in any design that's bounded in scope to avoid future readers misattributing failures to the design's surface.
3. **A design defers decisions to the maintainer via §Open Questions.** Each question is a single, mutually-exclusive decision with the design's preferred default. The form is reusable: *here is the question; here are the trade-offs; here is my recommendation (if any); the maintainer's call*.

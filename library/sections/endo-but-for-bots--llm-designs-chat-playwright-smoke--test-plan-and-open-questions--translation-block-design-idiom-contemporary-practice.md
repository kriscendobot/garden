---
title: Translation block (design idiom → contemporary practice)
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

| Design concept | Contemporary practice |
| -------------- | --------------------- |
| Injection-revert verification | A standard test-the-test discipline; `git stash` the regression, run, restore. Used in TDD; the design's §Test Plan formalizes it. |
| §Out-of-scope explicit enumeration | "Negative requirements" in product spec language; the design uses bullet list. Helps future readers understand the design's boundaries. |
| §Open Questions with maintainer-call markers | The convention used across endo-but-for-bots designs; lets the designer surface decisions without resolving them, preserving the maintainer's judgment. |
| §Prompt subsection preserving the original ask | A norm of the *designs-with-Prompt-recorded* convention; lets reviewers reconcile the design against the original ask. |

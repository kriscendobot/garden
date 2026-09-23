---
title: See also
source: designs/chat-rename-dismiss-to-clear.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8e5058304b08a4ec590a8bdcc799f78b321d5726
source_date: 2026-05-20
source_authors: [Kris Kowal]
topics: [chat-ui, repository-governance]
status: current
notes: |
  **Status: Complete** upstream (PR #93, merged 2026-05-06). A bounded
  PR-merge decision record + post-implementation retrospective. The
  document's small size (75 lines, four subsections) is honestly
  captured as a single library section rather than padded to a
  three-section ingest. The retrospective is structurally interesting
  for three reasons: (1) explicit *deprecation-period alias* retention
  pattern on the CLI side; (2) chat-vs-CLI alias asymmetry (chat had
  not shipped the command pre-rename, so no deprecation surface
  needed there); (3) *roadmap calibration* — explicit git-blame
  analysis of active-development calendar with three implementation
  bursts separated by long unattended gaps (2026-03-17 / 2026-03-20 /
  2026-05-06).
parent: endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record
---

- [[chat-ui]] (topic) — the broader chat-UI surface.
- [[repository-governance]] (topic) — the deprecation-period-alias is a governance discipline that applies to any command-rename.
- `endo-but-for-bots--llm-designs-chat-command-bar` — the command-bar that gained the `/clear` command.
- `endo-but-for-bots--llm-designs-chat-test-coverage--*` (cycle 92) — the regression test (clear-command.test.js) lives alongside the broader test suite documented there.
- `endo-but-for-bots--llm-designs-chat-pending-commands--*` — adjacent chat-bar design from a similar timeframe.

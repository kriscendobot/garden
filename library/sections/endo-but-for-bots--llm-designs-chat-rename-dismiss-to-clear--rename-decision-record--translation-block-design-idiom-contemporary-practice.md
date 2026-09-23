---
title: Translation block (design idiom → contemporary practice)
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

| Design concept | Contemporary practice |
| -------------- | --------------------- |
| Hidden CLI alias for deprecation | The standard rename-with-alias pattern; existing scripts keep working; new docs point to the new name. |
| Chat-vs-CLI asymmetry | Add deprecation surface only when there are existing users; don't carry weight you don't need. |
| Internal-vs-external naming separation | The daemon's `dismissAll()` method name unchanged; the user-facing command name changes. Two layers, two evolution constraints. |
| Roadmap calibration via git-blame | Post-merge introspection of actual cycle-time; cite for future planning. |
| Tab-completion shortest-common-prefix advancement | The standard interactive-CLI completion behavior. |
| Verbose-and-unfamiliar → conventional name | Naming-by-convention; align with established term in the domain. |
